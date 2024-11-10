part of 'identical_list_bloc.dart';

class IdenticalListState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final List<DeceasedIdenticalItem>? details;
  final bool isDriver;
  final bool? isCompleted;
  final int? requestID;
  IdenticalListState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      required this.isDriver,
        this.requestID,
       this.details,
      this.isCompleted});

  IdenticalListState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final bool? isDriver,
        final int? requestID,
      final List<DeceasedIdenticalItem>? deceasedRequestItems,
      final bool? isCompleted}) {
    return IdenticalListState(
        status: status ?? this.status,
        isDriver: isDriver ?? this.isDriver,
        requestID: requestID ?? this.requestID,
        errorMessage: errorMessage ?? this.errorMessage,
        details: deceasedRequestItems ?? this.details,
        isCompleted: isCompleted ?? this.isCompleted);
  }

  @override
  List<Object?> get props => [status, details, errorMessage, isCompleted];
}
