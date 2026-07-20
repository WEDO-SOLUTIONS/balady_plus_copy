import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/building_sheet.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/providers/tifo_buildings_provider.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Renders the TIFO building layer on the dgis map: fetches buildings for the
/// visible viewport (debounced on camera move), draws one polygon per footprint
/// colored by owning club, and opens the capture sheet on tap.
///
/// Owns its own [MapObjectManagerMessage] so it can clear/redraw independently
/// of the debug district layer.
class TifoBuildingsMapLayer extends Notifier<bool> {
  MapObjectManagerMessage? _manager;
  StreamSubscription<VisibleRectEvent>? _visibleSub;
  Timer? _debounce;
  String? _lastBbox;

  @override
  bool build() {
    // Redraw whenever the building set changes (fetch completed / capture
    // applied), but only while the layer is switched on.
    ref
      ..listen<TifoBuildingsState>(tifoBuildingsProvider, (_, next) {
        if (state) {
          unawaited(_redraw(next.buildings));
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
      _manager ??= await controller.createMapObjectManager(layerId: MapObjectLayers.defaultLayerId);

      _visibleSub = controller.visibleRectEvents.listen((event) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 400), () {
          unawaited(_fetch(event.visibleRect));
        });
      });

      // Kick off an initial fetch from the current visible area so the layer
      // populates without waiting for the first camera move.
      await _fetchInitial(controller);
    } catch (error, stackTrace) {
      logger.log('TIFO buildings layer enable failed: $error\n$stackTrace');
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
    final manager = _manager;
    if (manager != null) {
      try {
        final controller = await ref.read(dgisControllerProvider.future);
        await controller.removeAllPolygons(fromManager: manager);
      } catch (_) {
        // Map already gone — nothing to clear.
      }
    }
    ref.read(tifoBuildingsProvider.notifier).clear();
  }

  Future<void> _fetchInitial(DgisMapController controller) async {
    try {
      final area = await controller.getVisibleArea();
      final points = <GeoPointMessage>[];
      for (final contour in area.contours) {
        if (contour is PolylineGeometryMessage) {
          points.addAll(contour.points);
        }
      }
      if (points.isEmpty) {
        return; // first visibleRectEvent will cover it
      }
      var minLat = points.first.latitude, maxLat = points.first.latitude;
      var minLng = points.first.longitude, maxLng = points.first.longitude;
      for (final p in points) {
        minLat = p.latitude < minLat ? p.latitude : minLat;
        maxLat = p.latitude > maxLat ? p.latitude : maxLat;
        minLng = p.longitude < minLng ? p.longitude : minLng;
        maxLng = p.longitude > maxLng ? p.longitude : maxLng;
      }
      await _fetchBbox('$minLng,$minLat,$maxLng,$maxLat');
    } catch (error) {
      logger.log('TIFO buildings initial fetch failed: $error');
    }
  }

  Future<void> _fetch(VisibleRect rect) => _fetchBbox(
    '${rect.southWestLon},${rect.southWestLat},${rect.northEastLon},${rect.northEastLat}',
  );

  Future<void> _fetchBbox(String bbox) async {
    if (!state || bbox == _lastBbox) {
      return;
    }
    _lastBbox = bbox;
    await ref.read(tifoBuildingsProvider.notifier).fetchForBbox(bbox);
  }

  /// Caps rendering to keep the map responsive — same guard the demo uses.
  static const int _maxRendered = 150;

  Future<void> _redraw(Map<String, TifoBuilding> buildings) async {
    final manager = _manager;
    if (manager == null) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      await controller.removeAllPolygons(fromManager: manager);

      final polygons = <Polygon>[];
      var count = 0;
      for (final building in buildings.values) {
        if (count >= _maxRendered) {
          break;
        }
        count++;
        final club = building.ownerClub;
        final fill = club?.fillArgb ?? kTifoNeutralFillArgb;
        final stroke = club?.strokeArgb ?? kTifoNeutralStrokeArgb;
        for (var i = 0; i < building.rings.length; i++) {
          polygons.add(
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
      }
      if (polygons.isNotEmpty) {
        await controller.addPolygons(polygons, toManager: manager);
      }
    } catch (error, stackTrace) {
      logger.log('TIFO buildings redraw failed: $error\n$stackTrace');
    }
  }

  void _openBuilding(TifoBuilding building) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return;
    }
    unawaited(showTifoBuildingSheet(context, building));
  }

  void _teardown() {
    _debounce?.cancel();
    unawaited(_visibleSub?.cancel());
  }
}

final tifoBuildingsMapLayerProvider = NotifierProvider<TifoBuildingsMapLayer, bool>(TifoBuildingsMapLayer.new);
