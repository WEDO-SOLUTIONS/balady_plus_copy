class RouteChangedEvent {
  const RouteChangedEvent(
    this.distance,
    this.duration,
    this.stairwayCount,
    this.gateCount,
    this.altitudes,
  );

  static const name = "onRouteChanged";

  final double distance;
  final int duration;
  final int stairwayCount;
  final int gateCount;
  final List<int> altitudes;
}
