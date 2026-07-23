import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/team_select_screen.dart';
import 'package:mapness/features/tifo/tifo_login.dart';
import 'package:mapness/features/tifo/tutorial/tifo_guided_tutorial.dart';

/// Drives the BRD play-gate: before a player can challenge a building they must
/// be logged in, have started the tutorial, and have selected a team — routed
/// in that order (BRD US-02). Each gate screen is pushed in turn; the flow
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
          // Starting the tutorial clears the gate permanently (BRD), so mark it
          // before showing — skipping afterwards must not re-gate.
          await session.markTutorialStarted();
          if (!context.mounted) {
            return false;
          }
          await showTifoGuidedTutorial(context);

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
