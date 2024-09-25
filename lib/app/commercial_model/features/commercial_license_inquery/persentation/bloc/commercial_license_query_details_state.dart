part of 'commercial_license_query_details_cubit.dart';

class CommercialLicenseQueryDetailsState extends Equatable {
  final BlocRequestStatus status;
  final CommercialLicenseDataModel? commercialLicenceQueryDetails;
  //error message
  final String? errorMessage;

  const CommercialLicenseQueryDetailsState({
    this.status = BlocRequestStatus.initial,
    this.commercialLicenceQueryDetails,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  CommercialLicenseQueryDetailsState copyWith({
    BlocRequestStatus? status,
    CommercialLicenseDataModel? commercialLicenceDetails,
    String? errorMessage,
  }) {
    return CommercialLicenseQueryDetailsState(
      status: status ?? this.status,
      commercialLicenceQueryDetails:
          commercialLicenceDetails ?? this.commercialLicenceQueryDetails,
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
