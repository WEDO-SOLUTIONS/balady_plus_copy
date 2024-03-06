part of 'construction_license_inquery_details_cubit.dart';



class ConstructionLicenseInqueryDetailsState extends Equatable {
  final BlocRequestStatus status;
  final ConstructionLicenseDataModel? commercialLicenceQueryDetails;
  //error message
  final String? errorMessage;


  const ConstructionLicenseInqueryDetailsState({
    this.status = BlocRequestStatus.initial,
    this.commercialLicenceQueryDetails,
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
      commercialLicenceQueryDetails: commercialLicenceDetails ?? this.commercialLicenceQueryDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    commercialLicenceQueryDetails,
    errorMessage,
  ];






}
