class FreeRoamStartTimer {
  final bool isAutorun;
  final bool canStart;
  final Duration? timeElapsed;

  const FreeRoamStartTimer({
    required this.isAutorun,
    required this.canStart,
    this.timeElapsed,
  });
  FreeRoamStartTimer copyWith({
    bool? isAutorun,
    bool? canStart,
    Duration? timeElapsed,
  }) =>
      FreeRoamStartTimer(
        isAutorun: isAutorun ?? this.isAutorun,
        canStart: canStart ?? this.canStart,
        timeElapsed: timeElapsed ?? this.timeElapsed,
      );
}
