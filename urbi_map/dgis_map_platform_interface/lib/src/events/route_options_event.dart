/// Reports whether the route that was just built offers alternatives to
/// choose between.
class RouteOptionsEvent {
  ///Event that appears when route options are acquired
  const RouteOptionsEvent({required this.hasOptions});

  /// Name of the platform channel event this is decoded from.
  static const name = "routeOptionsEvent";

  /// Whether there is more than one route to pick from.
  final bool hasOptions;
}
