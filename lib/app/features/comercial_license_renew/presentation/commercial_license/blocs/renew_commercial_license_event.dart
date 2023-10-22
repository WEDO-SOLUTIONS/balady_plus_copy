part of 'commercial_license_bloc.dart';

@immutable
abstract class RenewCommercialLicenseEvent extends Equatable {
  const RenewCommercialLicenseEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends RenewCommercialLicenseEvent {
  const GoToNextPageEvent();
}

class GoToPreviousPageEvent extends RenewCommercialLicenseEvent {
  const GoToPreviousPageEvent();
}
