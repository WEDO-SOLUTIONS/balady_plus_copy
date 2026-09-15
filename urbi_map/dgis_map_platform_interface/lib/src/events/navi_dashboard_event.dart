class NaviDashboardEvent {
  const NaviDashboardEvent(this.duration, this.distance, this.arrivalTime);

  static const name = "dashboardEvent";
  final int duration;
  final double distance;
  final String arrivalTime;
}
