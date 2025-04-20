part of 'commercial_license_initial_Approval_bloc.dart';

@immutable
abstract class CommercialLicenseInitialApprovalEvent extends Equatable {
  const CommercialLicenseInitialApprovalEvent();

  @override
  List<Object> get props => [];
}

class NextPageEvent extends CommercialLicenseInitialApprovalEvent {
  const NextPageEvent();
}

class PreviousPageEvent extends CommercialLicenseInitialApprovalEvent {
  const PreviousPageEvent();
}

class UpdateFieldEvent extends CommercialLicenseInitialApprovalEvent {
  final int requestId;
  final SaveLocationResponse? saveLocationResponse;
  const UpdateFieldEvent(
      {required this.requestId, this.saveLocationResponse});
}

class UpdateQrCodeDataEvent extends CommercialLicenseInitialApprovalEvent {
  final SubmitCommercialResponseModel data;
  const UpdateQrCodeDataEvent({required this.data});
}
