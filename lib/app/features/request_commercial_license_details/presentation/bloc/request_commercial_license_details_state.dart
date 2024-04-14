part of 'request_commercial_license_details_cubit.dart';

class RequestCommercialLicenseDetailsState extends Equatable {
  final BlocRequestStatus status;
  final RequestCommercialLicenseDetailsModel? requestCommercialLicenseDetails;
  //error message
  final String? errorMessage;

  const RequestCommercialLicenseDetailsState({
    this.status = BlocRequestStatus.initial,
    this.requestCommercialLicenseDetails,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  RequestCommercialLicenseDetailsState copyWith({
    BlocRequestStatus? status,
    RequestCommercialLicenseDetailsModel? commercialLicenceDetails,
    String? errorMessage,
  }) {
    return RequestCommercialLicenseDetailsState(
      status: status ?? this.status,
      requestCommercialLicenseDetails:
          commercialLicenceDetails ?? this.requestCommercialLicenseDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        requestCommercialLicenseDetails,
        errorMessage,
      ];
}
