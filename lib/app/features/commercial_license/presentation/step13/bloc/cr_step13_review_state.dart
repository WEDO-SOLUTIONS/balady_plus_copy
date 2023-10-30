part of 'cr_step13_review_cubit.dart';

class CrStep13ReviewState extends Equatable {
  final BlocStatus status;
  final String errorMessage;

  const CrStep13ReviewState({
    this.status = BlocStatus.initial,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [errorMessage, status, status];

  CrStep13ReviewState copyWith({
    BlocStatus? status,
    String? errorMessage,
  }) {
    return CrStep13ReviewState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
