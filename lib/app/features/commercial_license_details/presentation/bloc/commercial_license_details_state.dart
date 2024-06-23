part of 'commercial_license_details_cubit.dart';

class CommercialLicenseDetailsState extends Equatable {
  final BlocRequestStatus status;
  final CommercialLicenceDetails? commercialLicenceDetails;
  //error message
  final String? errorMessage;

  const CommercialLicenseDetailsState({
    this.status = BlocRequestStatus.initial,
    this.commercialLicenceDetails,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  CommercialLicenseDetailsState copyWith({
    BlocRequestStatus? status,
    CommercialLicenceDetails? commercialLicenceDetails,
    String? errorMessage,
  }) {
    return CommercialLicenseDetailsState(
      status: status ?? this.status,
      commercialLicenceDetails:
          commercialLicenceDetails ?? this.commercialLicenceDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        commercialLicenceDetails,
        errorMessage,
      ];
}
