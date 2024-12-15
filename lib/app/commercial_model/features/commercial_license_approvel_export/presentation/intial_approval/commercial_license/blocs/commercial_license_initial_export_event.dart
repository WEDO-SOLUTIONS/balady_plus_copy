part of 'commercial_license_initial_export_bloc.dart';

@immutable
abstract class CommercialLicenseInitialExportEvent extends Equatable {
  const CommercialLicenseInitialExportEvent();

  @override
  List<Object> get props => [];
}

class NextPageEvent extends CommercialLicenseInitialExportEvent {
  const NextPageEvent();
}

class PreviousPageEvent extends CommercialLicenseInitialExportEvent {
  const PreviousPageEvent();
}

class UpdateFieldEvent extends CommercialLicenseInitialExportEvent {
  final int requestId;
  final SaveLocationResponse? saveLocationResponse;
  const UpdateFieldEvent(
      {required this.requestId, this.saveLocationResponse});
}

class UpdateQrCodeDataEvent extends CommercialLicenseInitialExportEvent {
  final SubmitCommercialResponseModel data;
  const UpdateQrCodeDataEvent({required this.data});
}
