class TrafficStateEvent {
  ///Event that appears when parking visibility changes
  const TrafficStateEvent({
    this.score,
    required this.status,
  });

  static const name = "trafficStateChanged";
  final int? score;
  final TrafficControlStatus status;
}

enum TrafficControlStatus { hidden, enabled, disabled, loading }
