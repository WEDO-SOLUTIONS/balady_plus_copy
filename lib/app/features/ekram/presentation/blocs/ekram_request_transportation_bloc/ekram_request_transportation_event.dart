part of 'ekram_request_transportation_bloc.dart';

abstract class EkramRequestTransportationEvent extends Equatable {
  const EkramRequestTransportationEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends EkramRequestTransportationEvent {
  const GoToNextPageEvent();
}

class GoToPreviousPageEvent extends EkramRequestTransportationEvent {
  const GoToPreviousPageEvent();
}

class SubmitRequestEvent extends EkramRequestTransportationEvent {
  const SubmitRequestEvent();
}

class ChangeNationalIdDob extends EkramRequestTransportationEvent {
  final String? gorgianDate;
  final String? hijriDate;
  const ChangeNationalIdDob({this.gorgianDate, this.hijriDate});
}

class ChangeBurialDateEvent extends EkramRequestTransportationEvent {
  final String? gorgianDate;
  final String? hijriDate;
  const ChangeBurialDateEvent({this.gorgianDate, this.hijriDate});
}

class ChangeDeathDateEvent extends EkramRequestTransportationEvent {
  final String? gorgianDate;
  final String? hijriDate;
  const ChangeDeathDateEvent({this.gorgianDate, this.hijriDate});
}

class ChangeCemetryTypeEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const ChangeCemetryTypeEvent({this.item});
}

class ChangeCountryEvent extends EkramRequestTransportationEvent {
  final LookUpItem item;
  const ChangeCountryEvent({required this.item});
}

class ChangeDeathCityEvent extends EkramRequestTransportationEvent {
  final LookUpItem item;
  const ChangeDeathCityEvent({required this.item});
}

class ChangebodyArrivalCitiesEvent extends EkramRequestTransportationEvent {
  final LookUpItem item;
  const ChangebodyArrivalCitiesEvent({required this.item});
}

class ChangeHospitalEvent extends EkramRequestTransportationEvent {
  final LookUpItem item;
  const ChangeHospitalEvent({required this.item});
}

class ChangeBurialCityEvent extends EkramRequestTransportationEvent {
  final LookUpItem item;
  const ChangeBurialCityEvent({required this.item});
}

class SelectNationalIdTypeEvent extends EkramRequestTransportationEvent {
  final LookUpItem item;
  const SelectNationalIdTypeEvent({required this.item});
}

class ChangeAgreementEvent extends EkramRequestTransportationEvent {
  final bool? isagree;
  const ChangeAgreementEvent({this.isagree});
}

class ChangeRelationShipEvent extends EkramRequestTransportationEvent {
  final String? text;
  const ChangeRelationShipEvent({this.text});
}

class ChangeDeathLocationEvent extends EkramRequestTransportationEvent {
  final String? text;
  const ChangeDeathLocationEvent({this.text});
}

class ChangeHospitalOtherNameEvent extends EkramRequestTransportationEvent {
  final String? text;
  const ChangeHospitalOtherNameEvent({this.text});
}

class SelectHospitalEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const SelectHospitalEvent({this.item});
}

class ApplyDeceasedTransportEvent extends EkramRequestTransportationEvent {
  const ApplyDeceasedTransportEvent();
}

class GetCitiesEvent extends EkramRequestTransportationEvent {
  const GetCitiesEvent();
}

class GetNationalitiesEvent extends EkramRequestTransportationEvent {
  const GetNationalitiesEvent();
}

class GetHospitalsEvent extends EkramRequestTransportationEvent {
  final LookUpItem city;
  const GetHospitalsEvent({required this.city});
}

class LoadInitialListsEvent extends EkramRequestTransportationEvent {
  const LoadInitialListsEvent();
}

class AddDeceasedEvent extends EkramRequestTransportationEvent {
  final dynamic data;
  const AddDeceasedEvent(this.data);
}

class DeleteDeceasedEvent extends EkramRequestTransportationEvent {
  final int index;
  const DeleteDeceasedEvent({required this.index});
}

class EditDeceasedEvent extends EkramRequestTransportationEvent {
  final dynamic data;
  final int index;

  const EditDeceasedEvent({required this.index, this.data});
}

class AddFileEvent extends EkramRequestTransportationEvent {
  final FileDataItem data;
  const AddFileEvent(this.data);
}

class VerifyDeceasedEvent extends EkramRequestTransportationEvent {
  final String? text;
  const VerifyDeceasedEvent({this.text});
}

class ChangeIdEvent extends EkramRequestTransportationEvent {
  final String? deceasedId;

  const ChangeIdEvent({required this.deceasedId});
}

class ChangeNationalityEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const ChangeNationalityEvent({this.item});
}
class ChangePrayerEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const ChangePrayerEvent({this.item});
}

class ChangeDeceasedUserInfoEvent extends EkramRequestTransportationEvent {
  final DeceasedInfo? item;
  const ChangeDeceasedUserInfoEvent({this.item});
}

class SetApplicantInfoEvent extends EkramRequestTransportationEvent {
  final String relation;
  SetApplicantInfoEvent({required this.relation});
}

class SubmitDeceasedInfoEvent extends EkramRequestTransportationEvent {
  const SubmitDeceasedInfoEvent();
}

class getRequestDetailsEvent extends EkramRequestTransportationEvent {
  final String requestId;
  const getRequestDetailsEvent({required this.requestId});
}
class saveDeceasedInfoEvent extends EkramRequestTransportationEvent {

  const saveDeceasedInfoEvent();
}
