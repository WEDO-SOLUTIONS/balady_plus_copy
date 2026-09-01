import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Debug-only override for the striker/goalkeeper kit colors otherwise
/// resolved automatically from the player's/building's club (see
/// `tifoNearestStrikerColor`/`tifoNearestKeeperColor` in `penalty_game.dart`).
///
/// [enabled] is the master switch — off (default, and always in production
/// UI) means the game's own resolution is used untouched, regardless of what
/// [strikerColor]/[keeperColor] hold. Each color is independently nullable
/// even while enabled: null means "auto" for that role specifically, so a
/// tester can pin just one side (e.g. force the keeper's color while the
/// striker still follows the player's real club).
@immutable
class TifoColorOverride {
  const TifoColorOverride({this.enabled = false, this.strikerColor, this.keeperColor});

  final bool enabled;
  final String? strikerColor;
  final String? keeperColor;
}

class TifoDebugColorOverrideController extends Notifier<TifoColorOverride> {
  @override
  TifoColorOverride build() => const TifoColorOverride();

  void setEnabled(bool value) =>
      state = TifoColorOverride(enabled: value, strikerColor: state.strikerColor, keeperColor: state.keeperColor);

  void setStrikerColor(String? color) =>
      state = TifoColorOverride(enabled: state.enabled, strikerColor: color, keeperColor: state.keeperColor);

  void setKeeperColor(String? color) =>
      state = TifoColorOverride(enabled: state.enabled, strikerColor: state.strikerColor, keeperColor: color);
}

final tifoDebugColorOverrideProvider =
    NotifierProvider<TifoDebugColorOverrideController, TifoColorOverride>(TifoDebugColorOverrideController.new);
