import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheetify/sheetify.dart';

/// The Landing tab's sheet controller.
///
/// Overridden by `BottomMenuPage` for its subtree, which is the only place it
/// may be read. The override makes it available synchronously on the very first
/// build of `LandingPage`: a provider that had to be *written* by a widget
/// could only be published after the first frame, which forced consumers to
/// add and remove whole subtrees once it arrived - and structurally toggling a
/// subtree that is already dirty is what trips
/// `_debugRelayoutBoundaryAlreadyMarkedNeedsLayout`.
///
/// `LandingPage` stays mounted behind the other tabs, so it must drive *its*
/// sheet rather than whichever one happens to be active - see
/// [activeBottomSheetControllerProvider] for that.
final landingSheetControllerProvider = Provider<MultiStateSheetController<ThreeStateSheet>>(
  (ref) => throw UnsupportedError(
    'landingSheetControllerProvider is only available inside BottomMenuPage, '
    'which overrides it. Use activeBottomSheetControllerProvider elsewhere.',
  ),
);

/// The Routes tab's sheet controller. Same contract as
/// [landingSheetControllerProvider].
final routingSheetControllerProvider = Provider<MultiStateSheetController<ThreeStateSheet>>(
  (ref) => throw UnsupportedError(
    'routingSheetControllerProvider is only available inside BottomMenuPage, '
    'which overrides it. Use activeBottomSheetControllerProvider elsewhere.',
  ),
);

/// The controller of the bottom-menu tab currently on screen, or `null` while
/// `BottomMenuPage` is not mounted.
///
/// Root-scoped, because its consumers - deep-link handling, the layers button,
/// quick filters - sit outside the overridden subtree. It holds a *borrowed*
/// reference: `BottomMenuPage` publishes via [attach] and drops it via
/// [release] before disposing the controllers, so nothing here can outlive
/// them. Driving a disposed [MultiStateSheetController] throws inside its
/// animation callback in debug and profile, and is a silent no-op in release.
///
/// `watch` it; never cache the value, as it changes on every tab switch.
final activeBottomSheetControllerProvider =
    NotifierProvider<ActiveBottomSheetController, MultiStateSheetController<ThreeStateSheet>?>(
      ActiveBottomSheetController.new,
    );

final class ActiveBottomSheetController extends Notifier<MultiStateSheetController<ThreeStateSheet>?> {
  @override
  MultiStateSheetController<ThreeStateSheet>? build() => null;

  /// Publishes [controller] as the active one. Identical input is a no-op, so
  /// watchers are not woken for nothing.
  void attach(MultiStateSheetController<ThreeStateSheet> controller) {
    if (identical(state, controller)) {
      return;
    }
    state = controller;
  }

  /// Clears the published reference if it is any of [controllers].
  ///
  /// Guarded by identity so a page torn down after a newer `BottomMenuPage`
  /// published its own controllers cannot clear the newer one.
  void release(Iterable<MultiStateSheetController<ThreeStateSheet>> controllers) {
    final current = state;
    if (current == null || !controllers.any((controller) => identical(controller, current))) {
      return;
    }
    state = null;
  }
}
