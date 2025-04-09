import 'package:mapness/features/path_nav/lib/enums.dart';

class PathNavEta {
  final String timeEta;
  final TimeUnits timeEtaUnits;
  final String distanceEta;
  final DistanceUnits distanceEtaUnits;
  final String arrivalTime;
  final bool isExpanded;
  final int durationInSeconds;
  final double rawDistance;
  final Duration spentTime;

  const PathNavEta({
    required this.timeEta,
    required this.timeEtaUnits,
    required this.distanceEta,
    required this.distanceEtaUnits,
    required this.arrivalTime,
    required this.durationInSeconds,
    required this.rawDistance,
    required this.spentTime,
    this.isExpanded = false,
  });

  PathNavEta copyWith({
    String? timeEta,
    TimeUnits? timeEtaUnits,
    String? distanceEta,
    DistanceUnits? distanceEtaUnits,
    String? arrivalTime,
    bool? isExpanded,
    int? durationInSeconds,
    double? rawDistance,
    Duration? spentTime,
  }) =>
      PathNavEta(
        timeEta: timeEta ?? this.timeEta,
        timeEtaUnits: timeEtaUnits ?? this.timeEtaUnits,
        distanceEta: distanceEta ?? this.distanceEta,
        distanceEtaUnits: distanceEtaUnits ?? this.distanceEtaUnits,
        arrivalTime: arrivalTime ?? this.arrivalTime,
        isExpanded: isExpanded ?? this.isExpanded,
        durationInSeconds: durationInSeconds ?? this.durationInSeconds,
        rawDistance: rawDistance ?? this.rawDistance,
        spentTime: spentTime ?? this.spentTime,
      );
}
