part of 'commercial_license_export_bloc.dart';

@immutable
abstract class CommercialLicenseExportEvent extends Equatable {
  const CommercialLicenseExportEvent();

  @override
  List<Object> get props => [];
}

class NextPageEvent extends CommercialLicenseExportEvent {
  const NextPageEvent();
}

class PreviousPageEvent extends CommercialLicenseExportEvent {
  const PreviousPageEvent();
}

class UpdateFieldEvent extends CommercialLicenseExportEvent {
  final int requestId;
  final SaveLocationResponse? saveLocationResponse;
  const UpdateFieldEvent(
      {required this.requestId, this.saveLocationResponse});
}

class UpdateQrCodeDataEvent extends CommercialLicenseExportEvent {
  final SubmitCommercialResponseModel data;
  const UpdateQrCodeDataEvent({required this.data});
}
