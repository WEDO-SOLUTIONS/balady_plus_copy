import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/building_sheet.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/data/tifo_region_outline.dart';
import 'package:mapness/features/tifo/district_sheet.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_poller.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_districts_provider.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Whether TIFO itself is allowed to run right now. TIFO is NOT a city event
/// (it doesn't compete for `ActiveCityEvent`'s single slot — see that
/// provider's own pre-emption of city events when TIFO is on), but its
/// Remote Config schedule reuses the exact same date-range shape
/// (`CityEventDateRange.tifoDefault`: 12 Aug 2026 through end of Oct 2026,
/// a placeholder until the backend ships its own `tifoDateRange` value).
/// While the environment config hasn't loaded yet, defaults to unavailable —
/// a missing schedule means the game is off, not on by default.
final tifoAvailableProvider = Provider<bool>((ref) {
  final env = ref.watch(dgisEnvironmentProvider).value;
  return env?.tifoDateRange.isVisibleNow ?? false;
});

/// Level of detail the TIFO layer renders at, picked from the camera zoom.
enum _TifoLod {
  /// Zoomed far out: a single bundled region-outline polygon
  /// ([kTifoRegionOutline]) painted in the SEASON leader's color. At that
  /// scale district borders aren't legible, so the region silhouette carries
  /// the same information as a 413-polygon mosaic — and it needs no
  /// `GET /districts` round-trip to appear.
  cluster,

  /// Mid range: each district in its own leading club's color.
  districts,

  /// Street level: individual buildings, colored by owner and tappable.
  buildings,
}

/// Renders the TIFO layer on the dgis map with a zoom-based level of detail
/// (API v2.4 §3, plus the city-wide cluster tier below it):
///   * zoom <= 11 → ONE region-outline polygon in the season leader's color;
///   * zoom < 15  → district polygons tinted by each district's leading club;
///   * zoom >= 15 → individual buildings colored by owner, tappable to play.
///
/// Owns two independent [MapObjectManagerMessage]s so the two layers can be
/// cleared/redrawn without touching each other or the debug district layer.
class TifoBuildingsMapLayer extends Notifier<bool> {
  MapObjectManagerMessage? _buildingsManager;
  MapObjectManagerMessage? _districtsManager;
  StreamSubscription<VisibleRectEvent>? _visibleSub;
  Timer? _debounce;
  String? _lastBbox;

  /// LOD the district layer is currently painted at, or null when it isn't
  /// painted. LOD-aware rather than a plain bool because [_TifoLod.cluster]
  /// and [_TifoLod.districts] draw the SAME polygons in different colors — a
  /// bool would let a zoom across the cluster threshold hit the
  /// "already drawn, nothing to do" early-out and never repaint.
  _TifoLod? _drawnDistrictsLod;

  /// Fill currently painted for the cluster tier's region polygon, or null
  /// when it isn't on the map — same pointwise-diff bookkeeping the district
  /// and building layers use, so a standings poll that doesn't change the
  /// leader costs no bridge calls at all.
  int? _drawnRegionFill;

  /// Camera tilt the player had before the overlay forced the 2D view, so it
  /// can be restored on [disable]. Null once restored / never tilted.
  double? _tiltBeforeEnable;

  /// Anything at or below this counts as already flat — the SDK reports tiny
  /// residual tilts after an animation, and re-animating on those would make
  /// the camera twitch on every viewport event.
  static const double _flatTiltEpsilon = 0.5;
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

  /// At/below this zoom the district layer collapses into one city-wide color
  /// (see [_TifoLod.cluster]). Same `visibleRectEvent.zoom` units as
  /// [_buildingMinZoom] above — i.e. roughly one lower than camera zoom.
  static const double _districtClusterMaxZoom = 11;

  /// Fallback district fill when nobody leads it (or the server sent no
  /// paint-ready color): the neutral palette grey.
  static const int _neutralDistrictArgb = 0xFFFCFBF2;

  /// Single polygon id for the cluster tier's region silhouette.
  static const String _regionPolygonId = 'tifo-region';

