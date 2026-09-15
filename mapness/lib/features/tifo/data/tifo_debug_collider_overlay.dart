import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Debug-only toggle for the penalty mini-game's QA collider overlay (ball
/// touch/collision circle + keeper save reach box drawn live on the pitch,
/// see `PenaltyGame._drawColliderDebugOverlay`). Off by default, and always
/// off in production UI — read once when the game screen is built (see
/// `_TifoBuildingSheetState._runShootout`), same as `tifoDebugColorOverrideProvider`.
class TifoDebugColliderOverlayController extends Notifier<bool> {
  @override
  bool build() => false;

  bool get enabled => state;

  set enabled(bool value) => state = value;
}

final tifoDebugColliderOverlayProvider = NotifierProvider<TifoDebugColliderOverlayController, bool>(
  TifoDebugColliderOverlayController.new,
);
