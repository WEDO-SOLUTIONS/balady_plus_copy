class RouteOptionsEvent {
  ///Event that appears when route options are acquired
  const RouteOptionsEvent({
    required this.hasOptions,
  });

  static const name = "routeOptionsEvent";
  final bool hasOptions;
}
