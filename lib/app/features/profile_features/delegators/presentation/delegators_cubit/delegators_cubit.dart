import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/errors_exports.dart' show ServerFailure;
import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, Nullable;
import '../../delegators_exports.dart'
    show AgentEntity, DelegatorEntity, GetDelegators, GetAgents;

part 'delegators_state.dart';

class DelegatorsCubit extends Cubit<DelegatorsState> {
  final GetDelegators _getDelegators;
  final GetAgents _getAgents;

  DelegatorsCubit(this._getDelegators, this._getAgents)
      : super(const DelegatorsState(tab: 0));

  void getDelegators() async {
    if (state.delegators.isEmpty)
      emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));
    else
      emit(state.copyWith(status: BlocRequestStatus.submissionPostLoading));

    final failureOrSuccess = await _getDelegators(NoParams());

    failureOrSuccess.fold(
      (failure) {
        BlocRequestStatus status = (failure as ServerFailure).errorCode == "003"
            ? BlocRequestStatus.submissionGetSuccess
            : BlocRequestStatus.submissionGetFailure;

        emit(state.copyWith(
          status: status,
          errorMessage: failure.errorMessage,
        ));
      },
      (delegators) {
        emit(state.copyWith(
          status: BlocRequestStatus.submissionGetSuccess,
          delegators: delegators,
        ));
      },
    );
  }

  void selectDelegator(DelegatorEntity? delegator) {
    emit(state.copyWith(
        selectedDelegator: Nullable(delegator), sAgent: Nullable(null)));
  }

  void selectAgent(AgentEntity? agent) {
    emit(state.copyWith(
        selectedDelegator: Nullable(null), sAgent: Nullable(agent)));
  }

  void changeTab(int index) {
    emit(state.copyWith(tab: index));
  }

  void getAgents() async {
    if (state.agents.isEmpty)
      emit(state.copyWith(agentStatus: BlocRequestStatus.submissionGetLoading));
    else
      emit(
          state.copyWith(agentStatus: BlocRequestStatus.submissionPostLoading));

    final failureOrSuccess = await _getAgents(NoParams());

    failureOrSuccess.fold(
      (failure) {
        print("failure $failure");
        BlocRequestStatus status = (failure as ServerFailure).errorCode == "2"
            ? BlocRequestStatus.submissionGetSuccess
            : BlocRequestStatus.submissionGetFailure;

        emit(state.copyWith(
          agentStatus: status,
          errorMessage: failure.errorMessage,
        ));
      },
      (delegators) {
        emit(state.copyWith(
          agentStatus: BlocRequestStatus.submissionGetSuccess,
          agents: delegators,
        ));
      },
    );
  }

  void clearDelegators() {
    emit(state.copyWith(
        status: BlocRequestStatus.submissionGetLoading,
        agentStatus: BlocRequestStatus.submissionGetLoading));

    emit(state.copyWith(
        status: BlocRequestStatus.submissionGetSuccess,
        agentStatus: BlocRequestStatus.submissionGetSuccess,
        delegators: [],
        agents: []));
  }
}
