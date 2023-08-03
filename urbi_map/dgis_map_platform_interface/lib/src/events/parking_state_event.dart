class ParkingStateEvent {
  ///Event that appears when parking visibility changes
  const ParkingStateEvent({
    required this.visible,
  });

  static const name = "parkingStateChanged";
  final bool visible;
}
