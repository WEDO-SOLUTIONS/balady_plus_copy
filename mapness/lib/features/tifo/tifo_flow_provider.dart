import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/hive.dart';

/// Tracks one-off state for the TIFO journey:
///  * [hasSelectedTeam] — true once the user has tapped "Activate Tifo" and
///    reached the team dashboard.
///  * [hasSeenTutorial] — true once the user has dismissed the in-game
///    4-step tutorial (either by completing it or skipping).
class TifoFlowState {
  const TifoFlowState({
    required this.hasSelectedTeam,
    required this.hasSeenTutorial,
    required this.hasSeenEntry,
    this.tutorialShownUnreported = false,
  });

  final bool hasSelectedTeam;
  final bool hasSeenTutorial;

  /// True once the stories-style entry-popup has been shown this session, so a
  /// second ⚽ tap just toggles the map layer instead of re-showing the intro.
  final bool hasSeenEntry;

  /// The guided tour ran in THIS app session but the backend never recorded it
  /// (offline — see [TifoSessionController.markTutorialStarted]).
  ///
  /// Deliberately NOT persisted, unlike the Hive `tutorialCompleted` flag:
  /// BRD V2 US-03 BR-06 makes a connectivity drop the one case where a shown
  /// tour must still count as *not started*, so the next session has to offer
  /// it again. This only stops the same session from re-pushing the tour on
  /// every play-intent tap while the connection is still down.
  final bool tutorialShownUnreported;

  /// True iff a ⚽ tap should kick off the tutorial right now.
  bool get shouldPlayTutorial => hasSelectedTeam && !hasSeenTutorial;

  TifoFlowState copyWith({
    bool? hasSelectedTeam,
    bool? hasSeenTutorial,
    bool? hasSeenEntry,
    bool? tutorialShownUnreported,
  }) => TifoFlowState(
    hasSelectedTeam: hasSelectedTeam ?? this.hasSelectedTeam,
    hasSeenTutorial: hasSeenTutorial ?? this.hasSeenTutorial,
    hasSeenEntry: hasSeenEntry ?? this.hasSeenEntry,
    tutorialShownUnreported: tutorialShownUnreported ?? this.tutorialShownUnreported,
  );
}

class TifoFlowController extends Notifier<TifoFlowState> {
  @override
  TifoFlowState build() => const TifoFlowState(
    hasSelectedTeam: false,
    hasSeenTutorial: false,
    hasSeenEntry: false,
  );

  void markTeamSelected() {
    if (state.hasSelectedTeam) {
      return;
    }
    state = state.copyWith(hasSelectedTeam: true);
  }

  /// See [TifoFlowState.tutorialShownUnreported].
  void markTutorialShownUnreported() {
    if (state.tutorialShownUnreported) {
      return;
    }
    state = state.copyWith(tutorialShownUnreported: true);
  }

  void markTutorialSeen() {
    if (state.hasSeenTutorial) {
      return;
    }
    state = state.copyWith(hasSeenTutorial: true);
  }

  void markEntrySeen() {
    if (state.hasSeenEntry) {
      return;
    }
    state = state.copyWith(hasSeenEntry: true);
  }

  /// One-shot, persisted gate for the tutorial intro sheet (BRD: the tutorial
  /// autoruns on the FIRST entry only; replays go through Support / the
  /// play-gate). Returns true exactly once per install and stamps the flag —
  /// without persistence the sheet re-offered itself on every app restart.
  Future<bool> consumeTutorialOffer() async {
    final box = await ref.read(hiveProvider('tifo').future);
    if (box.get('tutorialOffered') == true) {
      return false;
    }
    await box.put('tutorialOffered', true);
    return true;
  }

  /// Device-side record that the guided tutorial has been COMPLETED at least
  /// once (BRD V2 US-03: only a finished run clears the gate). The server
  /// flag lives per profile, and the profile changes when a guest signs in
  /// (the bearer IS the identity on staging) — without this the player would
  /// be re-gated into the tour right after logging in.
  Future<bool> hasCompletedTutorialOnDevice() async {
    final box = await ref.read(hiveProvider('tifo').future);
    return box.get('tutorialCompleted') == true;
  }

  Future<void> markTutorialCompletedOnDevice() async {
    final box = await ref.read(hiveProvider('tifo').future);
    await box.put('tutorialCompleted', true);
  }

  /// Support → "Replay tutorial": drops every device-side record that the
  /// tutorial has already been seen, so the guided tour can run again from
  /// screen 1 exactly as it does on a first launch.
  ///
  /// The per-profile server flag has no reset endpoint (`/tutorial/complete`
  /// is one-way), and a replay is an explicit user action rather than an
  /// unmet gate — so the tour re-stamps [markTutorialCompletedOnDevice] when
  /// the replayed run ends and the player is never re-gated into it.
  Future<void> resetTutorial() async {
    final box = await ref.read(hiveProvider('tifo').future);
    await box.delete('tutorialCompleted');
    await box.delete('tutorialOffered');
    state = state.copyWith(hasSeenTutorial: false, tutorialShownUnreported: false);
  }
}

final tifoFlowProvider = NotifierProvider<TifoFlowController, TifoFlowState>(TifoFlowController.new);
