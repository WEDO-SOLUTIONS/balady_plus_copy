import 'package:dgis_map/library.dart';

class PathNavSpeedInfo {
  final NaviCameraDirection? direction;
  final int speed;
  final int? speedLimit;
  final bool speedExceed;

  const PathNavSpeedInfo({
    required this.direction,
    required this.speed,
    required this.speedLimit,
    required this.speedExceed,
  });

  PathNavSpeedInfo copyWith({
    NaviCameraDirection? direction,
    int? speed,
    int? speedLimit,
    bool? speedExceed,
  }) {
    return PathNavSpeedInfo(
      direction: direction ?? this.direction,
      speed: speed ?? this.speed,
      speedLimit: speedLimit ?? this.speedLimit,
      speedExceed: speedExceed ?? this.speedExceed,
    );
  }
}
