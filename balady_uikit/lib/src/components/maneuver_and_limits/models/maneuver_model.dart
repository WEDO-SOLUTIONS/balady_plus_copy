import 'package:balady_uikit/src/components/maneuver_and_limits/models/maneuver_instructions.dart';

/// Information about the maneuver to be performed on the map.
/// This includes the [instruction], road name, distance, and unit.
/// Should be used to pass the data to the [BaladyManeuverAlert] widget.
class BaladyManeuverModel {
  /// The instruction to be performed. Arrow that shows the direction of the maneuver.
  final BaladyManeuverInstruction? instruction;

  /// The name of the road where the maneuver will be performed.
  final String roadName;

  /// The distance to the maneuver.
  final String distance;

  /// The unit of the distance to the maneuver.
  final String unit;

  /// Constructor
  const BaladyManeuverModel({
    required this.instruction,
    required this.roadName,
    required this.distance,
    required this.unit,
  });
}
