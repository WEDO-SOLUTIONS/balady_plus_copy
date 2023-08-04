import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/route_changed_events.dart';

class RouteChangedEventHandler {
  RouteChangedEventHandler();

  Stream<RouteChangedEvent> get routeChangedEvents => _routeChangedController.stream;

  final _routeChangedController = StreamController<RouteChangedEvent>.broadcast();

  void routeChangedEvent(Map<dynamic, dynamic> map) {
    final altitudes = map["altitudes"] as List<Object?>;
    _routeChangedController.sink.add(RouteChangedEvent(
      map["distance"],
      map["duration"],
      map["stairwayCount"],
      map["gateCount"],
      altitudes.whereType<int>().cast<int>().toList(),
    ));
  }

  Future<void> dispose() async {
    await _routeChangedController.close();
  }
}
