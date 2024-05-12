import 'package:dgis_map/library.dart';

class PathNavManeuver {
  final ManeuverInstruction? instruction;
  final String roadName;
  final String distance;
  final String unit;

  const PathNavManeuver({
    required this.instruction,
    required this.roadName,
    required this.distance,
    required this.unit,
  });
}
