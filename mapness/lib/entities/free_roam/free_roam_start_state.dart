class FreeRoamStartState {
  final bool isAutorun;
  final bool canStart;
  final FreeRoamAnimationStatus status;

  const FreeRoamStartState({
    required this.isAutorun,
    required this.canStart,
    required this.status,
  });
  FreeRoamStartState copyWith({
    bool? isAutorun,
    bool? canStart,
    FreeRoamAnimationStatus? status,
  }) =>
      FreeRoamStartState(
        isAutorun: isAutorun ?? this.isAutorun,
        canStart: canStart ?? this.canStart,
        status: status ?? this.status,
      );
}

sealed class FreeRoamAnimationStatus {
  const FreeRoamAnimationStatus();

  bool get isAnimating;
}

final class AnimatingStatus extends FreeRoamAnimationStatus {
  const AnimatingStatus();

  @override
  bool get isAnimating => true;
}

final class PausedStatus extends FreeRoamAnimationStatus {
  const PausedStatus();

  @override
  bool get isAnimating => false;
}

final class CompletedStatus extends FreeRoamAnimationStatus {
  const CompletedStatus();

  @override
  bool get isAnimating => false;
}

final class UnknownStatus extends FreeRoamAnimationStatus {
  const UnknownStatus();

  @override
  bool get isAnimating => false;
}
