/// Event that appears when parking visibility or parking filter changes
class ParkingStateEvent {
  const ParkingStateEvent({
    required this.visible,
    required this.filter,
  });

  static const name = "parkingStateChanged";

  final bool visible;
  final ParkingFilter filter;
}

enum ParkingFilter {
  all('all'),
  off('off'),
  free('free'),
  paid('paid'),
  taxi('taxi'),
  invalid('invalid'),
  electric('electric'),
  resident('resident');

  const ParkingFilter(this.attributeValue);

  final String attributeValue;

  ///Fetch parking filter from string
  ///if [attribute] is null return "off"
  static ParkingFilter fromAttribute(String? attribute) {
    return ParkingFilter.values.firstWhere((e) => e.attributeValue == attribute, orElse: () => ParkingFilter.off);
  }
}
