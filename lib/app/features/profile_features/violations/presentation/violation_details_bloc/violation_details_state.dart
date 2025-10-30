part of 'violation_details_bloc.dart';

class ViolationDetailsState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final ViolationDetailsEntity? details;
  final GISResponse? gisLocation;
  final BlocStatus gisStatus;
  final BlocStatus objectionsListStatus;
  final ViolationsEntity? violationsEntity;


  const ViolationDetailsState(
      {this.status = BlocStatus.initial,
      this.gisStatus = BlocStatus.initial,
      this.objectionsListStatus = BlocStatus.initial,
      this.errorMessage,
      this.gisLocation,
      this.details,
      this.violationsEntity,
     });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        details,
        gisLocation,
        gisStatus,
        objectionsListStatus,
        violationsEntity,

      ];

  ViolationDetailsState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      ViolationDetailsEntity? details,
      GISResponse? gisLocation,
      BlocStatus? gisStatus,
      BlocStatus? objectionsListStatus,
      ViolationsEntity? violationsEntity,
        RequestDetailsModel? commercialRequestDetails}) {
    return ViolationDetailsState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        details: details ?? this.details,
        gisLocation: gisLocation ?? this.gisLocation,
        gisStatus: gisStatus ?? this.gisStatus,
        objectionsListStatus: objectionsListStatus ?? this.objectionsListStatus,
        violationsEntity: violationsEntity ?? this.violationsEntity,


    );
  }
}
