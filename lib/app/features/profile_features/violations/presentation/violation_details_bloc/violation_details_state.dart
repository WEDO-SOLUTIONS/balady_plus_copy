part of 'violation_details_bloc.dart';

class ViolationDetailsState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final ViolationDetailsEntity? details;

  const ViolationDetailsState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.details,
  });

  ViolationDetailsState copyWith({
    BlocStatus? status,
    String? errorMessage,
    ViolationDetailsEntity? details,
  }) {
    return ViolationDetailsState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        details: details ?? this.details);
  }

  @override
  List<Object?> get props => [
        status,
        details,
        errorMessage,
      ];
}
