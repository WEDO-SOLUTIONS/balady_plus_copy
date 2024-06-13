part of 'request_ownership_transfer_details_cubit.dart';

class RequestOwnershipTransferDetailsState extends Equatable {
  final BlocRequestStatus status;
  final CommercialLicenceDetails? commercialLicenceDetails;
  //error message
  final String? errorMessage;

  const RequestOwnershipTransferDetailsState({
    this.status = BlocRequestStatus.initial,
    this.commercialLicenceDetails,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  RequestOwnershipTransferDetailsState copyWith({
    BlocRequestStatus? status,
    CommercialLicenceDetails? commercialLicenceDetails,
    String? errorMessage,
  }) {
    return RequestOwnershipTransferDetailsState(
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

// final class LoadingAcceptOrRejectOwnershipTransferState
//     extends RequestOwnershipTransferDetailsState {
//   @override
//   List<Object?> get props => throw UnimplementedError();
// }
//
// final class SucceedAcceptOrRejectOwnershipTransferState
//     extends RequestOwnershipTransferDetailsState {
//   const SucceedAcceptOrRejectOwnershipTransferState();
//
//   @override
//   List<Object?> get props => [];
// }
