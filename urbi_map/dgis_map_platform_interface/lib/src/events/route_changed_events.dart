class RouteInfo {
  RouteInfo(
    this.distance,
    this.duration,
    this.stairwayCount,
    this.gateCount,
    this.altitudes,
  );

  final double distance;
  final int duration;
  final int stairwayCount;
  final int gateCount;
  final List<int> altitudes;
}

class ActiveRouteChangedEvent {
  const ActiveRouteChangedEvent(
    this.index,
  );

  static const name = "onActiveRouteChanged";

  final int index;
}

class RoutesInfoChangedEvent {
  const RoutesInfoChangedEvent(
    this.routes,
  );

  static const name = "onRoutesInfoChanged";

  final List<RouteInfo> routes;
}

class BetterRouteInfoEvent {
  const BetterRouteInfoEvent(
    this.route,
    this.durationProfit,
  );

  static const name = "betterRouteEvent";

  final RouteInfo? route;
  final int durationProfit;
}
