class CompassBearingEvent {
  ///Event that appears when compass bearing has changed
  const CompassBearingEvent({
    required this.value,
  });

  static const name = "compassBearingChanged";
  final double value;
}
