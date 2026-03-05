import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

class VisibleRectEventHandler {
  VisibleRectEventHandler();

  Stream<VisibleRectEvent> get visibleRectEvents => _visibleRectController.stream;

  Stream<CameraPositionMessage> get cameraPositionEvents => _cameraPositionController.stream;

  final _visibleRectController = StreamController<VisibleRectEvent>.broadcast();
  final _cameraPositionController = StreamController<CameraPositionMessage>.broadcast();

  void cameraPositionEvent(Map<dynamic, dynamic> map) {
    final event = CameraPositionMessage(
      point: GeoPointMessage(
        latitude: map['point']['latitude'],
        longitude: map['point']['longitude'],
      ),
      zoom: map['zoom'],
      tilt: map['tilt'],
      bearing: map['bearing'],
    );

    _cameraPositionController.sink.add(event);
  }

  void visibleRectEvent(Map<dynamic, dynamic> map) {
    final visibleRectMap = map["visibleRect"];

    final double northEastLat = visibleRectMap['northEastLat'];
    final double northEastLon = visibleRectMap['northEastLon'];
    final double southWestLat = visibleRectMap['southWestLat'];
    final double southWestLon = visibleRectMap['southWestLon'];

    final double zoom = map['zoom'];

    final event = VisibleRectEvent(
      VisibleRect(
        northEastLat: northEastLat,
        northEastLon: northEastLon,
        southWestLat: southWestLat,
        southWestLon: southWestLon,
        zoom: zoom,
      ),
    );

    _visibleRectController.sink.add(event);
  }

  Future<void> dispose() async {
    await _visibleRectController.close();
    await _cameraPositionController.close();
  }
}
