part of 'commercial_license_details_bloc.dart';

class CommercialLicenseDetailsState extends Equatable {
  final BlocStatus status;
  final String ? error;
  final int? requestId;
  final RequestDetailsModel? requestDetails;

  const CommercialLicenseDetailsState({
    this.status = BlocStatus.initial,
    this.error,
    this.requestId,
    this.requestDetails,

  });

  @override
  List<Object?> get props => [
        status,
         error,
        requestId,
        requestDetails
      ];

  CommercialLicenseDetailsState copyWith(
      {
        BlocStatus? status,
        String? error,
      Nullable<int?>? requestId,
        RequestDetailsModel? requestDetails}) {
    return CommercialLicenseDetailsState(
        status: status ?? this.status,
        error: error ?? this.error,
        requestId: requestId == null ? this.requestId : requestId.value,
        requestDetails: requestDetails ?? this.requestDetails,
    );
  }


}
