part of 'request_details_bloc_bloc.dart';

class RequestDetailsState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final DeceasedRequestDetails details;
  final bool isDriver;
  final bool? isCompleted;
  RequestDetailsState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      required this.isDriver,
      required this.details,
      this.isCompleted});

  RequestDetailsState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final bool? isDriver,
      final DeceasedRequestDetails? deceasedRequestItems,
      final bool? isCompleted}) {
    return RequestDetailsState(
        status: status ?? this.status,
        isDriver: isDriver ?? this.isDriver,
        errorMessage: errorMessage ?? this.errorMessage,
        details: deceasedRequestItems ?? this.details,
        isCompleted: isCompleted ?? this.isCompleted);
  }

  @override
  List<Object?> get props => [status, details, errorMessage, isCompleted];
}
