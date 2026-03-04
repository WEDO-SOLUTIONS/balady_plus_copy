import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/route_changed_events.dart';

class RoutesEventHandler {
  RoutesEventHandler();

  Stream<ActiveRouteChangedEvent> get activeRouteChangedEvents => _activeRouteChangedController.stream;

  Stream<RoutesInfoChangedEvent> get routesInfoChangedEvents => _routesInfoChangedController.stream;

  Stream<BetterRouteInfoEvent> get betterRouteInfoEvents => _betterRouteInfoController.stream;

  final _activeRouteChangedController = StreamController<ActiveRouteChangedEvent>.broadcast();

  final _routesInfoChangedController = StreamController<RoutesInfoChangedEvent>.broadcast();

  final _betterRouteInfoController = StreamController<BetterRouteInfoEvent>.broadcast();

  RouteInfo mapRouteInfo(Map<dynamic, dynamic> map) {
    final altitudes = map["altitudes"] as List<Object?>;
    return RouteInfo(
      map["distance"],
      map["duration"],
      map["stairwayCount"],
      map["gateCount"],
      altitudes.whereType<int>().cast<int>().toList(),
    );
  }

  void activeRouteChangedEvent(Map map) {
    _activeRouteChangedController.add(
      ActiveRouteChangedEvent(
        map["index"],
      ),
    );
  }

  void routesInfoChangedEvent(Map map) {
    final routes = (map["routes"] as List<dynamic>)
        .map(
          (e) => mapRouteInfo(e as Map),
        )
        .toList();

    _routesInfoChangedController.add(
      RoutesInfoChangedEvent(routes),
    );
  }

  void betterRouteInfoEvent(Map map) {
    final route = map["route"] != null ? mapRouteInfo(map["route"] as Map) : null;
    final durationProfit = map["durationProfit"];
    _betterRouteInfoController.add(
      BetterRouteInfoEvent(route, durationProfit),
    );
  }

  Future<void> dispose() async {
    await _routesInfoChangedController.close();
    await _activeRouteChangedController.close();
  }
}
