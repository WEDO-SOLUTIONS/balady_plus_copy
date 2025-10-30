part of 'construction_license_inquery_details_cubit.dart';

class ConstructionLicenseInqueryDetailsState extends Equatable {
  final BlocRequestStatus status;
  final ConstructionLicenseDataModel? licenceQueryDetails;
  //error message
  final String? errorMessage;

  const ConstructionLicenseInqueryDetailsState({
    this.status = BlocRequestStatus.initial,
    this.licenceQueryDetails,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  ConstructionLicenseInqueryDetailsState copyWith({
    BlocRequestStatus? status,
    ConstructionLicenseDataModel? commercialLicenceDetails,
    String? errorMessage,
  }) {
    return ConstructionLicenseInqueryDetailsState(
      status: status ?? this.status,
      licenceQueryDetails: commercialLicenceDetails ?? this.licenceQueryDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        licenceQueryDetails,
        errorMessage,
      ];
}
