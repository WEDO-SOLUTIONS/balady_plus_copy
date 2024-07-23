/// Event that appears when parking visibility or parking filter changes
class ParkingStateEvent {
  ///
  const ParkingStateEvent({
    required this.visible,
    required this.filter,
  });

  ///use for distinct parking event type in event listener
  static const name = "parkingStateChanged";

  ///visibility
  final bool visible;

  ///filter
  final ParkingFilter filter;
}

///ParkingFilter
enum ParkingFilter {
  ///paid + free
  all('all'),

  ///parking off
  off('off'),

  ///free
  free('free'),

  ///paid parking
  paid('paid'),

  ///taxi
  taxi('taxi'),

  ///invalid
  invalid('invalid'),

  ///electric
  electric('electric'),

  ///parking for residents
  resident('resident');

  const ParkingFilter(this.attributeValue);

  ///describe string value of parking filter
  final String attributeValue;

  ///Fetch parking filter from string
  ///if [attribute] is null return "off"
  static ParkingFilter fromAttribute(String? attribute) {
    return ParkingFilter.values.firstWhere((e) => e.attributeValue == attribute, orElse: () => ParkingFilter.off);
  }
}
