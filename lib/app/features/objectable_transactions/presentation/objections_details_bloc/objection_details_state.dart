part of 'objection_details_bloc.dart';

class ObjectionDetailsState extends Equatable {
  final BlocStatus status;
  final BlocStatus objectionsListStatus;
  final String? errorMessage;
  final ObjectionDetails? details;

  ObjectionDetailsState(
      {this.status = BlocStatus.initial,
      this.objectionsListStatus = BlocStatus.initial,
      this.errorMessage,
      this.details});

  ObjectionDetailsState copyWith(
      {BlocStatus? status,
      BlocStatus? objectionsListStatus,
      String? errorMessage,
      ObjectionDetails? details}) {
    return ObjectionDetailsState(
        status: status ?? this.status,
        objectionsListStatus: objectionsListStatus ?? this.objectionsListStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        details: details ?? this.details);
  }

  @override
  List<Object?> get props => [status, objectionsListStatus, details];
}
