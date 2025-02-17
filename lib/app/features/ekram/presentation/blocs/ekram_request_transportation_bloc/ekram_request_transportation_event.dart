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
class setInitialDataEvent extends EkramRequestTransportationEvent {
  final RequestDetailsResponseModel? dataModel;
  const setInitialDataEvent({this.dataModel});
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

class ChangeDeathInfoEvent extends EkramRequestTransportationEvent {
  final DeathInfo? deathInfo ;

  const ChangeDeathInfoEvent({required this.deathInfo});
}

class ResetActionEvent extends EkramRequestTransportationEvent {
  final ResetActionEnum action ;

  const ResetActionEvent({required this.action});
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
  final int? cityId;
  const GetHospitalsEvent({required this.cityId});
}

class GetMadinahEmirateApprovalStatusEvent extends EkramRequestTransportationEvent {
final int? cemetryId ;
final String? id ;
final int? idType ;
 const GetMadinahEmirateApprovalStatusEvent({required this.cemetryId, required this.id , required this.idType});
}

class GetCemetriesEvent extends EkramRequestTransportationEvent {
  final CemetriesParams params;
  final int requestId;
  const GetCemetriesEvent({required this.params, required this.requestId});
}

class ekramTransportValidateSubmitEvent extends EkramRequestTransportationEvent {
  final EkramTransportValidateSubmitParams params;
  final int requestId;
  const ekramTransportValidateSubmitEvent({required this.params, required this.requestId});
}

class GetTransportationNamesEvent extends EkramRequestTransportationEvent {
  final TransportationCompaniesParams params;
  final int requestId;
  const GetTransportationNamesEvent(
      {required this.params, required this.requestId});
}

class GetLandriesEvent extends EkramRequestTransportationEvent {
  final MosqueGhuslPlacesParams params;
  final int? transportId;
  final List<int?>? cityIds;
  const GetLandriesEvent(
      {required this.params,required this.cityIds, required this.transportId});
}

class GetMosquesEvent extends EkramRequestTransportationEvent {
  final MosqueGhuslPlacesParams ghuslplace;
  final int? transportId;
  final List<int?>? cityIds;
    const GetMosquesEvent({required this.ghuslplace, required this.transportId , required this.cityIds});
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
  final VerifyDeceasedParams? params;
  final bool fromDeepLink;

  const VerifyDeceasedEvent({
    this.params,
    this.fromDeepLink = false,
  });
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

class ChangeCemetryTypeItemsEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const ChangeCemetryTypeItemsEvent({this.item});
}

class ChangeCemetryItemsEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const ChangeCemetryItemsEvent({this.item});
}

class ChangeTransportationNameEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const ChangeTransportationNameEvent({this.item});
}

class ChangeLandriesEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const ChangeLandriesEvent({this.item});
}

class ChangeIsNeedSpecialTransferEvent extends EkramRequestTransportationEvent {
  final bool? isNeeded;
  const ChangeIsNeedSpecialTransferEvent({this.isNeeded});
}

// class ChangeIsBurialInsideDeathCityEvent extends EkramRequestTransportationEvent {
//   final bool? isBurialInsideDeathCity;
//
//   const ChangeIsBurialInsideDeathCityEvent({this.isBurialInsideDeathCity});
// }
class setBurialInfoEvent extends EkramRequestTransportationEvent {
  final BurialInfo? burialInfo;
  setBurialInfoEvent({this.burialInfo});
}
class setTransportInfoEvent extends EkramRequestTransportationEvent {
  final TransportInfo? transportInfo;

  setTransportInfoEvent({this.transportInfo});
}
class setCemtryInfoEvent extends EkramRequestTransportationEvent {
  final CemeteryData? cemeteryData;
  bool?maghsalaExist;
  setCemtryInfoEvent({this.cemeteryData,this.maghsalaExist});
}

class ChangeMosqueEvent extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const ChangeMosqueEvent({this.item});
}

class ChangeSpecialTransportReasonsEvent
    extends EkramRequestTransportationEvent {
  final LookUpItem? item;
  const ChangeSpecialTransportReasonsEvent({this.item});
}

class ChangeDeceasedUserInfoEvent extends EkramRequestTransportationEvent {
  final DeceasedInfo? item;
  const ChangeDeceasedUserInfoEvent({this.item});
}

class SetApplicantInfoEvent extends EkramRequestTransportationEvent {
  final String relation;
  const SetApplicantInfoEvent({required this.relation});
}

class SubmitDeceasedInfoEvent extends EkramRequestTransportationEvent {
  const SubmitDeceasedInfoEvent();
}

class getRequestDetailsEvent extends EkramRequestTransportationEvent {
  final int requestId;
  const getRequestDetailsEvent({required this.requestId});
}
class getCurrentTrackLocationEvent extends EkramRequestTransportationEvent {
  final int requestId;
  const getCurrentTrackLocationEvent({required this.requestId});
}

class saveDeceasedInfoEvent extends EkramRequestTransportationEvent {
  final bool? isDarft;

  const saveDeceasedInfoEvent({this.isDarft});
}

class saveBurianDeathInfoEvent extends EkramRequestTransportationEvent {
  final bool? isDarft;
  const saveBurianDeathInfoEvent({this.isDarft});
}


