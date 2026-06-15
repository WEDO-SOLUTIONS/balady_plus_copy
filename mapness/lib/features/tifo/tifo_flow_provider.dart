import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/tifo_team.dart';

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
  });

  final TifoTeam? selectedTeam;
  final bool hasSelectedTeam;
  final bool hasSeenTutorial;

  /// True iff a ⚽ tap should kick off the tutorial right now.
  bool get shouldPlayTutorial => hasSelectedTeam && !hasSeenTutorial;

  TifoFlowState copyWith({
    TifoTeam? selectedTeam,
    bool? hasSelectedTeam,
    bool? hasSeenTutorial,
  }) =>
      TifoFlowState(
        selectedTeam: selectedTeam ?? this.selectedTeam,
        hasSelectedTeam: hasSelectedTeam ?? this.hasSelectedTeam,
        hasSeenTutorial: hasSeenTutorial ?? this.hasSeenTutorial,
      );
}

class TifoFlowController extends Notifier<TifoFlowState> {
  @override
  TifoFlowState build() => const TifoFlowState(
        selectedTeam: null,
        hasSelectedTeam: false,
        hasSeenTutorial: false,
      );

  void setSelectedTeam(TifoTeam team) {
    state = state.copyWith(selectedTeam: team);
  }

  void markTeamSelected() {
    if (state.hasSelectedTeam) return;
    state = state.copyWith(hasSelectedTeam: true);
  }

  void markTutorialSeen() {
    if (state.hasSeenTutorial) return;
    state = state.copyWith(hasSeenTutorial: true);
  }
}

final tifoFlowProvider =
    NotifierProvider<TifoFlowController, TifoFlowState>(TifoFlowController.new);
