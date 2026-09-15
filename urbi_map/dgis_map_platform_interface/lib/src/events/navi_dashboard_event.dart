/// Reports the running totals navigation shows on its dashboard: how much of
/// the route is left and when the user is expected to arrive.
class NaviDashboardEvent {
  /// Creates the event from the remaining [duration] and [distance] and the
  /// estimated [arrivalTime].
  const NaviDashboardEvent(this.duration, this.distance, this.arrivalTime);

  /// Name of the platform channel event this is decoded from.
  static const name = "dashboardEvent";

  /// Seconds left until arrival.
  final int duration;

  /// Metres left until arrival.
  final double distance;

  /// Estimated time of arrival, already formatted by the native side.
  final String arrivalTime;
}
