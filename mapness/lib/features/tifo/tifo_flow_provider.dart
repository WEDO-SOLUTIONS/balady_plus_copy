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
  });

  final bool hasSelectedTeam;
  final bool hasSeenTutorial;

  /// True once the stories-style entry-popup has been shown this session, so a
  /// second ⚽ tap just toggles the map layer instead of re-showing the intro.
  final bool hasSeenEntry;

  /// True iff a ⚽ tap should kick off the tutorial right now.
  bool get shouldPlayTutorial => hasSelectedTeam && !hasSeenTutorial;

  TifoFlowState copyWith({
    bool? hasSelectedTeam,
    bool? hasSeenTutorial,
    bool? hasSeenEntry,
  }) => TifoFlowState(
    hasSelectedTeam: hasSelectedTeam ?? this.hasSelectedTeam,
    hasSeenTutorial: hasSeenTutorial ?? this.hasSeenTutorial,
    hasSeenEntry: hasSeenEntry ?? this.hasSeenEntry,
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
}

final tifoFlowProvider = NotifierProvider<TifoFlowController, TifoFlowState>(TifoFlowController.new);