  /// Safety cap on TOTAL buildings kept on the map, to bound the bridge/render
  /// cost on long sessions. Viewport-aware: on-screen buildings evict
  /// off-screen ones when the cap is hit (see [_syncBuildings]). Sized above a
  /// dense single viewport — ~1500 buildings observed live at z16 in Riyadh.
  static const int _maxRendered = 2000;

  _TifoLod get _lod {
    if (_zoom >= _buildingMinZoom) {
      return _TifoLod.buildings;
    }
    // `_zoom == 0` means "the camera never reported a zoom" (see `enable`),
    // not "zoomed all the way out" — painting the entire city one color off
    // that guess would be a worse first frame than per-district paint.
    if (_zoom > 0 && _zoom <= _districtClusterMaxZoom) {
      return _TifoLod.cluster;
    }
    return _TifoLod.districts;
  }

  bool get _buildingsMode => _lod == _TifoLod.buildings;

  /// Hive box + key the ⚽ toggle is persisted under, so a killed/relaunched
  /// app comes back up with the layer in the state the player left it in
  /// instead of always cold-starting disabled.
  static const String _persistBoxName = 'tifo';
  static const String _persistKey = 'layerEnabled';

  @override
  bool build() {
    ref
      ..listen<TifoBuildingsState>(tifoBuildingsProvider, (_, next) {
        if (state && _buildingsMode) {
          unawaited(_syncBuildings(next));
        }
      })
      ..listen<TifoDistrictsState>(tifoDistrictsProvider, (_, next) {
        if (!state || _buildingsMode) {
          return;
        }
        // Standings only tint the region at the cluster tier; the polygon
        // itself is already on screen from bundled geometry.
        if (_lod == _TifoLod.cluster) {
          unawaited(_redrawRegion(next));
        } else {
          unawaited(_redrawDistricts(next));
        }
      })
      // Fill colors are resolved from `session.clubById` at draw time (see
      // `_syncBuildings`, and `_seasonLeaderColor` for the cluster LOD), but
      // the clubs roster loads asynchronously and can still be empty on the
      // very first draw — those polygons get stamped into the `_drawn*` maps
      // as neutral and the diff redraw then skips them forever, since nothing
      // else re-triggers a sync until the game state itself changes (e.g.
      // after finishing a game). Repaint once the roster actually changes, so
      // claimed buildings and the cluster tint pick up their club's color as
      // soon as it's known, without waiting on a game.
      ..listen<TifoSessionState>(tifoSessionProvider, (prev, next) {
        if (!state || identical(prev?.clubs, next.clubs)) {
          return;
        }
        if (_buildingsMode) {
          unawaited(_syncBuildings(ref.read(tifoBuildingsProvider)));
        } else if (_lod == _TifoLod.cluster) {
          unawaited(_redrawRegion(ref.read(tifoDistrictsProvider)));
        } else {
          unawaited(_redrawDistricts(ref.read(tifoDistrictsProvider)));
        }
      })
      // The Remote Config schedule can close mid-session (an admin ends the
      // event window while players are on the map) — turn the layer off
      // itself rather than leaving an unschedulable game running.
      ..listen<bool>(tifoAvailableProvider, (_, available) {
        if (!available && state) {
          logger.log('[tifo-map] disabling: tifoDateRange no longer visible');
          unawaited(disable());
        }
      })
      ..onDispose(_teardown);
    // Fire-and-forget: restore the persisted toggle once the Hive box opens
    // and the native map is ready — `enable()` awaits `dgisControllerProvider`
    // itself, so this doesn't race the map's own startup.
    unawaited(_restorePersistedState());
    return false; // disabled until the restore above (if any) flips it on
  }

  Future<void> _restorePersistedState() async {
    try {
      final box = await ref.read(hiveProvider(_persistBoxName).future);
      if (!ref.mounted) {
        return;
      }
      if (box.get(_persistKey) == true && ref.read(tifoAvailableProvider)) {
        await enable();
      }
    } catch (error, stackTrace) {
      logger.log('[tifo-map] failed to restore persisted layer state: $error\n$stackTrace');
    }
  }

