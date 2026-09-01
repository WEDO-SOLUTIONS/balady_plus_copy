import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';

/// Snapshot of the app surface (the visible auto_route segment chain) a TIFO
/// flow was started from.
///
/// Every TIFO gate screen is pushed on a navigator that OUTLIVES the surface
/// that asked for it — the root navigator for the entry popup and the guided
/// tutorial, the map router for team select. A push that resolves after an
/// await, once the player has walked away (Profile tab → Settings while
/// `session.load()` is still in flight), therefore lands on top of an
/// unrelated page instead of the map.
///
/// `context.mounted` cannot catch that: the landing subtree stays MOUNTED
/// while merely covered by another route (see `pages/landing/AGENTS.md`), and
/// the root navigator's context lives for the whole app session. The visible
/// route chain is the only signal that says "the player is still where this
/// flow started".
class TifoSurface {
  const TifoSurface._(this._routeName);

  /// Captures the top-most visible route. Capture EARLY — before the flow's
  /// first await — so the whole walk is gated on the surface the player
  /// actually tapped on, not on wherever they happen to be one await later.
  factory TifoSurface.capture(WidgetRef ref) =>
      TifoSurface._(ref.read(appRouterProvider).currentSegments.lastOrNull?.name);

  final String? _routeName;

  /// True while the captured surface is still part of the visible route chain.
  /// A null capture (router without an active segment) never blocks: the guard
  /// must not be able to break a flow in a state it can't reason about.
  bool isVisible(WidgetRef ref) {
    final name = _routeName;
    return name == null || ref.read(appRouterProvider).isRouteActive(name);
  }
}
