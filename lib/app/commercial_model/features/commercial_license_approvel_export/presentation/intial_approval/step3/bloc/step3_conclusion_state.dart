part of 'step3_conclusion_cubit.dart';

class Step3ConclusionState extends Equatable {
  final BlocStatus status;
  final int? requestId;
  final String errorMessage;
  final    String? workFlowName;
  final IssueCommercialConculsionEntity? issueCommercialConculsionEntity;

  const Step3ConclusionState({
    this.status = BlocStatus.initial,
    this.requestId,
    this.issueCommercialConculsionEntity,
    this.errorMessage = '',
    this.workFlowName,
  });




  @override
  List<Object?> get props =>
      [errorMessage, status,issueCommercialConculsionEntity,workFlowName];

  Step3ConclusionState copyWith({
    BlocStatus? status,
    IssueCommercialConculsionEntity? issueCommercialConculsionEntity,
    int? requestId,
    String? errorMessage,
    String? workFlowName
  }) {
    return Step3ConclusionState(


        errorMessage: errorMessage ?? this.errorMessage,
        requestId: requestId ?? this.requestId,
        issueCommercialConculsionEntity: issueCommercialConculsionEntity ?? this.issueCommercialConculsionEntity,
        workFlowName:workFlowName??this.workFlowName,
        status: status ?? this.status);
  }


}
