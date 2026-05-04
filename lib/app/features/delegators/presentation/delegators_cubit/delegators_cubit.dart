import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/errors_exports.dart' show ServerFailure;
import '../../../../core/services/services_exports.dart' show NoParams;
import '../../../../core/utils/utils_exports.dart' show Nullable;
import '../../delegators_exports.dart'
    show AgentEntity, DelegatorEntity, GetDelegators, GetAgents;
import '../../../delegators/services/account_selection_service.dart';

part 'delegators_state.dart';

class DelegatorsCubit extends Cubit<DelegatorsState> {
  final GetDelegators _getDelegators;
  final GetAgents _getAgents;

  DelegatorsCubit(this._getDelegators, this._getAgents)
    : super(const DelegatorsState(tab: 0));

  // ── Private helpers ──────────────────────────────────────────────────────

  /// "No data found" error codes — treated as empty success, not a hard error.
  static const _emptyDataCodes = {'003', '2'};

  bool _isEmptyDataFailure(ServerFailure failure) =>
      _emptyDataCodes.contains(failure.errorCode?.toString());

  /// Emits a new selection state and persists it.
  void _updateSelection({DelegatorEntity? delegator, AgentEntity? agent}) {
    emit(state.copyWith(
      selectedDelegator: Nullable(delegator),
      sAgent: Nullable(agent),
    ));
    AccountSelectionService.saveCurrentSelection(this);
  }

  // ── Public API ───────────────────────────────────────────────────────────

  /// Fetches delegators and agents **concurrently** and resolves a single
  /// [DelegatorsAccountStatus] from the combined result.
  Future<void> loadData() async {
    emit(state.copyWith(accountStatus: DelegatorsAccountStatus.loading));

    final results = await Future.wait([
      _getDelegators(NoParams()),
      _getAgents(NoParams()),
    ]);

    // ── Delegators result ─────────────────────────────────────────────────
    List<DelegatorEntity>? newDelegators;
    bool delegatorsFailed = false;
    String? delegatorError;

    results[0].fold(
      (failure) {
        final f = failure as ServerFailure;
        delegatorsFailed = !_isEmptyDataFailure(f);
        delegatorError = f.errorMessage;
      },
      (data) => newDelegators = data as List<DelegatorEntity>,
    );

    // ── Agents result ─────────────────────────────────────────────────────
    List<AgentEntity>? newAgents;
    bool agentsFailed = false;
    String? agentError;

    results[1].fold(
      (failure) {
        final f = failure as ServerFailure;
        agentsFailed = !_isEmptyDataFailure(f);
        agentError = f.errorMessage;
      },
      (data) => newAgents = data as List<AgentEntity>,
    );

    // ── Resolve account status ────────────────────────────────────────────
    final resolvedDelegators = newDelegators ?? state.delegators;
    final resolvedAgents = newAgents ?? state.agents;

    final DelegatorsAccountStatus resolvedAccountStatus;
    if (delegatorsFailed || agentsFailed) {
      resolvedAccountStatus = DelegatorsAccountStatus.failed;
    } else if (resolvedDelegators.isNotEmpty || resolvedAgents.isNotEmpty) {
      resolvedAccountStatus = DelegatorsAccountStatus.businessAccount;
    } else {
      resolvedAccountStatus = DelegatorsAccountStatus.normalAccount;
    }

    emit(state.copyWith(
      delegators: resolvedDelegators,
      agents: resolvedAgents,
      delegatorErrorMessage: delegatorError,
      agentErrorMessage: agentError,
      accountStatus: resolvedAccountStatus,
    ));

    if (state.isBothLoaded) {
      restoreSelectionFromPreferences();
    }
  }

  // ── Selection management ─────────────────────────────────────────────────

  void selectDelegator(DelegatorEntity? delegator) =>
      _updateSelection(delegator: delegator);

  void selectAgent(AgentEntity? agent) => _updateSelection(agent: agent);

  void clearSelection() => _updateSelection();

  void clearData() {
    emit(
      state.copyWith(
        selectedDelegator: Nullable(null),
        sAgent: Nullable(null),
        agents: [],
        delegators: [],
        accountStatus: DelegatorsAccountStatus.initial,
      ),
    );
    AccountSelectionService.saveCurrentSelection(this);
  }

  void changeTab(int index) => emit(state.copyWith(tab: index));

  // ── Preference restoration ───────────────────────────────────────────────

  /// Restores the previously saved delegator/agent from SharedPreferences.
  ///
  /// This is a no-op when the relevant list is still empty, making it safe
  /// to call at any time without risking a partial restoration.
  void restoreSelectionFromPreferences() {
    final savedDelegatorId = AccountSelectionService.getSavedDelegatorId();
    final savedAgentId = AccountSelectionService.getSavedAgentId();

    if (savedDelegatorId != null && state.delegators.isNotEmpty) {
      final match = state.delegators
          .where((d) => d.id == savedDelegatorId)
          .firstOrNull;

      if (match != null) {
        emit(
          state.copyWith(
            selectedDelegator: Nullable(match),
            sAgent: Nullable(null),
          ),
        );
        assert(() {
          // ignore: avoid_print
          print('✅ Restored delegator: ${match.entityName}');
          return true;
        }());
      } else {
        assert(() {
          // ignore: avoid_print
          print('⚠️ Saved delegator $savedDelegatorId not found');
          return true;
        }());
      }
    } else if (savedAgentId != null && state.agents.isNotEmpty) {
      final match = state.agents
          .where((a) => a.agencyNumber == savedAgentId)
          .firstOrNull;

      if (match != null) {
        emit(
          state.copyWith(
            selectedDelegator: Nullable(null),
            sAgent: Nullable(match),
          ),
        );
        assert(() {
          // ignore: avoid_print
          print('✅ Restored agent: ${match.grantorName}');
          return true;
        }());
      } else {
        assert(() {
          // ignore: avoid_print
          print('⚠️ Saved agent $savedAgentId not found');
          return true;
        }());
      }
    }
  }
}
