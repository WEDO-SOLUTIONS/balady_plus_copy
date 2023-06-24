part of 'transaction_details_bloc.dart';

class TransactionDetailsState extends Equatable {
  final BlocStatus status;
  final BlocStatus gisStatus;
  final BlocStatus objectionsListStatus;
  final String? errorMessage;
  final GISResponse? gisLocation;
  final TransactionDetails? details;

  TransactionDetailsState(
      {this.status = BlocStatus.initial,
      this.gisStatus = BlocStatus.initial,
      this.objectionsListStatus = BlocStatus.initial,
      this.errorMessage,
      this.details,
      this.gisLocation});

  TransactionDetailsState copyWith(
      {BlocStatus? status,
      BlocStatus? gisStatus,
      BlocStatus? objectionsListStatus,
      String? errorMessage,
      GISResponse? gisLocation,
      TransactionDetails? details}) {
    return TransactionDetailsState(
        status: status ?? this.status,
        gisStatus: gisStatus ?? this.gisStatus,
        objectionsListStatus: objectionsListStatus ?? this.objectionsListStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        gisLocation: gisLocation ?? this.gisLocation,
        details: details ?? this.details);
  }

  @override
  List<Object?> get props =>
      [status, objectionsListStatus, gisStatus, gisLocation, details];
}
