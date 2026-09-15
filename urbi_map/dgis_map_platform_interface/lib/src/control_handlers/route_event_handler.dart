import 'dart:async';

import 'package:dgis_map_platform_interface/src/events/route_changed_events.dart';

/// Turns the native map's route notifications into Dart streams: which route
/// is active, what is known about the built routes, and any faster
/// alternative that turns up while driving.
class RoutesEventHandler {
  /// Creates the handler.
  RoutesEventHandler();

  /// Every change of which built route is the active one.
  Stream<ActiveRouteChangedEvent> get activeRouteChangedEvents => _activeRouteChangedController.stream;

  /// Every change to the set of built routes or their summaries.
  Stream<RoutesInfoChangedEvent> get routesInfoChangedEvents => _routesInfoChangedController.stream;

  /// Faster alternatives offered while following a route, and their
  /// withdrawal.
  Stream<BetterRouteInfoEvent> get betterRouteInfoEvents => _betterRouteInfoController.stream;

  final _activeRouteChangedController = StreamController<ActiveRouteChangedEvent>.broadcast();

  final _routesInfoChangedController = StreamController<RoutesInfoChangedEvent>.broadcast();

  final _betterRouteInfoController = StreamController<BetterRouteInfoEvent>.broadcast();

  /// Reads one route summary out of its channel payload.
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

  /// Decodes the active route index off the platform channel and publishes it
  /// on [activeRouteChangedEvents].
  void activeRouteChangedEvent(Map map) {
    _activeRouteChangedController.add(ActiveRouteChangedEvent(map["index"]));
  }

  /// Decodes the built routes off the platform channel and publishes them on
  /// [routesInfoChangedEvents].
  void routesInfoChangedEvent(Map map) {
    final routes = (map["routes"] as List<dynamic>).map((e) => mapRouteInfo(e as Map)).toList();

    _routesInfoChangedController.add(RoutesInfoChangedEvent(routes));
  }

  /// Decodes a faster-route offer off the platform channel and publishes it
  /// on [betterRouteInfoEvents].
  void betterRouteInfoEvent(Map map) {
    final route = map["route"] != null ? mapRouteInfo(map["route"] as Map) : null;
    final durationProfit = map["durationProfit"];
    _betterRouteInfoController.add(BetterRouteInfoEvent(route, durationProfit));
  }

  /// Closes all three route streams.
  Future<void> dispose() async {
    await _routesInfoChangedController.close();
    await _activeRouteChangedController.close();
  }
}
