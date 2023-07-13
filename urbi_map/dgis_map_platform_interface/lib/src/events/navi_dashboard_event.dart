class NaviDashboardEvent {
  const NaviDashboardEvent(
    this.duration,
    this.distance,
    this.arrival_time,
  );

  static const name = "dashboardEvent";
  final int duration;
  final double distance;
  final String arrival_time;
}
