part of 'permit_tobacco_bloc.dart';

@immutable
abstract class PermitTobaccoLicenseEvent extends Equatable {
  const PermitTobaccoLicenseEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends PermitTobaccoLicenseEvent {
  const GoToNextPageEvent();
}

class GoToPreviousPageEvent extends PermitTobaccoLicenseEvent {
  const GoToPreviousPageEvent();
}

class GetPermitAlertsEvent extends PermitTobaccoLicenseEvent {
  const GetPermitAlertsEvent();
}

class DeletePermitRequestEvent extends PermitTobaccoLicenseEvent {
  const DeletePermitRequestEvent();
}

class SubmitPermitEvent extends PermitTobaccoLicenseEvent {
  const SubmitPermitEvent();
}

class ValidatePermitEvent extends PermitTobaccoLicenseEvent {
  const ValidatePermitEvent();
}

class GetPermitRequestDetailsEvent extends PermitTobaccoLicenseEvent {
  const GetPermitRequestDetailsEvent();
}

class CalculatePermitCostEvent extends PermitTobaccoLicenseEvent {
  const CalculatePermitCostEvent();
}

class ValidateTobaccoHotelEvent extends PermitTobaccoLicenseEvent {
  const ValidateTobaccoHotelEvent();
}

class ToggleAgreementEvent extends PermitTobaccoLicenseEvent {
  final bool? agreement;
  const ToggleAgreementEvent({this.agreement});
}

class ChangeIsIndieHotelEvent extends PermitTobaccoLicenseEvent {
  final bool? value;
  const ChangeIsIndieHotelEvent({this.value});
}

class ChangeHotelLicenseNumber extends PermitTobaccoLicenseEvent {
  final String? value;
  const ChangeHotelLicenseNumber({this.value});
}
