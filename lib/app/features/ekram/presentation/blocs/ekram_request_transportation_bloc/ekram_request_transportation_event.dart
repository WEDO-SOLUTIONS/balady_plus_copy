part of 'ekram_request_transportation_bloc.dart';

abstract class EkramRequestTransportationEvent extends Equatable {
  const EkramRequestTransportationEvent();

  @override
  List<Object> get props => [];
}

class GoToNextPageEvent extends EkramRequestTransportationEvent {
  GoToNextPageEvent();
}

class GoToPreviousPageEvent extends EkramRequestTransportationEvent {
  GoToPreviousPageEvent();
}

class SubmitRequestEvent extends EkramRequestTransportationEvent {
  SubmitRequestEvent();
}

class ChangeAgreementEvent extends EkramRequestTransportationEvent {
  final bool? isagree;
  ChangeAgreementEvent({this.isagree});
}

class ChangeRelationShipEvent extends EkramRequestTransportationEvent {
  final String? text;
  ChangeRelationShipEvent({this.text});
}

class ChangeDeathLocationEvent extends EkramRequestTransportationEvent {
  final String? text;
  ChangeDeathLocationEvent({this.text});
}

class ChangeHospitalOtherNameEvent extends EkramRequestTransportationEvent {
  final String? text;
  ChangeHospitalOtherNameEvent({this.text});
}

class SelectHospitalEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  SelectHospitalEvent({this.item});
}

class ApplyDeceasedTransportEvent extends EkramRequestTransportationEvent {
  ApplyDeceasedTransportEvent();
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
