part of 'delegators_cubit.dart';

class DelegatorsState extends Equatable {
  final BlocRequestStatus status;
  final BlocRequestStatus agentStatus;

  final List<DelegatorEntity> delegators;
  final DelegatorEntity? selectedDelegate;
  final List<AgentEntity> agents;
  final AgentEntity? selectedAgent;
  final String? errorMessage;

  const DelegatorsState({
    this.status = BlocRequestStatus.initial,
    this.agentStatus = BlocRequestStatus.initial,
    this.delegators = const [],
    this.selectedDelegate,
    this.agents = const [],
    this.selectedAgent,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  DelegatorsState copyWith({
    BlocRequestStatus? status,
    BlocRequestStatus? agentStatus,
    List<DelegatorEntity>? delegators,
    Nullable<DelegatorEntity?>? selectedDelegator,
    List<AgentEntity>? agents,
    Nullable<AgentEntity?>? sAgent,
    String? errorMessage,
  }) {
    return DelegatorsState(
      status: status ?? this.status,
      agentStatus: agentStatus ?? this.agentStatus,
      delegators: delegators ?? this.delegators,
      selectedDelegate: selectedDelegator == null
          ? selectedDelegate
          : selectedDelegator.value,
      agents: agents ?? this.agents,
      selectedAgent: sAgent == null ? selectedAgent : sAgent.value,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        agentStatus,
        delegators,
        selectedDelegate,
        agents,
        selectedAgent,
        errorMessage,
      ];
}
