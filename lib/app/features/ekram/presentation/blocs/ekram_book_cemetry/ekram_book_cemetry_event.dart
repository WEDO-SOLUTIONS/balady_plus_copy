part of 'ekram_book_cemetry_bloc.dart';

abstract class EkramBookCemetryEvent extends Equatable {
  const EkramBookCemetryEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends EkramBookCemetryEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends EkramBookCemetryEvent {
  GoToPreviousPageEvent();
}

class SubmitRequestEvent extends EkramBookCemetryEvent {
  SubmitRequestEvent();
}

class ChangeAgreementEvent extends EkramBookCemetryEvent {
  final bool? isagree;
  ChangeAgreementEvent({this.isagree});
}

class ChangeRelationShipEvent extends EkramBookCemetryEvent {
  final String? text;
  ChangeRelationShipEvent({this.text});
}

class ChangeNationalId extends EkramBookCemetryEvent {
  final String? text;
  ChangeNationalId({this.text});
}

class ChangeNationalIdDob extends EkramBookCemetryEvent {
  final String? gorgianDate;
  final String? hijriDate;
  ChangeNationalIdDob({this.gorgianDate, this.hijriDate});
}

class ChangeNationalType extends EkramBookCemetryEvent {
  final LookUpItem? item;
  ChangeNationalType({this.item});
}

class ChangeBurialCityEvent extends EkramBookCemetryEvent {
  final LookUpItem? item;
  ChangeBurialCityEvent({this.item});
}

class ChangeCemetryTypeEvent extends EkramBookCemetryEvent {
  final LookUpItem? item;
  ChangeCemetryTypeEvent({this.item});
}

class ChangeCemetryEvent extends EkramBookCemetryEvent {
  final LookUpItem? item;
  ChangeCemetryEvent({this.item});
}

class ChangeBurialDateEvent extends EkramBookCemetryEvent {
  final String? gorgianDate;
  final String? hijriDate;
  ChangeBurialDateEvent({this.gorgianDate, this.hijriDate});
}

class ChangeBurialTimevent extends EkramBookCemetryEvent {
  final LookUpItem? item;
  ChangeBurialTimevent({this.item});
}

class ChangeBurialTimeOtherNameEvent extends EkramBookCemetryEvent {
  ChangeBurialTimeOtherNameEvent();
}

class ChangeIsEpidamicEvent extends EkramBookCemetryEvent {
  final bool? value;
  ChangeIsEpidamicEvent({this.value});
}

class ChangeReligionEvent extends EkramBookCemetryEvent {
  final bool? value;
  ChangeReligionEvent({this.value});
}

class GetNationalTypes extends EkramBookCemetryEvent {
  const GetNationalTypes();
}

class CheckUserInfoEvent extends EkramBookCemetryEvent {
  const CheckUserInfoEvent();
}

class ChangeHospitalOtherNameEvent extends EkramBookCemetryEvent {
  final String? text;
  ChangeHospitalOtherNameEvent({this.text});
}

class SelectHospitalEvent extends EkramBookCemetryEvent {
  final LookUpItem? item;
  SelectHospitalEvent({this.item});
}

class ApplyDeceasedTransportEvent extends EkramBookCemetryEvent {
  ApplyDeceasedTransportEvent();
}

class GetCitiesEvent extends EkramBookCemetryEvent {
  const GetCitiesEvent();
}

class GetNationalitiesEvent extends EkramBookCemetryEvent {
  const GetNationalitiesEvent();
}

class GetHospitalsEvent extends EkramBookCemetryEvent {
  final LookUpItem city;
  const GetHospitalsEvent({required this.city});
}

class AddDeceasedEvent extends EkramBookCemetryEvent {
  final dynamic data;
  const AddDeceasedEvent(this.data);
}

class ChangeIsFetus extends EkramBookCemetryEvent {
  final bool? value;
  ChangeIsFetus({this.value});
}

class ChangeGenderEvent extends EkramBookCemetryEvent {
  final String? value;
  ChangeGenderEvent({this.value});
}

class ChangeNameEvent extends EkramBookCemetryEvent {
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? fourthName;

  const ChangeNameEvent(
      {this.firstName, this.secondName, this.thirdName, this.fourthName});
}

class GetNationalityEvent extends EkramBookCemetryEvent {
  final LookUpItem item;
  const GetNationalityEvent({required this.item});
}

class ChangeCountryEvent extends EkramBookCemetryEvent {
  final LookUpItem item;
  const ChangeCountryEvent({required this.item});
}

class ChangeDeathCityEvent extends EkramBookCemetryEvent {
  final LookUpItem item;
  const ChangeDeathCityEvent({required this.item});
}

class ChangeOtherCityEvent extends EkramBookCemetryEvent {
  final String? text;
  const ChangeOtherCityEvent({required this.text});
}
