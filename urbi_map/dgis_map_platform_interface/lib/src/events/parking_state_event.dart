/// Event that appears when parking visibility or parking filter changes
class ParkingStateEvent {
  static const name = "parkingStateChanged";

  final bool visible;
  final ParkingFilter filter;

  const ParkingStateEvent({
    required this.visible,
    required this.filter,
  });
}

enum ParkingFilter {
  off('off'),
  free('free'),
  paid('paid'),
  taxi('taxi'),
  invalid('invalid'),
  electric('electric'),
  resident('resident');

  const ParkingFilter(this.attributeValue);

  final String attributeValue;

  static ParkingFilter fromAttribute(String? attribute) {
    return ParkingFilter.values.firstWhere((e) => e.attributeValue == attribute, orElse: () => ParkingFilter.off);
  }
}
