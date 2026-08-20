import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Debug-only goalkeeper tuning knobs, exposed as raw numbers (not named
/// difficulty presets) so QA can dial each one in and report back which
/// combinations feel easy/medium/hard — named presets get added later, once
/// testers have settled on numbers. The defaults below are QA's current
/// baseline, which is deliberately EASIER than the values originally
/// hardcoded in `PenaltyGame` (0.4 / 2.1 / 2.0 / 4.8): the keeper commits
/// later, aims worse and closes on the ball more slowly. Read once when the
/// game screen is built, same as `tifoDebugColliderOverlayProvider`.
class TifoGoalkeeperDifficulty {
  const TifoGoalkeeperDifficulty({
    this.reactionDelayFraction = 0.55,
    this.aimError = 3.0,
    this.centerDiveSpeedFactor = 1.45,
    this.lateralDiveSpeed = 3.25,
  });

  /// Fraction of the ball's flight time the keeper waits before starting to
  /// react/dive. Higher = keeper commits later = easier for the striker.
  final double reactionDelayFraction;

  /// Amplitude of the random error added to the keeper's target position
  /// when a shot is taken. Higher = less accurate positioning = easier for
  /// the striker.
  final double aimError;

  /// Playback-speed multiplier for the center dive animation. Higher = the
  /// keeper's collider reaches its save position sooner = harder for the
  /// striker.
  final double centerDiveSpeedFactor;

  /// Exponential approach rate (per second) the keeper's horizontal position
  /// closes on the target position while the ball is flying — i.e. how fast
  /// he "runs"/dives sideways toward where the ball is headed. Higher = he
  /// gets there sooner = harder for the striker.
  final double lateralDiveSpeed;

  TifoGoalkeeperDifficulty copyWith({
    double? reactionDelayFraction,
    double? aimError,
    double? centerDiveSpeedFactor,
    double? lateralDiveSpeed,
  }) => TifoGoalkeeperDifficulty(
    reactionDelayFraction: reactionDelayFraction ?? this.reactionDelayFraction,
    aimError: aimError ?? this.aimError,
    centerDiveSpeedFactor: centerDiveSpeedFactor ?? this.centerDiveSpeedFactor,
    lateralDiveSpeed: lateralDiveSpeed ?? this.lateralDiveSpeed,
  );
}

class TifoDebugGoalkeeperDifficultyController extends Notifier<TifoGoalkeeperDifficulty> {
  @override
  TifoGoalkeeperDifficulty build() => const TifoGoalkeeperDifficulty();

  void setReactionDelayFraction(double value) => state = state.copyWith(reactionDelayFraction: value);

  void setAimError(double value) => state = state.copyWith(aimError: value);

  void setCenterDiveSpeedFactor(double value) => state = state.copyWith(centerDiveSpeedFactor: value);

  void setLateralDiveSpeed(double value) => state = state.copyWith(lateralDiveSpeed: value);

  void reset() => state = const TifoGoalkeeperDifficulty();
}

final tifoDebugGoalkeeperDifficultyProvider =
    NotifierProvider<TifoDebugGoalkeeperDifficultyController, TifoGoalkeeperDifficulty>(
      TifoDebugGoalkeeperDifficultyController.new,
    );
