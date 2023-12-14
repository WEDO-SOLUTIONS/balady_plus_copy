import 'dart:async';

import 'package:dgis_map/library.dart' show VisibleRectEvent, VisibleRect;
import 'package:geobase/geobase.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_viewport_changes.g.dart';

@riverpod
class MapViewportChanges extends _$MapViewportChanges {
  StreamSubscription? _visibleRectSub;
  Polygon _currentVisible = Polygon.from(const []);

  @override
  Polygon build() {
    ref.onDispose(() {
      _visibleRectSub?.cancel();
      _visibleRectSub = null;
    });

    if (_visibleRectSub == null) {
      _startListen();
    }

    return _currentVisible;
  }

  void _startListen() async {
    final map = ref.read(dgisControllerProvider.notifier);
    _visibleRectSub = map.visibleRectEvents.listen(_mapVisibleRectUpdate);
  }

  void _mapVisibleRectUpdate(VisibleRectEvent event) async {
    _currentVisible = await _getPolygonFromRect(event.visibleRect);
    ref.invalidateSelf();
  }

  Future<Polygon> _getPolygonFromRect(VisibleRect rect) async {
    final box = Box.create(
      minX: rect.southWestLon,
      minY: rect.southWestLat,
      maxX: rect.northEastLon,
      maxY: rect.northEastLat,
    );

    final corners = box.corners2D.toList();
    final List<Position> positions = [...corners, corners[0]]
        .map((e) => Position.create(x: e.x, y: e.y))
        .toList();

    final polygon = Polygon.from(
      [positions],
      bounds: box,
    );

    return polygon;
  }
}
