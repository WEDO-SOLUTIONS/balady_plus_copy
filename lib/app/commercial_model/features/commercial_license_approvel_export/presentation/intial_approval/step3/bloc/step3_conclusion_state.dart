part of 'step3_conclusion_cubit.dart';

class Step3ConclusionState extends Equatable {
  final BlocStatus status;
  final int? requestId;
  final String errorMessage;
  final IssueCommercialConculsionEntity? issueCommercialConculsionEntity;

  const Step3ConclusionState({
    this.status = BlocStatus.initial,
    this.requestId,
    this.issueCommercialConculsionEntity,
    this.errorMessage = '',
  });




  @override
  List<Object?> get props =>
      [errorMessage, status,issueCommercialConculsionEntity];

  Step3ConclusionState copyWith({
    BlocStatus? status,
    IssueCommercialConculsionEntity? issueCommercialConculsionEntity,
    int? requestId,
    String? errorMessage,
  }) {
    return Step3ConclusionState(


        errorMessage: errorMessage ?? this.errorMessage,
        requestId: requestId ?? this.requestId,
        issueCommercialConculsionEntity: issueCommercialConculsionEntity ?? this.issueCommercialConculsionEntity,

        status: status ?? this.status);
  }


}
