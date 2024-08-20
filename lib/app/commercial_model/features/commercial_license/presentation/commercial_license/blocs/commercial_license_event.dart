part of 'commercial_license_bloc.dart';

@immutable
abstract class CommercialLicenseEvent extends Equatable {
  const CommercialLicenseEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends CommercialLicenseEvent {
  const GoToNextPageEvent();
}

class GoToPreviousPageEvent extends CommercialLicenseEvent {
  const GoToPreviousPageEvent();
}

class UpdateRequestFieldEvent extends CommercialLicenseEvent {
  final int requestId;
  final SaveLocationResponse? saveLocationResponse;
  const UpdateRequestFieldEvent(
      {required this.requestId, this.saveLocationResponse});
}

class UpdateQrDataEvent extends CommercialLicenseEvent {
  final ApplyCommercialResponseModel data;
  const UpdateQrDataEvent({required this.data});
}
