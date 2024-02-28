import 'package:mapness/features/path_nav/lib/enums.dart';

class PathNavEta {

  const PathNavEta({
    required this.timeEta,
    required this.timeEtaUnits,
    required this.distanceEta,
    required this.distanceEtaUnits,
    required this.arrivalTime,
  });
  final String timeEta;
  final TimeUnits timeEtaUnits;
  final String distanceEta;
  final DistanceUnits distanceEtaUnits;
  final String arrivalTime;
}
