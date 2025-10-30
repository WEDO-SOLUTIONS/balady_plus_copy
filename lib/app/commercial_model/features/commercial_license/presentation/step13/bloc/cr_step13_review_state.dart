part of 'cr_step13_review_cubit.dart';

class CrStep13ReviewState extends Equatable {
  final BlocStatus status;
  final String errorMessage;
  final IssueCommercialConculsion? conclusion;

  const CrStep13ReviewState(
      {this.status = BlocStatus.initial,
      this.errorMessage = '',
      this.conclusion});

  @override
  List<Object?> get props => [errorMessage, status, status];

  CrStep13ReviewState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      IssueCommercialConculsion? conclusion}) {
    return CrStep13ReviewState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        conclusion: conclusion ?? this.conclusion);
  }
}
