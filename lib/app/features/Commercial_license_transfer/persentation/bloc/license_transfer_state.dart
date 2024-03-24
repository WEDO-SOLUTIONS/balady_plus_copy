part of 'license_tranfer_cubit.dart';



class LicenseTransferState extends Equatable {
  final BlocRequestStatus status;
  final PermitsResponseDataModel? licencePermitsResponse;
  final ValidateOwnerDataModel? validateOwnerDataModel;
  final String? errorMessage;



  const LicenseTransferState({
    this.status = BlocRequestStatus.initial,
    this.licencePermitsResponse,
    this.validateOwnerDataModel,
    this.errorMessage,


  });

  String get error => errorMessage ?? '';

  LicenseTransferState copyWith({
    BlocRequestStatus? status,
    PermitsResponseDataModel? permits,
    ValidateOwnerDataModel? validateOwner,
    String? errorMessage,
  }) {
    if(permits != null) {
      return LicenseTransferState(
        status: status ?? this.status,
        licencePermitsResponse: permits ,
        errorMessage: errorMessage ?? this.errorMessage,
      );
    }
    else
      {
        return LicenseTransferState(
          status: status ?? this.status,
          validateOwnerDataModel: validateOwner ,
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
