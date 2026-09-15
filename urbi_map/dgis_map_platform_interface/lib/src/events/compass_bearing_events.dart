/// Reports the compass bearing the native map is currently showing.
class CompassBearingEvent {
  ///Event that appears when compass bearing has changed
  const CompassBearingEvent({required this.value});

  /// Name of the platform channel event this is decoded from.
  static const name = "compassBearingChanged";

  /// Bearing in degrees clockwise from north.
  final double value;
}
