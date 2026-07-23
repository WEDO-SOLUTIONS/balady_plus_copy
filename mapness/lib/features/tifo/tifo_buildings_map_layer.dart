import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/building_sheet.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/district_sheet.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_poller.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_districts_provider.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Renders the TIFO layer on the dgis map with a zoom-based level of detail
/// (API v2.4 §3):
///   * zoom < 16  → district polygons tinted by the leading club;
///   * zoom >= 16 → individual buildings colored by owner, tappable to play.
///
/// Owns two independent [MapObjectManagerMessage]s so the two layers can be
/// cleared/redrawn without touching each other or the debug district layer.
class TifoBuildingsMapLayer extends Notifier<bool> {
  MapObjectManagerMessage? _buildingsManager;
  MapObjectManagerMessage? _districtsManager;
  StreamSubscription<VisibleRectEvent>? _visibleSub;
  Timer? _debounce;
  String? _lastBbox;
  bool _districtsDrawn = false;
  double _zoom = 0;

  /// What's currently painted per building id — drives the pointwise diff
  /// redraw (recolor only what changed) instead of clearing the whole layer.
  final Map<String, int> _drawnFill = {};
  final Map<String, int> _drawnRings = {};

  /// Same diff bookkeeping for the district layer.
  final Map<String, int> _drawnDistrictFill = {};
  final Map<String, int> _drawnDistrictRings = {};

  /// Single-flight gate for tap-opened sheets. dgis fires onTap for EVERY
  /// polygon under the finger (overlapping rings, shared district borders)
  /// and iOS occasionally double-delivers the event — without the gate one
  /// tap stacks two identical sheets.
  bool _sheetShowing = false;
  DateTime _lastSheetOpen = DateTime.fromMillisecondsSinceEpoch(0);

  bool _acquireSheetGate() {
    final now = DateTime.now();
    if (_sheetShowing || now.difference(_lastSheetOpen) < const Duration(milliseconds: 600)) {
      return false;
    }
    _lastSheetOpen = now;
    _sheetShowing = true;
    return true;
  }

  /// At/above this zoom we show buildings; below it, districts. API §3 says 16,
  /// but this map's `visibleRectEvent.zoom` reads ~1 lower than the camera's
  /// zoom, so 16 is effectively unreachable on that stream — 15 is the real
  /// street-level threshold here.
  static const double _buildingMinZoom = 15;

  /// Safety cap on TOTAL buildings kept on the map (they accumulate — nothing is
  /// removed on pan), to bound the bridge/render cost on long sessions.
  static const int _maxRendered = 1000;

  bool get _buildingsMode => _zoom >= _buildingMinZoom;

  @override
  bool build() {
    ref
      ..listen<TifoBuildingsState>(tifoBuildingsProvider, (_, next) {
        if (state && _buildingsMode) {
          unawaited(_syncBuildings(next));
        }
      })
      ..listen<TifoDistrictsState>(tifoDistrictsProvider, (_, next) {
        if (state && !_buildingsMode) {
          unawaited(_redrawDistricts(next));
        }
      })
      ..onDispose(_teardown);
    return false; // disabled
  }

  bool get isEnabled => state;

