import 'dart:async';

import 'package:dgis_map_platform_interface/library.dart';

/// Turns the native map's camera movements into Dart streams: the rectangle
/// on screen, and the camera position behind it.
class VisibleRectEventHandler {
  /// Creates the handler.
  VisibleRectEventHandler();

  /// Every rectangle the map has shown since this handler was made.
  Stream<VisibleRectEvent> get visibleRectEvents => _visibleRectController.stream;

  /// Every camera position the map has moved to.
  Stream<CameraPositionMessage> get cameraPositionEvents => _cameraPositionController.stream;

  final _visibleRectController = StreamController<VisibleRectEvent>.broadcast();
  final _cameraPositionController = StreamController<CameraPositionMessage>.broadcast();

  /// Decodes a camera position off the platform channel and publishes it on
  /// [cameraPositionEvents].
  void cameraPositionEvent(Map<dynamic, dynamic> map) {
    final event = CameraPositionMessage(
      point: GeoPointMessage(latitude: map['point']['latitude'], longitude: map['point']['longitude']),
      zoom: map['zoom'],
      tilt: map['tilt'],
      bearing: map['bearing'],
    );

    _cameraPositionController.sink.add(event);
  }

  /// Decodes the visible rectangle off the platform channel and publishes it
  /// on [visibleRectEvents].
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

  /// Closes both camera streams.
  Future<void> dispose() async {
    await _visibleRectController.close();
    await _cameraPositionController.close();
  }
}
