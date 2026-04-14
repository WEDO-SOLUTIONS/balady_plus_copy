part of 'delegators_cubit.dart';

/// Represents the four possible account-type states after loading completes.
enum DelegatorsAccountStatus {
  /// Initial state — [loadData] has not been called yet.
  initial,

  /// Both APIs are currently in flight.
  loading,

  /// Both APIs finished and the user has ≥1 delegator or agent →
  /// this is a **business** account.
  businessAccount,

  /// Both APIs finished and there are no delegators and no agents →
  /// this is a **normal** (personal) account.
  normalAccount,

  /// One or both APIs returned a hard error.
  failed,
}

class DelegatorsState extends Equatable {
  final List<DelegatorEntity> delegators;
  final DelegatorEntity? selectedDelegate;
  final List<AgentEntity> agents;
  final AgentEntity? selectedAgent;

  /// Per-source error messages — avoids one overwriting the other.
  final String? delegatorErrorMessage;
  final String? agentErrorMessage;

  final int tab;

  /// Single source-of-truth for the account-type state.
  /// Use this in the UI instead of combining multiple boolean checks.
  final DelegatorsAccountStatus accountStatus;

  const DelegatorsState({
    this.delegators = const [],
    this.selectedDelegate,
    this.agents = const [],
    this.selectedAgent,
    this.delegatorErrorMessage,
    this.agentErrorMessage,
    this.accountStatus = DelegatorsAccountStatus.initial,
    required this.tab,
  });

  // ── Convenience getters ──────────────────────────────────────────────────

  /// Backward-compat alias: returns whichever error is set (delegator first).
  String get error => delegatorErrorMessage ?? agentErrorMessage ?? '';

  /// Deprecated alias kept for callers that still use [errorMessage].
  String? get errorMessage => delegatorErrorMessage ?? agentErrorMessage;

  /// True while data is being fetched.
  bool get isInitialLoading => accountStatus == DelegatorsAccountStatus.loading;

  /// True while either source is refreshing (data already present).
  bool get isRefreshing => accountStatus == DelegatorsAccountStatus.loading;

  /// True only when both sources have finished loading (success or normal).
  bool get isBothLoaded =>
      accountStatus == DelegatorsAccountStatus.businessAccount ||
      accountStatus == DelegatorsAccountStatus.normalAccount;

  /// True when the user has at least one delegator or agent.
  bool get isUserAccountBusiness =>
      accountStatus == DelegatorsAccountStatus.businessAccount;

  /// True when loading failed.
  bool get isFailed => accountStatus == DelegatorsAccountStatus.failed;

  // ── CopyWith ────────────────────────────────────────────────────────────

  DelegatorsState copyWith({
    List<DelegatorEntity>? delegators,
    Nullable<DelegatorEntity?>? selectedDelegator,
    List<AgentEntity>? agents,
    Nullable<AgentEntity?>? sAgent,
    String? delegatorErrorMessage,
    String? agentErrorMessage,
    DelegatorsAccountStatus? accountStatus,
    int? tab,
  }) {
    return DelegatorsState(
      delegators: delegators ?? this.delegators,
      selectedDelegate:
          selectedDelegator == null ? selectedDelegate : selectedDelegator.value,
      agents: agents ?? this.agents,
      selectedAgent: sAgent == null ? selectedAgent : sAgent.value,
      delegatorErrorMessage:
          delegatorErrorMessage ?? this.delegatorErrorMessage,
      agentErrorMessage: agentErrorMessage ?? this.agentErrorMessage,
      accountStatus: accountStatus ?? this.accountStatus,
      tab: tab ?? this.tab,
    );
  }

  @override
  List<Object?> get props => [
        delegators,
        selectedDelegate,
        agents,
        selectedAgent,
        delegatorErrorMessage,
        agentErrorMessage,
        accountStatus,
        tab,
      ];
}
