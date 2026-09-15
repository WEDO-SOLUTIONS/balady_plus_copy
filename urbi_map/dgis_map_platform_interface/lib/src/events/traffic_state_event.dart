/// Reports a change in the traffic layer: whether it is showing, and how
/// congested the visible area is.
class TrafficStateEvent {
  ///Event that appears when parking visibility changes
  const TrafficStateEvent({required this.score, required this.status});

  /// Name of the platform channel event this is decoded from.
  static const name = "trafficStateChanged";

  /// Congestion score the map reports for the visible area, 0 to 10.
  final int score;

  /// Whether the traffic layer is available and showing.
  final TrafficControlStatus status;
}

/// State of the on-map traffic control.
enum TrafficControlStatus {
  /// The control is not on screen at all.
  hidden,

  /// The control is on screen and the traffic layer is drawn.
  enabled,

  /// The control is on screen and the traffic layer is off.
  disabled,

  /// The control is on screen and waiting for traffic data.
  loading,
}
