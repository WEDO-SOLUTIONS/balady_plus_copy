import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/team_select_screen.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_login.dart';
import 'package:mapness/features/tifo/tutorial/tifo_guided_tutorial.dart';

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

  Future<bool> ensurePlayReady(BuildContext context) async {
    final session = ref.read(tifoSessionProvider.notifier);

    // Ensure we have a fresh profile to gate on. On staging this also lazily
    // registers the user.
    if (ref.read(tifoSessionProvider).profile == null) {
      await session.load();
    }

    // Walk the gates. Re-read state after each step since the profile changes.
    // Cap iterations so a backend hiccup can't spin forever.
    for (var guard = 0; guard < 4; guard++) {
      if (!context.mounted) {
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
          // BRD V2 US-03 BR-06: an interrupted/abandoned tutorial counts as
          // NOT started — only a completed run clears the gate, so report it
          // to the backend after the tour finishes, not before. A run
          // already completed on this device (e.g. as a guest, before the
          // profile switched identity on login) skips straight to the report.
          final flow = ref.read(tifoFlowProvider.notifier);
          var completed = await flow.hasCompletedTutorialOnDevice();
          if (!completed) {
            if (!context.mounted) {
              return false;
            }
            completed = await showTifoGuidedTutorial(context);
          }
          if (!completed) {
            return false;
          }
          await flow.markTutorialCompletedOnDevice();
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
