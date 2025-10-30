part of 'license_tranfer_cubit.dart';

class LicenseTransferState extends Equatable {
  final BlocRequestStatus status;
  final PermitsResponseDataModel? licencePermitsResponse;
  final ValidateOwnerDataModel? validateOwnerDataModel;
  final ValidateLicenseDataModel? validateLicenseDataModel;
  final ApplyRequestDataModel? applyRequestDataModel;

  final String? errorMessage;

  const LicenseTransferState({
    this.status = BlocRequestStatus.initial,
    this.licencePermitsResponse,
    this.validateOwnerDataModel,
    this.validateLicenseDataModel,
    this.applyRequestDataModel,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  LicenseTransferState copyWith({
    BlocRequestStatus? status,
    PermitsResponseDataModel? permits,
    ValidateOwnerDataModel? validateOwner,
    ValidateLicenseDataModel? validateLicense,
    ApplyRequestDataModel? applyDataModel,
    String? errorMessage,
  }) {
    if (permits != null) {
      return LicenseTransferState(
        status: status ?? this.status,
        licencePermitsResponse: permits,
        errorMessage: errorMessage ?? this.errorMessage,
      );
    } else if (validateLicense != null) {
      return LicenseTransferState(
        status: status ?? this.status,
        validateLicenseDataModel: validateLicense,
        errorMessage: errorMessage ?? this.errorMessage,
      );
    } else if (applyDataModel != null) {
      return LicenseTransferState(
        status: status ?? this.status,
        applyRequestDataModel: applyDataModel,
        errorMessage: errorMessage ?? this.errorMessage,
      );
    } else {
      return LicenseTransferState(
        status: status ?? this.status,
        validateOwnerDataModel: validateOwner,
        errorMessage: errorMessage ?? this.errorMessage,
      );
    }
  }

  @override
  List<Object?> get props => [
        status,
        licencePermitsResponse,
        errorMessage,
      ];
}
