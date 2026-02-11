import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/errors_exports.dart' show ServerFailure;
import '../../../../core/services/services_exports.dart' show NoParams;
import '../../../../core/utils/utils_exports.dart' show BlocRequestStatus, Nullable;
import '../../delegators_exports.dart' show AgentEntity, DelegatorEntity, GetDelegators, GetAgents;
import '../../../delegators/services/account_selection_service.dart';

part 'delegators_state.dart';

class DelegatorsCubit extends Cubit<DelegatorsState> {
  final GetDelegators _getDelegators;
  final GetAgents _getAgents;

  DelegatorsCubit(this._getDelegators, this._getAgents) : super(const DelegatorsState(tab: 0));

  void getDelegators() async {
    if (state.delegators.isEmpty) {
      emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));
    } else {
      emit(state.copyWith(status: BlocRequestStatus.submissionPostLoading));
    }

    final failureOrSuccess = await _getDelegators(NoParams());

    failureOrSuccess.fold(
      (failure) {
        BlocRequestStatus status = (failure as ServerFailure).errorCode == "003"
            ? BlocRequestStatus.submissionGetSuccess
            : BlocRequestStatus.submissionGetFailure;

        emit(state.copyWith(status: status, errorMessage: failure.errorMessage));
      },
      (delegators) {
        emit(state.copyWith(status: BlocRequestStatus.submissionGetSuccess, delegators: delegators));
        // Restore selection from preferences after loading delegators
        restoreSelectionFromPreferences();
      },
    );
  }

  void selectDelegator(DelegatorEntity? delegator) {
    emit(state.copyWith(selectedDelegator: Nullable(delegator), sAgent: Nullable(null)));

    // Save selection to SharedPrefs
    AccountSelectionService.saveCurrentSelection(this);
  }

  void selectAgent(AgentEntity? agent) {
    emit(state.copyWith(selectedDelegator: Nullable(null), sAgent: Nullable(agent)));

    // Save selection to SharedPrefs
    AccountSelectionService.saveCurrentSelection(this);
  }

  void clearSelection() {
    emit(state.copyWith(selectedDelegator: Nullable(null), sAgent: Nullable(null)));

    // Save cleared selection to SharedPrefs
    AccountSelectionService.saveCurrentSelection(this);
  }

  void changeTab(int index) {
    emit(state.copyWith(tab: index));
  }

  void getAgents() async {
    if (state.agents.isEmpty) {
      emit(state.copyWith(agentStatus: BlocRequestStatus.submissionGetLoading));
    } else {
      emit(state.copyWith(agentStatus: BlocRequestStatus.submissionPostLoading));
    }

    final failureOrSuccess = await _getAgents(NoParams());

    failureOrSuccess.fold(
      (failure) {
        print("failure $failure");
        BlocRequestStatus status = (failure as ServerFailure).errorCode == "2"
            ? BlocRequestStatus.submissionGetSuccess
            : BlocRequestStatus.submissionGetFailure;

        emit(state.copyWith(agentStatus: status, errorMessage: failure.errorMessage));
      },
      (delegators) {
        emit(state.copyWith(agentStatus: BlocRequestStatus.submissionGetSuccess, agents: delegators));
        // Restore selection from preferences after loading agents
        restoreSelectionFromPreferences();
      },
    );
  }

  void clearDelegators() {
    emit(
      state.copyWith(
        status: BlocRequestStatus.submissionGetLoading,
        agentStatus: BlocRequestStatus.submissionGetLoading,
      ),
    );

    emit(
      state.copyWith(
        status: BlocRequestStatus.submissionGetSuccess,
        agentStatus: BlocRequestStatus.submissionGetSuccess,
        delegators: [],
        agents: [],
      ),
    );
  }

  /// Restores the selected delegator/agent from SharedPreferences
  /// Should be called after delegators/agents are loaded
  void restoreSelectionFromPreferences() {
    final savedDelegatorId = AccountSelectionService.getSavedDelegatorId();
    final savedAgentId = AccountSelectionService.getSavedAgentId();

    if (savedDelegatorId != null && state.delegators.isNotEmpty) {
      try {
        final delegator = state.delegators.firstWhere((d) => d.id == savedDelegatorId);
        emit(state.copyWith(selectedDelegator: Nullable(delegator), sAgent: Nullable(null)));
        print('✅ Restored delegator selection: ${delegator.entityName}');
      } catch (e) {
        print('⚠️ Saved delegator $savedDelegatorId not found in current list');
      }
    } else if (savedAgentId != null && state.agents.isNotEmpty) {
      try {
        final agent = state.agents.firstWhere((a) => a.agencyNumber == savedAgentId);
        emit(state.copyWith(selectedDelegator: Nullable(null), sAgent: Nullable(agent)));
        print('✅ Restored agent selection: ${agent.grantorName}');
      } catch (e) {
        print('⚠️ Saved agent $savedAgentId not found in current list');
      }
    }
  }
}
