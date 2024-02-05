import 'package:mapness/features/path_nav/lib/enums.dart';

class PathNavEta {
  final String timeEta;
  final TimeUnits timeEtaUnits;
  final String distanceEta;
  final DistanceUnits distanceEtaUnits;
  final String arrivalTime;

  const PathNavEta({
    required this.timeEta,
    required this.timeEtaUnits,
    required this.distanceEta,
    required this.distanceEtaUnits,
    required this.arrivalTime,
  });
}
