import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Debug-only goalkeeper tuning knobs, exposed as raw numbers (not named
/// difficulty presets) so QA can dial each one in and report back which
/// combinations feel easy/medium/hard — named presets get added later, once
/// testers have settled on numbers. The defaults below are QA's current
/// baseline, which is deliberately EASIER than the values originally
/// hardcoded in `PenaltyGame` (0.4 / 2.1 / 2.0 / 4.8): the keeper commits
/// later, aims worse and closes on the ball more slowly. [maxApproachDistance]
/// has no such predecessor — it was uncapped, so its 2.0 default is a real
/// behavior change and not a port of an old constant. Read once when the game
/// screen is built, same as `tifoDebugColliderOverlayProvider`.
class TifoGoalkeeperDifficulty {
  const TifoGoalkeeperDifficulty({
    this.reactionDelayFraction = 0.55,
    this.aimError = 3.0,
    this.centerDiveSpeedFactor = 1.45,
    this.lateralDiveSpeed = 3.25,
    this.maxApproachDistance = 2.0,
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

  /// Hard cap, in pitch units, on how far the keeper may travel sideways from
  /// wherever he was standing at the moment of the shot — i.e. how close he is
  /// allowed to get to a ball that was already far from him.
  ///
  /// [lateralDiveSpeed] only controls how FAST he closes the gap; given enough
  /// flight time he still arrives, so a shot into the far corner could be
  /// saved by a keeper who started at the opposite post. This bounds the
  /// distance instead of the speed, which is what makes wide placement pay
  /// off. Lower = he stays short of a far ball = easier for the striker.
  ///
  /// Only binds when the ball is far: a target inside the cap is unaffected.
  ///
  /// Scale: the goal is 9 pitch units wide, the dive target is clamped to
  /// ±3.75, and idle sway leaves him within ±1.65 of center — so the widest
  /// gap he can ever face is 5.4, and any value above that is "no cap". The
  /// default 2.0 therefore bites on genuinely wide placement (a far corner
  /// hit while he leans the other way stays out of reach) and leaves shots
  /// near his standing position untouched.
  final double maxApproachDistance;

  TifoGoalkeeperDifficulty copyWith({
    double? reactionDelayFraction,
    double? aimError,
    double? centerDiveSpeedFactor,
    double? lateralDiveSpeed,
    double? maxApproachDistance,
  }) => TifoGoalkeeperDifficulty(
    reactionDelayFraction: reactionDelayFraction ?? this.reactionDelayFraction,
    aimError: aimError ?? this.aimError,
    centerDiveSpeedFactor: centerDiveSpeedFactor ?? this.centerDiveSpeedFactor,
    lateralDiveSpeed: lateralDiveSpeed ?? this.lateralDiveSpeed,
    maxApproachDistance: maxApproachDistance ?? this.maxApproachDistance,
  );
}

class TifoDebugGoalkeeperDifficultyController extends Notifier<TifoGoalkeeperDifficulty> {
  @override
  TifoGoalkeeperDifficulty build() => const TifoGoalkeeperDifficulty();

  void setReactionDelayFraction(double value) => state = state.copyWith(reactionDelayFraction: value);

  void setAimError(double value) => state = state.copyWith(aimError: value);

  void setCenterDiveSpeedFactor(double value) => state = state.copyWith(centerDiveSpeedFactor: value);

  void setLateralDiveSpeed(double value) => state = state.copyWith(lateralDiveSpeed: value);

  void setMaxApproachDistance(double value) => state = state.copyWith(maxApproachDistance: value);

  void reset() => state = const TifoGoalkeeperDifficulty();
}

final tifoDebugGoalkeeperDifficultyProvider =
    NotifierProvider<TifoDebugGoalkeeperDifficultyController, TifoGoalkeeperDifficulty>(
      TifoDebugGoalkeeperDifficultyController.new,
    );
