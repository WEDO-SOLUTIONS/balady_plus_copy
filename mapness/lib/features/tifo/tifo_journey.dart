import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/team_select_screen.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_login.dart';
import 'package:mapness/features/tifo/tifo_surface.dart';
import 'package:mapness/features/tifo/tutorial/tifo_guided_tutorial.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Drives the BRD V2 play-gate (US-01 BR-01): route to the first unmet step
/// in the order **tutorial → team selected** — a logged-out user goes to the
/// tutorial first; login is enforced only where the BRD needs it, at team
/// confirmation (US-04, BT-23). Each gate screen is pushed in turn; the flow
/// stops early if the player backs out (e.g. "Maybe Later" on team select).
///
/// Returns true only when every gate is satisfied ([TifoJourneyStep.ready]).
class TifoJourney {
  const TifoJourney(this.ref);

  final WidgetRef ref;

  /// Everything the gate walk needs from the network BEFORE it can push its
  /// first screen. Run it while a screen the player is already looking at
  /// covers the app (the entry popup's CTA spinner) so the walk pushes with no
  /// visible gap; [ensurePlayReady] repeats it and is a no-op once warm.
  Future<void> prepare() async {
    if (ref.read(tifoSessionProvider).profile == null) {
      await ref.read(tifoSessionProvider.notifier).load();
    }
  }

  /// [from] is the surface the play-intent was expressed on. Pass it when the
  /// caller awaits something before starting the walk (the ⚽ entry popup, the
  /// map-layer toggle) so the gate is anchored to the tap, not to whatever is
  /// on screen once those awaits resolve. Defaults to "here, now".
  Future<bool> ensurePlayReady(BuildContext context, {TifoSurface? from}) async {
    final surface = from ?? TifoSurface.capture(ref);
    final session = ref.read(tifoSessionProvider.notifier);

    // Ensure we have a fresh profile to gate on. On staging this also lazily
    // registers the user. Already warm when the caller ran [prepare].
    await prepare();

    // Walk the gates. Re-read state after each step since the profile changes.
    // Cap iterations so a backend hiccup can't spin forever.
    for (var guard = 0; guard < 4; guard++) {
      // The player may have left the map while the step above was awaiting
      // (BALADY: tutorial rendered on top of Settings after a quick tab
      // switch) — a gate screen must never be pushed over an unrelated page.
      if (!context.mounted) {
        return false;
      }
      if (!surface.isVisible(ref)) {
        logger.log('[tifo] play-gate abandoned: player navigated away from the entry surface');
        return false;
      }
      final step = ref.read(tifoSessionProvider).nextStep;
      switch (step) {
        case TifoJourneyStep.ready:
          return true;

        case TifoJourneyStep.login:
          // Login is owned by the Balady+ host shell — open its login flow,
          // then re-check the session; the user may cancel, so stop the walk
          // while the session is still on the guest bearer (a guest profile
          // exists on staging, so the profile alone can't tell).
          await openHostLogin();
          await session.load();
          final reloaded = ref.read(tifoSessionProvider);
          if (reloaded.isGuest || reloaded.profile == null) {
            return false;
          }

        case TifoJourneyStep.tutorial:
          // BRD V2 US-03 BR-02: STARTING the tutorial clears the gate
          // permanently, whether the user finishes it or closes/skips it —
          // both are deliberate in-app outcomes of `showTifoGuidedTutorial`
          // returning. BR-06's exception (session loss: connectivity drop,
          // app close, crash) never reaches this line at all, since the
          // process dies mid-await before either persistence call below can
          // run — so gating on "did they finish" was wrong; the tour having
          // been SHOWN is what must be persisted. A run already recorded on
          // this device (e.g. as a guest, before the profile switched
          // identity on login) skips straight to the server report.
          final flow = ref.read(tifoFlowProvider.notifier);
          final alreadyStarted = await flow.hasCompletedTutorialOnDevice();
          if (!alreadyStarted) {
            if (!context.mounted || !surface.isVisible(ref)) {
              return false;
            }
            await showTifoGuidedTutorial(context);
            await flow.markTutorialCompletedOnDevice();
          }
          // Always report to the backend, even when the device flag was
          // already set — the server flag is per-PROFILE, and a guest run
          // that set the device flag may not yet be reported against a
          // freshly logged-in profile (identity switches bearer on staging).
          await session.markTutorialStarted();
          // If the server didn't record it (offline), stop instead of
          // re-pushing the tour on the next loop iteration.
          if (ref.read(tifoSessionProvider).profile?.tutorialCompleted != true) {
            return false;
          }

        case TifoJourneyStep.teamSelect:
          final picked = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(fullscreenDialog: true, builder: (_) => const TifoTeamSelectScreen()),
          );
          // "Maybe Later" (or back) → browse-only; stop the gate walk.
          if (picked != true) {
            return false;
          }
      }
    }
    return ref.read(tifoSessionProvider).nextStep == TifoJourneyStep.ready;
  }
}
