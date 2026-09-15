/// What the map knows about one built route.
class RouteInfo {
  /// Creates the route summary.
  RouteInfo(this.distance, this.duration, this.stairwayCount, this.gateCount, this.altitudes);

  /// Length of the route in metres.
  final double distance;

  /// Time the route is expected to take, in seconds.
  final int duration;

  /// How many stairways the route passes through.
  final int stairwayCount;

  /// How many gates the route passes through.
  final int gateCount;

  /// Elevation profile along the route, in metres.
  final List<int> altitudes;
}

/// Reports that a different one of the built routes became the active one.
class ActiveRouteChangedEvent {
  /// Creates the event for the route now active at [index].
  const ActiveRouteChangedEvent(this.index);

  /// Name of the platform channel event this is decoded from.
  static const name = "onActiveRouteChanged";

  /// Position of the now-active route in the list of built routes.
  final int index;
}

/// Reports that the set of built routes, or what is known about them, changed.
class RoutesInfoChangedEvent {
  /// Creates the event carrying the current [routes].
  const RoutesInfoChangedEvent(this.routes);

  /// Name of the platform channel event this is decoded from.
  static const name = "onRoutesInfoChanged";

  /// Every route currently built, in the order the map lists them.
  final List<RouteInfo> routes;
}

/// Reports that a faster route than the one being followed became available.
class BetterRouteInfoEvent {
  /// Creates the event for [route], which saves [durationProfit] seconds.
  const BetterRouteInfoEvent(this.route, this.durationProfit);

  /// Name of the platform channel event this is decoded from.
  static const name = "betterRouteEvent";

  /// The alternative on offer, or null when the offer was withdrawn.
  final RouteInfo? route;

  /// Seconds the alternative is expected to save.
  final int durationProfit;
}
