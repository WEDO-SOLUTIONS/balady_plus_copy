part of 'renew_commercial_license_bloc.dart';

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

class GetRenewYearsEvent extends RenewCommercialLicenseEvent {
  const GetRenewYearsEvent();
}

class GetRequestInfoEvent extends RenewCommercialLicenseEvent {
  final String? year;
  const GetRequestInfoEvent({this.year});
}

class UpdateRenewYearsEvent extends RenewCommercialLicenseEvent {
  final String year;
  const UpdateRenewYearsEvent({required this.year});
}

class ChangeInsidePetrolStationEvent extends RenewCommercialLicenseEvent {
  final bool value;
  const ChangeInsidePetrolStationEvent({required this.value});
}
