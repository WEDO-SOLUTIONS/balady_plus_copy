import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/tifo_team.dart';
import 'package:mapness/shared/providers/hive.dart';

/// Tracks one-off state for the TIFO journey:
///  * [selectedTeam]   — the team the user picked on team-select.
///  * [hasSelectedTeam] — true once the user has tapped "Activate Tifo" and
///    reached the team dashboard.
///  * [hasSeenTutorial] — true once the user has dismissed the in-game
///    4-step tutorial (either by completing it or skipping).
class TifoFlowState {
  const TifoFlowState({
    required this.selectedTeam,
    required this.hasSelectedTeam,
    required this.hasSeenTutorial,
    required this.hasSeenEntry,
    this.showJoinPill = false,
  });

  final TifoTeam? selectedTeam;
  final bool hasSelectedTeam;
  final bool hasSeenTutorial;

  /// True once the stories-style entry-popup has been shown this session, so a
  /// second ⚽ tap just toggles the map layer instead of re-showing the intro.
  final bool hasSeenEntry;

  /// The floating "Dominate with your team" pill (design node 398:8792) is
  /// shown only during the very first game launch on this device — true for
  /// that session only, gated by the persisted `hasLaunched` Hive flag.
  final bool showJoinPill;

  /// True iff a ⚽ tap should kick off the tutorial right now.
  bool get shouldPlayTutorial => hasSelectedTeam && !hasSeenTutorial;

  TifoFlowState copyWith({
    TifoTeam? selectedTeam,
    bool? hasSelectedTeam,
    bool? hasSeenTutorial,
    bool? hasSeenEntry,
    bool? showJoinPill,
  }) => TifoFlowState(
    selectedTeam: selectedTeam ?? this.selectedTeam,
    hasSelectedTeam: hasSelectedTeam ?? this.hasSelectedTeam,
    hasSeenTutorial: hasSeenTutorial ?? this.hasSeenTutorial,
    hasSeenEntry: hasSeenEntry ?? this.hasSeenEntry,
    showJoinPill: showJoinPill ?? this.showJoinPill,
  );
}

class TifoFlowController extends Notifier<TifoFlowState> {
  @override
  TifoFlowState build() => const TifoFlowState(
    selectedTeam: null,
    hasSelectedTeam: false,
    hasSeenTutorial: false,
    hasSeenEntry: false,
  );

  void setSelectedTeam(TifoTeam team) {
    state = state.copyWith(selectedTeam: team);
  }

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

  /// Called when the TIFO layer gets enabled. On the very first launch ever
  /// (per device) turns the "Dominate with your team" pill on for this session
  /// and stamps the persisted flag so later launches never show it again.
  Future<void> markGameLaunched() async {
    final box = await ref.read(hiveProvider('tifo').future);
    final hasLaunched = box.get('hasLaunched') == true;
    if (!hasLaunched) {
      await box.put('hasLaunched', true);
      state = state.copyWith(showJoinPill: true);
    }
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
