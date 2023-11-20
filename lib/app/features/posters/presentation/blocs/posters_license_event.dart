part of 'posters_license_bloc.dart';

@immutable
abstract class PostersLicenseEvent extends Equatable {
  const PostersLicenseEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends PostersLicenseEvent {
  const GoToNextPageEvent();
}

class GoToPreviousPageEvent extends PostersLicenseEvent {
  const GoToPreviousPageEvent();
}

class GetLicensePermitsEvents extends PostersLicenseEvent {
  const GetLicensePermitsEvents();
}

class ChangePermitStartDate extends PostersLicenseEvent {
  final String? date; 
  const ChangePermitStartDate({this.date});
}

class ChangePermitDurationEvent extends PostersLicenseEvent {
  final String? value; 
  const ChangePermitDurationEvent({this.value});
}