  Future<void> enable() async {
    if (state) {
      return;
    }
    state = true;
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      _buildingsManager ??= await controller.createMapObjectManager(layerId: MapObjectLayers.defaultLayerId);
      _districtsManager ??= await controller.createMapObjectManager(layerId: MapObjectLayers.defaultLayerId);

      _visibleSub = controller.visibleRectEvents.listen((event) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 400), () {
          unawaited(_onViewport(event.visibleRect));
        });
      });

      // Seed zoom + first render from the current camera.
      try {
        final pos = await controller.getCameraPosition();
        _zoom = pos.zoom;
      } catch (_) {
        // Leave zoom at 0 → districts mode until the first visibleRectEvent.
      }
      logger.log('[tifo-map] enabled: zoom=$_zoom → ${_buildingsMode ? "buildings" : "districts"} mode');
      // Long-poll building state while the layer is up (diff → pointwise redraw).
      ref.read(tifoBuildingsPollerProvider.notifier).start();
      // Right after enable the map often isn't ready to report its visible area
      // yet, so buildings mode would draw nothing until the user pans. Retry a
      // few times to render immediately. (Districts mode ignores bbox.)
      String? bbox;
      for (var attempt = 0; attempt < 6 && state; attempt++) {
        bbox = await _currentBbox(controller);
        if (bbox != null || !_buildingsMode) {
          break;
        }
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
      if (state) {
        await _applyForViewport(bbox);
      }
    } catch (error, stackTrace) {
      logger.log('TIFO layer enable failed: $error\n$stackTrace');
    }
  }

  Future<void> disable() async {
    if (!state) {
      return;
    }
    state = false;
    _debounce?.cancel();
    await _visibleSub?.cancel();
    _visibleSub = null;
    _lastBbox = null;
    _districtsDrawn = false;
    _drawnFill.clear();
    _drawnRings.clear();
    _drawnDistrictFill.clear();
    _drawnDistrictRings.clear();
    ref.read(tifoBuildingsPollerProvider.notifier).stop();
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      if (_buildingsManager != null) {
        await controller.removeAllPolygons(fromManager: _buildingsManager);
      }
      if (_districtsManager != null) {
        await controller.removeAllPolygons(fromManager: _districtsManager);
      }
    } catch (_) {
      // Map already gone.
    }
    // Keep the geometry cache (cheap re-enable); just drop the viewport set.
    ref.read(tifoBuildingsProvider.notifier).clearViewport();
  }

  Future<void> _onViewport(VisibleRect rect) async {
    _zoom = rect.zoom;
    await _applyForViewport(
      '${rect.southWestLon},${rect.southWestLat},${rect.northEastLon},${rect.northEastLat}',
    );
  }

  /// Routes the current viewport to the right layer for the zoom level.
  ///
  /// Buildings depend on the viewport (fetch per bbox); districts are a
  /// city-wide static layer, so they're drawn once on entry — NOT on every pan
  /// (413 polygons/frame would flood the bridge and jank the map).
  Future<void> _applyForViewport(String? bbox) async {
    if (!state) {
      return;
    }
    if (_buildingsMode) {
      if (_districtsDrawn) {
        await _clearDistricts();
        _districtsDrawn = false;
      }
      // Repaint whatever geometry is already cached (persists across pans /
      // district-mode round-trips), then discover new buildings for the bbox.
      await _syncBuildings(ref.read(tifoBuildingsProvider));
      if (bbox != null && bbox != _lastBbox) {
        _lastBbox = bbox;
        logger.log('[tifo-map] buildings mode (zoom=$_zoom): fetch $bbox');
        await ref.read(tifoBuildingsProvider.notifier).fetchForBbox(bbox);
      }
    } else {
      if (_lastBbox != null) {
        await _clearBuildings();
        _lastBbox = null;
      }
      if (_districtsDrawn) {
        return; // already painted; panning within districts mode is a no-op
      }
      logger.log('[tifo-map] districts mode (zoom=$_zoom): loading…');
      await ref.read(tifoDistrictsProvider.notifier).ensureLoaded();
      final st = ref.read(tifoDistrictsProvider);
      logger.log(
        '[tifo-map] districts loaded: ${st.districts.length} geom, ${st.summaries.length} summaries, err=${st.error}',
      );
      await _redrawDistricts(st);
      _districtsDrawn = st.districts.isNotEmpty;
    }
  }

  Future<String?> _currentBbox(DgisMapController controller) async {
    try {
      final area = await controller.getVisibleArea();
      final pts = <GeoPointMessage>[];
      for (final c in area.contours) {
        if (c is PolylineGeometryMessage) {
          pts.addAll(c.points);
        }
      }
      if (pts.isEmpty) {
        return null;
      }
      var minLat = pts.first.latitude, maxLat = pts.first.latitude;
      var minLng = pts.first.longitude, maxLng = pts.first.longitude;
      for (final p in pts) {
        minLat = p.latitude < minLat ? p.latitude : minLat;
        maxLat = p.latitude > maxLat ? p.latitude : maxLat;
        minLng = p.longitude < minLng ? p.longitude : minLng;
        maxLng = p.longitude > maxLng ? p.longitude : maxLng;
      }
      return '$minLng,$minLat,$maxLng,$maxLat';
    } catch (_) {
      return null;
    }
  }

  // ─── Buildings (zoom >= 16) ────────────────────────────────────────────────

  /// Pointwise, accumulating redraw: every building ever fetched stays on the
  /// map (cached geometry) — we only ADD newly-discovered buildings and recolor
  /// those whose owner changed (poll). Nothing is removed when it leaves the
  /// viewport, so panning back is instant and the map fills in over time.
  Future<void> _syncBuildings(TifoBuildingsState st) async {
    final manager = _buildingsManager;
    if (manager == null) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);

      // Add new / recolor changed across the whole cache (not just the viewport).
      // The plugin only removes polygons one id at a time, so removals for a
      // recolor are collected and fired CONCURRENTLY — N parallel bridge calls
      // instead of N serialized round-trips — followed by one addPolygons batch.
      final toAdd = <Polygon>[];
      final toRemove = <String>[];
      for (final building in st.byId.values) {
        final club = building.ownerClub;
        final fill = club?.fillArgb ?? kTifoNeutralFillArgb;
        final stroke = club?.strokeArgb ?? kTifoNeutralStrokeArgb;
        final prev = _drawnFill[building.id];
        if (prev == fill) {
          continue; // already drawn, unchanged → keep it
        }
        if (prev == null && _drawnFill.length >= _maxRendered) {
          continue; // safety cap on total drawn (recolors of existing still apply)
        }
        if (prev != null) {
          final rings = _drawnRings[building.id] ?? 0;
          for (var i = 0; i < rings; i++) {
            toRemove.add('tifo-bld:${building.id}#$i'); // recolor → replace
          }
        }
        for (var i = 0; i < building.rings.length; i++) {
          toAdd.add(
            Polygon(
              id: 'tifo-bld:${building.id}#$i',
              onTap: () => _openBuilding(building),
              options: PolygonOptionsMessage(
                contours: [
                  PolylineGeometryMessage(
                    points: [
                      for (final p in building.rings[i]) GeoPointMessage(latitude: p.latitude, longitude: p.longitude),
                    ],
                  ),
                ],
                color: fill,
                strokeColor: stroke,
                strokeWidth: club == null ? 1.5 : 2,
              ),
            ),
          );
        }
        _drawnFill[building.id] = fill;
        _drawnRings[building.id] = building.rings.length;
      }
      if (toRemove.isNotEmpty) {
        await Future.wait(toRemove.map((id) => controller.removePolygon(id, fromManager: manager)));
      }
      if (toAdd.isNotEmpty) {
        await controller.addPolygons(toAdd, toManager: manager);
      }
    } catch (error, stackTrace) {
      logger.log('[tifo-map] buildings sync failed: $error\n$stackTrace');
    }
  }

  Future<void> _clearBuildings() async {
    _drawnFill.clear();
    _drawnRings.clear();
    final manager = _buildingsManager;
    if (manager == null) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      await controller.removeAllPolygons(fromManager: manager);
    } catch (_) {}
  }

  void _openBuilding(TifoBuilding building) {
    final context = rootNavigatorKey.currentContext;
    if (context == null || !_acquireSheetGate()) {
      return;
    }
    unawaited(showTifoBuildingSheet(context, building).whenComplete(() => _sheetShowing = false));
  }

  // ─── Districts (zoom < 16) ─────────────────────────────────────────────────

  /// Pointwise diff repaint, mirroring the buildings path: a summaries refresh
  /// repaints ONLY the districts whose leader color actually changed (usually
  /// 0–2) instead of a full removeAll + ~413-polygon re-add storm through the
  /// bridge on every poll.
  Future<void> _redrawDistricts(TifoDistrictsState districtsState) async {
    final manager = _districtsManager;
    if (manager == null || districtsState.districts.isEmpty) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      final toAdd = <Polygon>[];
      final toRemove = <String>[];
      for (final district in districtsState.districts) {
        final summary = districtsState.summaries[district.id];
        // leaderColor is server-side paint-ready — the leader's hex OR the
        // neutral palette color — so use it directly (fallback grey if absent).
        final baseArgb = summary?.leaderColorArgb ?? 0xFF9DA4AE;
        final fill = (baseArgb & 0x00FFFFFF) | 0x40000000;
        final prev = _drawnDistrictFill[district.id];
        if (prev == fill) {
          continue; // unchanged → keep the drawn polygons
        }
        if (prev != null) {
          final rings = _drawnDistrictRings[district.id] ?? 0;
          for (var i = 0; i < rings; i++) {
            toRemove.add('tifo-dist:${district.id}#$i'); // recolor → replace
          }
        }
        for (var i = 0; i < district.rings.length; i++) {
          toAdd.add(
            Polygon(
              id: 'tifo-dist:${district.id}#$i',
              onTap: () => _onDistrictTap(district),
              options: PolygonOptionsMessage(
                contours: [
                  PolylineGeometryMessage(
                    points: [
                      for (final p in district.rings[i]) GeoPointMessage(latitude: p.latitude, longitude: p.longitude),
                    ],
                  ),
                ],
                color: fill,
                strokeColor: (baseArgb & 0x00FFFFFF) | 0xCC000000,
                strokeWidth: 1.5,
              ),
            ),
          );
        }
        _drawnDistrictFill[district.id] = fill;
        _drawnDistrictRings[district.id] = district.rings.length;
      }
      if (toRemove.isNotEmpty) {
        await Future.wait(toRemove.map((id) => controller.removePolygon(id, fromManager: manager)));
      }
      if (toAdd.isNotEmpty) {
        logger.log(
          '[tifo-map] districts diff: ${toAdd.length} polygons repainted, '
          '${districtsState.districts.length} total',
        );
        await controller.addPolygons(toAdd, toManager: manager);
      }
    } catch (error, stackTrace) {
      logger.log('[tifo-map] districts redraw failed: $error\n$stackTrace');
    }
  }

  Future<void> _clearDistricts() async {
    _drawnDistrictFill.clear();
    _drawnDistrictRings.clear();
    final manager = _districtsManager;
    if (manager == null) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      await controller.removeAllPolygons(fromManager: manager);
    } catch (_) {}
  }

  /// District details sheet (BRD US-06, Figma node 696:119272). The summary is
  /// read at TAP time — unchanged polygons keep their original onTap closure
  /// across diff repaints, so a captured summary would go stale.
  void _onDistrictTap(TifoDistrict district) {
    final context = rootNavigatorKey.currentContext;
    if (context == null || !_acquireSheetGate()) {
      return;
    }
    final summary = ref.read(tifoDistrictsProvider).summaries[district.id];
    unawaited(
      showTifoDistrictSheet(context, district: district, summary: summary).whenComplete(() => _sheetShowing = false),
    );
  }

  void _teardown() {
    _debounce?.cancel();
    unawaited(_visibleSub?.cancel());
  }
}

final tifoBuildingsMapLayerProvider = NotifierProvider<TifoBuildingsMapLayer, bool>(TifoBuildingsMapLayer.new);
