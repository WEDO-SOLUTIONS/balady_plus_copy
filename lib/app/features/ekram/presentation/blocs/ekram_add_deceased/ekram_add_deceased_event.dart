part of 'ekram_add_deceased_bloc.dart';

abstract class EkramAddDeceasedEvent extends Equatable {
  const EkramAddDeceasedEvent();

  @override
  List<Object> get props => [];
}

class ChangeFullNameEvent extends EkramAddDeceasedEvent {
  final String? text;
  ChangeFullNameEvent({this.text});
}

class ChangeGenderEvent extends EkramAddDeceasedEvent {
  final LookUpItem? item;
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

class GetSpecialNeededReasons extends EkramAddDeceasedEvent {
  const GetSpecialNeededReasons();
}
