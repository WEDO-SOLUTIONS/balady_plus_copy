part of 'permit_24_bloc.dart';

@immutable
abstract class Permit24LicenseEvent extends Equatable {
  const Permit24LicenseEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends Permit24LicenseEvent {
  const GoToNextPageEvent();
}

class GoToPreviousPageEvent extends Permit24LicenseEvent {
  const GoToPreviousPageEvent();
}

class GetPermitAlertsEvent extends Permit24LicenseEvent {
  const GetPermitAlertsEvent();
}

class GetPermitEndorsmentsEvent extends Permit24LicenseEvent {
  const GetPermitEndorsmentsEvent();
}

class DeletePermitRequestEvent extends Permit24LicenseEvent {
  const DeletePermitRequestEvent();
}

class SubmitPermitEvent extends Permit24LicenseEvent {
  const SubmitPermitEvent();
}

class ValidatePermitEvent extends Permit24LicenseEvent {
  const ValidatePermitEvent();
}

class GetPermitRequestDetailsEvent extends Permit24LicenseEvent {
  const GetPermitRequestDetailsEvent();
}

class CalculatePermitCostEvent extends Permit24LicenseEvent {
  const CalculatePermitCostEvent();
}

class ToggleAgreementEvent extends Permit24LicenseEvent {
  final bool? agreement;
  const ToggleAgreementEvent({this.agreement});
}
