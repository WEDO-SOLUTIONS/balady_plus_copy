import 'package:dgis_map/library.dart';

class PathNavSpeedInfo {
  const PathNavSpeedInfo({
    required this.direction,
    required this.speed,
    required this.speedLimit,
    required this.speedExceed,
  });
  final NaviCameraDirection? direction;
  final int speed;
  final int? speedLimit;
  final bool speedExceed;

  PathNavSpeedInfo copyWith({
    NaviCameraDirection? direction,
    int? speed,
    int? speedLimit,
    bool? speedExceed,
  }) =>
      PathNavSpeedInfo(
        direction: direction ?? this.direction,
        speed: speed ?? this.speed,
        speedLimit: speedLimit ?? this.speedLimit,
        speedExceed: speedExceed ?? this.speedExceed,
      );
}
