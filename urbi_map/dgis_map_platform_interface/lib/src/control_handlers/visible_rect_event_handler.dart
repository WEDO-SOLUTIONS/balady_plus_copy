import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/visible_rect_events.dart';

class VisibleRectEventHandler {
  VisibleRectEventHandler();

  Stream<VisibleRectEvent> get visibleRectEvents =>
      _visibleRectController.stream;

  final _visibleRectController = StreamController<VisibleRectEvent>();

  void visibleRectEvent(Map<dynamic, dynamic> map) {
    final visibleRectMap = map["visibleRect"];

    final double northEastLat = visibleRectMap['northEastLat'];
    final double northEastLon = visibleRectMap['northEastLon'];
    final double southWestLat = visibleRectMap['southWestLat'];
    final double southWestLon = visibleRectMap['southWestLon'];

    final double zoom = map['zoom'];

    final event = VisibleRectEvent(VisibleRect(
        northEastLat: northEastLat,
        northEastLon: northEastLon,
        southWestLat: southWestLat,
        southWestLon: southWestLon,
        zoom: zoom));

    _visibleRectController.sink.add(event);
  }

  Future<void> dispose() async {
    await _visibleRectController.close();
  }
}