  Future<void> _persistEnabled(bool enabled) async {
    try {
      final box = await ref.read(hiveProvider(_persistBoxName).future);
      if (!ref.mounted) {
        return;
      }
      await box.put(_persistKey, enabled);
    } catch (error, stackTrace) {
      logger.log('[tifo-map] failed to persist layer state: $error\n$stackTrace');
    }
  }

  bool get isEnabled => state;

  Future<void> enable() async {
    if (state || !ref.read(tifoAvailableProvider)) {
      return;
    }
    state = true;
    unawaited(_persistEnabled(true));
    // Polygon colors are resolved from the clubs roster (`session.clubById`
    // in `_syncBuildings`, `_seasonLeaderColor` for the cluster tint), and
    // turning the layer on is not itself a play-intent — so nothing else in
    // this path loads the session. A player who dismissed the entry popup
    // with (X), or came back to a Hive-restored layer after a relaunch, was
    // left staring at an all-neutral map until some sheet happened to call
    // `load()`; pressing a CTA then "repainted the map", which reads as the
    // colors being a reward for tapping. Roster and config are public (the
    // guest bearer works), so this is safe while signed out.
    // Fire-and-forget: the `tifoSessionProvider` listener in `build` repaints
    // whatever is already drawn once the roster lands.
    if (ref.read(tifoSessionProvider).clubs.isEmpty) {
      unawaited(ref.read(tifoSessionProvider.notifier).load());
    }
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
      logger.log('[tifo-map] enabled: zoom=$_zoom → ${_lod.name} mode');
      // BRD V2 US-05 BR-05: "The map should be shown in 2D view (bird eye
      // view)". A tilted camera also hides the flat capture polygons behind
      // the host map's 3D buildings, so this is functional, not just visual.
      await _forceTopDown(controller);
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
    unawaited(_persistEnabled(false));
    _debounce?.cancel();
    await _visibleSub?.cancel();
    _visibleSub = null;
    _lastBbox = null;
    _drawnDistrictsLod = null;
    _drawnRegionFill = null;
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
      // The 2D view is a TIFO rule, not the host map's — give the player
      // their tilted view back when the overlay goes away.
      await _restoreTilt(controller);
    } catch (_) {
      // Map already gone.
    }
    // Keep the geometry cache (cheap re-enable); just drop the viewport set.
    ref.read(tifoBuildingsProvider.notifier).clearViewport();
  }

  Future<void> _onViewport(VisibleRect rect) async {
    _zoom = rect.zoom;
    // Keep the game view flat (BR-05). Re-asserted here rather than on a
    // camera stream: this runs debounced, after the gesture settles, so a
    // tilt gesture is undone once instead of being fought frame by frame.
    try {
      await _forceTopDown(await ref.read(dgisControllerProvider.future));
    } catch (_) {
      // Map gone — the redraw below will fail loudly enough.
    }
    await _applyForViewport(
      '${rect.southWestLon},${rect.southWestLat},${rect.northEastLon},${rect.northEastLat}',
    );
  }

  /// Flattens the camera to a bird-eye view, remembering the tilt the player
  /// had so [disable] can hand their 3D view back. No-op when already flat,
  /// so the debounced re-assert costs one `getCameraPosition` per viewport.
  Future<void> _forceTopDown(DgisMapController controller) async {
    try {
      final pos = await controller.getCameraPosition();
      if (pos.tilt <= _flatTiltEpsilon) {
        return;
      }
      _tiltBeforeEnable ??= pos.tilt;
      logger.log('[tifo-map] flattening camera: tilt ${pos.tilt.toStringAsFixed(1)} → 0 (BRD 2D view)');
      await controller.moveCamera(
        CameraPositionMessage(point: pos.point, zoom: pos.zoom, tilt: 0, bearing: pos.bearing),
        0.25,
        CameraAnimationTypeMessage.linear,
      );
    } catch (error) {
      logger.log('[tifo-map] camera flatten failed: $error');
    }
  }

  /// Puts the player's original tilt back when the overlay goes away.
  Future<void> _restoreTilt(DgisMapController controller) async {
    final tilt = _tiltBeforeEnable;
    _tiltBeforeEnable = null;
    if (tilt == null || tilt <= _flatTiltEpsilon) {
      return;
    }
    try {
      final pos = await controller.getCameraPosition();
      await controller.moveCamera(
        CameraPositionMessage(point: pos.point, zoom: pos.zoom, tilt: tilt, bearing: pos.bearing),
        0.25,
        CameraAnimationTypeMessage.linear,
      );
    } catch (_) {
      // Map gone; nothing to restore onto.
    }
  }

  /// Routes the current viewport to the right layer for the zoom level.
  ///
  /// Buildings depend on the viewport (fetch per bbox); districts are a
  /// city-wide static layer, so they're drawn once per LOD on entry — NOT on
  /// every pan (413 polygons/frame would flood the bridge and jank the map).
  Future<void> _applyForViewport(String? bbox) async {
    if (!state) {
      return;
    }
    final lod = _lod;
    if (lod == _TifoLod.buildings) {
      if (_drawnDistrictsLod != null) {
        await _clearDistricts();
        _drawnDistrictsLod = null;
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
      if (_drawnDistrictsLod == lod) {
        return; // already painted at this LOD; panning within it is a no-op
      }
      // The tier changed, so whatever the other one left in this manager goes
      // (413 district polygons, or the region silhouette).
      await _clearDistricts();
      if (lod == _TifoLod.cluster) {
        // Region geometry is bundled ([kTifoRegionOutline]), so paint FIRST
        // and ask the network after: the far-out view fills in on the same
        // frame instead of after a `/districts` round-trip, and standings —
        // which only pick the tint — arrive on their own schedule. No
        // `ensureLoaded()` here on purpose: the cluster tier never needs the
        // ~413 district geometries, so it must not pay for fetching them.
        logger.log('[tifo-map] cluster mode (zoom=$_zoom): painting region outline');
        await _redrawRegion(ref.read(tifoDistrictsProvider));
        _drawnDistrictsLod = lod;
        unawaited(ref.read(tifoDistrictsProvider.notifier).refreshSummaries());
        return;
      }
      logger.log('[tifo-map] ${lod.name} mode (zoom=$_zoom): loading…');
      await ref.read(tifoDistrictsProvider.notifier).ensureLoaded();
      // `ensureLoaded` is a network round-trip: the player can keep pinching
      // out and cross into the cluster tier while it runs. Without this check
      // the 413 district polygons landed ON TOP of the region silhouette the
      // cluster branch had already painted, and neither side cleared the
      // other — the overlap then survived until the next tier change.
      if (!state || _lod != lod) {
        logger.log('[tifo-map] districts draw dropped: tier moved to ${_lod.name} while loading');
        return;
      }
      final st = ref.read(tifoDistrictsProvider);
      logger.log(
        '[tifo-map] districts loaded: ${st.districts.length} geom, ${st.summaries.length} summaries, err=${st.error}',
      );
      await _redrawDistricts(st);
      _drawnDistrictsLod = st.districts.isNotEmpty ? lod : null;
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
      //
      // The render cap is VIEWPORT-AWARE: a single dense viewport can exceed
      // it (1489 buildings seen live at z16), and a dumb "skip when full" left
      // every later viewport blank. On-screen buildings are drawn first, and
      // when the cap is hit an off-screen polygon is evicted to make room —
      // off-screen cache only fills whatever room is left.
      final visible = st.visibleIds;
      final ordered = [
        ...st.byId.values.where((b) => visible.contains(b.id)),
        ...st.byId.values.where((b) => !visible.contains(b.id)),
      ];
      final evictable = _drawnFill.keys.where((id) => !visible.contains(id)).toList();
      var evicted = 0;
      final toAdd = <Polygon>[];
      final toRemove = <String>[];
      final session = ref.read(tifoSessionProvider);
      for (final building in ordered) {
        final club = session.clubById(building.ownerClubSlug);
        final fill = club?.fillArgb ?? kTifoNeutralFillArgb;
        final stroke = club?.strokeArgb ?? kTifoNeutralStrokeArgb;
        final prev = _drawnFill[building.id];
        if (prev == fill) {
          continue; // already drawn, unchanged → keep it
        }
        if (prev == null && _drawnFill.length >= _maxRendered) {
          // At the cap: an on-screen building may evict an off-screen one;
          // off-screen additions just wait for room.
          if (!visible.contains(building.id) || evicted >= evictable.length) {
            continue;
          }
          final victim = evictable[evicted++];
          final victimRings = _drawnRings.remove(victim) ?? 0;
          _drawnFill.remove(victim);
          for (var i = 0; i < victimRings; i++) {
            toRemove.add('tifo-bld:$victim#$i');
          }
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

  // ─── Districts (zoom < 15) ─────────────────────────────────────────────────

  /// Paint-ready ARGB of the club leading the SEASON, for the cluster LOD.
  ///
  /// Derived from the district standings this layer already loads — the
  /// `/leaderboards?scope=clubs` endpoint is deliberately NOT called here, so
  /// the cluster tier costs zero extra requests and always agrees with the
  /// polygons around it (both read the same `summaries` snapshot).
  ///
  /// Ranked by BUILDINGS claimed city-wide (`summary.counts` summed across
  /// every district, not just the ones a club leads — a club can hold the most
  /// buildings overall while leading no district at all), tie-broken by
  /// districts led and then by slug. That last tie-break isn't cosmetic: an
  /// unbroken tie would repaint the whole city a different color on every
  /// poll, purely from `Map` iteration order.
  ///
  /// Null when nothing is claimed yet (pre-season / fresh reset), which the
  /// caller paints neutral.
  int? _seasonLeaderColor(TifoDistrictsState districtsState) {
    final buildingsHeld = <String, int>{};
    final districtsLed = <String, int>{};
    final colorBySlug = <String, int>{};
    for (final summary in districtsState.summaries.values) {
      for (final entry in summary.counts.entries) {
        buildingsHeld[entry.key] = (buildingsHeld[entry.key] ?? 0) + entry.value;
      }
      final slug = summary.leaderClub;
      if (slug == null || slug.isEmpty) {
        continue; // neutral district — contributes claims, but leads nobody
      }
      districtsLed[slug] = (districtsLed[slug] ?? 0) + 1;
      final color = summary.leaderColorArgb;
      if (color != null) {
        colorBySlug[slug] ??= color;
      }
    }
    // Buildings are the ranking criterion, but `counts` is OPTIONAL in the
    // `/districts/summary` payload (see `TifoDistrictSummary.fromJson`) — a
    // response without it leaves `buildingsHeld` empty and used to sink the
    // whole tier to neutral white, even with a clear leader on screen. Fall
    // back to districts led in that case: it comes from `leaderClub`, which
    // is always present when anyone leads at all.
    final byBuildings = buildingsHeld.values.any((count) => count > 0);
    final primary = byBuildings ? buildingsHeld : districtsLed;
    final secondary = byBuildings ? districtsLed : buildingsHeld;
    var leader = '';
    for (final entry in primary.entries) {
      if (entry.value <= 0) {
        continue; // an explicit `{'club': 0}` is not a claim
      }
      if (leader.isEmpty || _outranks(entry.key, leader, primary, secondary)) {
        leader = entry.key;
      }
    }
    if (leader.isEmpty) {
      logger.log(
        '[tifo-map] no season leader: ${districtsState.summaries.length} summaries, '
        'none with claims → neutral paint',
      );
      return null;
    }
    // Prefer the server's paint-ready color from a district this club leads;
    // the city-wide leader may lead none, so fall back to the clubs roster
    // (same source the building polygons use). Roster still loading → null,
    // and the `tifoSessionProvider` listener repaints once it arrives.
    final color = colorBySlug[leader] ?? ref.read(tifoSessionProvider).clubById(leader)?.colorArgb;
    logger.log(
      '[tifo-map] season leader: $leader by ${byBuildings ? 'buildings' : 'districts (no counts in payload)'} '
      '(${buildingsHeld[leader] ?? 0} buildings, ${districtsLed[leader] ?? 0} districts led) '
      '→ color ${color == null ? 'UNKNOWN, painting neutral' : '0x${color.toRadixString(16)}'}',
    );
    return color;
  }

  /// Strict "a beats b" for [_seasonLeaderColor]'s ranking, so the winner is
  /// found in one pass without allocating a sorted list. [primary] decides;
  /// [secondary] only breaks its ties.
  bool _outranks(String a, String b, Map<String, int> primary, Map<String, int> secondary) {
    final byPrimary = (primary[a] ?? 0).compareTo(primary[b] ?? 0);
    if (byPrimary != 0) {
      return byPrimary > 0;
    }
    final bySecondary = (secondary[a] ?? 0).compareTo(secondary[b] ?? 0);
    if (bySecondary != 0) {
      return bySecondary > 0;
    }
    return a.compareTo(b) < 0; // stable tie-break on slug
  }

  /// Pointwise diff repaint, mirroring the buildings path: a summaries refresh
  /// repaints ONLY the districts whose leader color actually changed (usually
  /// 0–2) instead of a full removeAll + ~413-polygon re-add storm through the
  /// bridge on every poll.
  Future<void> _redrawDistricts(TifoDistrictsState districtsState) async {
    final manager = _districtsManager;
    if (manager == null || districtsState.districts.isEmpty || _lod == _TifoLod.cluster) {
      return; // the cluster tier owns this manager — region silhouette only
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      // Re-check after the await: `dgisControllerProvider` can suspend long
      // enough for a zoom gesture to hand the manager over to the cluster
      // tier, and two tiers must never share it.
      if (!state || _lod == _TifoLod.cluster) {
        return;
      }
      final toAdd = <Polygon>[];
      final toRemove = <String>[];
      for (final district in districtsState.districts) {
        final summary = districtsState.summaries[district.id];
        // leaderColor is server-side paint-ready — the leader's hex OR the
        // neutral palette color — so use it directly (fallback grey if absent).
        final baseArgb = summary?.leaderColorArgb ?? _neutralDistrictArgb;
        final fill = (baseArgb & 0x00FFFFFF) | 0xE6000000;
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

  /// Cluster tier: one polygon over the whole season region, tinted with the
  /// season leader's color (neutral until standings say otherwise).
  ///
  /// Geometry is bundled, so this needs no network at all — a repaint only
  /// happens when the leader's color actually changes, which is why the fill
  /// is diffed against [_drawnRegionFill] instead of blindly re-adding.
  Future<void> _redrawRegion(TifoDistrictsState districtsState) async {
    final manager = _districtsManager;
    if (manager == null) {
      return;
    }
    if (_lod != _TifoLod.cluster) {
      return; // only the cluster tier shows the region
    }
    final baseArgb = _seasonLeaderColor(districtsState) ?? _neutralDistrictArgb;
    final fill = (baseArgb & 0x00FFFFFF) | 0xE6000000;
    if (_drawnRegionFill == fill) {
      return; // already painted in this color
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      // Same reasoning as `_redrawDistricts`: the tier may have changed under
      // this await, and the region must not outlive the cluster zoom.
      if (!state || _lod != _TifoLod.cluster) {
        return;
      }
      if (_drawnRegionFill != null) {
        await controller.removePolygon(_regionPolygonId, fromManager: manager);
        _drawnRegionFill = null;
      }
      await controller.addPolygons([
        Polygon(
          id: _regionPolygonId,
          options: PolygonOptionsMessage(
            contours: [
              PolylineGeometryMessage(
                points: [
                  for (final (latitude, longitude) in kTifoRegionOutline)
                    GeoPointMessage(latitude: latitude, longitude: longitude),
                ],
              ),
            ],
            color: fill,
            // Same border treatment as the district polygons, one step wider:
            // it's the only outline on screen at this zoom, so it carries the
            // region's shape on its own.
            strokeColor: (baseArgb & 0x00FFFFFF) | 0xCC000000,
            strokeWidth: 2,
          ),
        ),
      ], toManager: manager);
      _drawnRegionFill = fill;
      logger.log('[tifo-map] region painted (${kTifoRegionOutline.length} pts, fill 0x${fill.toRadixString(16)})');
    } catch (error, stackTrace) {
      logger.log('[tifo-map] region redraw failed: $error\n$stackTrace');
    }
  }

  Future<void> _clearDistricts() async {
    _drawnDistrictFill.clear();
    _drawnDistrictRings.clear();
    _drawnRegionFill = null;
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
