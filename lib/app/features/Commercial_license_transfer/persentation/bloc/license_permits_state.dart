part of 'license_permits_cubit.dart';



class LicensePermitsState extends Equatable {
  final BlocRequestStatus status;
  final PermitsResponseDataModel? licencePermitsResponse;
  final String? errorMessage;



  const LicensePermitsState({
    this.status = BlocRequestStatus.initial,
    this.licencePermitsResponse,
    this.errorMessage,


  });

  String get error => errorMessage ?? '';

  LicensePermitsState copyWith({
    BlocRequestStatus? status,
    PermitsResponseDataModel? permits,
    String? errorMessage,
  }) {
    return LicensePermitsState(
      status: status ?? this.status,
      licencePermitsResponse: permits ?? this.licencePermitsResponse,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    licencePermitsResponse,
    errorMessage,
  ];






}
