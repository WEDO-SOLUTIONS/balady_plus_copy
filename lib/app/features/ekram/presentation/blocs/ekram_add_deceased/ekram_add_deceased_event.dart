part of 'ekram_add_deceased_bloc.dart';

abstract class EkramAddDeceasedEvent extends Equatable {
  const EkramAddDeceasedEvent();

  @override
  List<Object> get props => [];
}

class ChangeGenderEvent extends EkramAddDeceasedEvent {
  final int? item;
  ChangeGenderEvent({this.item});
}

class ChangeReligionEvent extends EkramAddDeceasedEvent {
  final bool? item;
  ChangeReligionEvent({this.item});
}

class ChangeNationalityEvent extends EkramAddDeceasedEvent {
  final LookUpItem? item;
  ChangeNationalityEvent({this.item});
}

class ChangeBurialDestinationEvent extends EkramAddDeceasedEvent {
  final bool? sameCity;
  ChangeBurialDestinationEvent({this.sameCity});
}

class ChangeBurialDestinationCityEvent extends EkramAddDeceasedEvent {
  final LookUpItem? item;
  ChangeBurialDestinationCityEvent({this.item});
}

class ChangeIsNeedSpecialTransferEvent extends EkramAddDeceasedEvent {
  final bool? isNeeded;
  ChangeIsNeedSpecialTransferEvent({this.isNeeded});
}

class ChangeNeedSpecialTransferEvent extends EkramAddDeceasedEvent {
  final LookUpItem? item;
  ChangeNeedSpecialTransferEvent({this.item});
}

class ChangeNeedSpecialTransferReasonEvent extends EkramAddDeceasedEvent {
  final String? text;
  ChangeNeedSpecialTransferReasonEvent({this.text});
}

class ChangeNameEvent extends EkramAddDeceasedEvent {
  final String? firstName;
  final String? secondName;
  final String? thirdName;
  final String? fourthName;

  const ChangeNameEvent(
      {this.firstName, this.secondName, this.thirdName, this.fourthName});
}

class GetSpecialNeededReasons extends EkramAddDeceasedEvent {
  const GetSpecialNeededReasons();
}

class ChangeNationalId extends EkramAddDeceasedEvent {
  final String? text;
  ChangeNationalId({this.text});
}

class ChangeNationalIdDob extends EkramAddDeceasedEvent {
  final String? gorgianDate;
  final String? hijriDate;
  ChangeNationalIdDob({this.gorgianDate, this.hijriDate});
}

class ChangeNationalType extends EkramAddDeceasedEvent {
  final LookUpItem? item;
  ChangeNationalType({this.item});
}

class ChangeBurialCityEvent extends EkramAddDeceasedEvent {
  final LookUpItem? item;
  ChangeBurialCityEvent({this.item});
}

class ChangeCemetryTypeEvent extends EkramAddDeceasedEvent {
  final LookUpItem? item;
  ChangeCemetryTypeEvent({this.item});
}

class ChangeCemetryEvent extends EkramAddDeceasedEvent {
  final LookUpItem? item;
  ChangeCemetryEvent({this.item});
}

class ChangeBurialDateEvent extends EkramAddDeceasedEvent {
  final String? gorgianDate;
  final String? hijriDate;
  ChangeBurialDateEvent({this.gorgianDate, this.hijriDate});
}

class ChangeBurialTimevent extends EkramAddDeceasedEvent {
  final LookUpItem? item;
  ChangeBurialTimevent({this.item});
}

class ChangeBurialTimeOtherNameEvent extends EkramAddDeceasedEvent {
  ChangeBurialTimeOtherNameEvent();
}

class ChangeIsEpidamicEvent extends EkramAddDeceasedEvent {
  final bool? value;
  ChangeIsEpidamicEvent({this.value});
}

class GetNationalTypes extends EkramAddDeceasedEvent {
  const GetNationalTypes();
}

class CheckUserInfoEvent extends EkramAddDeceasedEvent {
  const CheckUserInfoEvent();
}

class ChangeHospitalOtherNameEvent extends EkramAddDeceasedEvent {
  final String? text;
  ChangeHospitalOtherNameEvent({this.text});
}

class GetNationalitiesEvent extends EkramAddDeceasedEvent {
  const GetNationalitiesEvent();
}

class GetNationalityEvent extends EkramAddDeceasedEvent {
  final LookUpItem item;
  const GetNationalityEvent({required this.item});
}

class ChangePermitNumberEvent extends EkramAddDeceasedEvent {
  final String? text;
  ChangePermitNumberEvent({this.text});
}

class SelectOrgnizationEvent extends EkramAddDeceasedEvent {
  final LookUpItem? item;
  SelectOrgnizationEvent({this.item});
}

class GetBaquieApprovalEvent extends EkramAddDeceasedEvent {
  GetBaquieApprovalEvent();
}
