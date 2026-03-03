/// Information about the speed limits and the speed of the vehicle.
/// This includes the [speed] of the vehicle,
/// [speedLimit] of the road, and [speedExceed] if the speed limit is exceeded.
/// Should be used to pass the data to the [BaladyLimitAlert] widget.
class LimitsModel {
  /// The speed of the vehicle.
  final int speed;

  /// The speed limit of the road.
  final int? speedLimit;

  /// If the speed limit is exceeded.
  final bool speedExceed;

  /// Constructor
  const LimitsModel({
    required this.speed,
    required this.speedLimit,
    required this.speedExceed,
  });

  /// Copy the current [LimitsModel] with new values.
  LimitsModel copyWith({
    int? speed,
    int? speedLimit,
    bool? speedExceed,
  }) =>
      LimitsModel(
        speed: speed ?? this.speed,
        speedLimit: speedLimit ?? this.speedLimit,
        speedExceed: speedExceed ?? this.speedExceed,
      );
}
