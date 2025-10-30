part of 'ekram_add_trip_bloc.dart';

abstract class EkramAddTripEvent extends Equatable {
  const EkramAddTripEvent();

  @override
  List<Object> get props => [];
}

class ChangeNextTripStationType extends EkramAddTripEvent {
  final LookUpItem? item;
  ChangeNextTripStationType({this.item});
}

class ChangeNextTripHospitalStation extends EkramAddTripEvent {
  final LookUpItem? item;
  ChangeNextTripHospitalStation({this.item});
}

class ChangeNextTripMosuqeStation extends EkramAddTripEvent {
  final LookUpItem? item;
  ChangeNextTripMosuqeStation({this.item});
}

class ChangeNextTripLaundryStation extends EkramAddTripEvent {
  final LookUpItem? item;
  ChangeNextTripLaundryStation({this.item});
}

class ChangeNextTripStationName extends EkramAddTripEvent {
  final String? text;
  ChangeNextTripStationName({this.text});
}

class ChangeArrivalTimeEvent extends EkramAddTripEvent {
  final String? time;
  ChangeArrivalTimeEvent({this.time});
}

class SubmitEvent extends EkramAddTripEvent {
  const SubmitEvent();
}

class UpdateDriverLocationEvent extends EkramAddTripEvent {
  const UpdateDriverLocationEvent();
}

class ClearErrorMsgEvent extends EkramAddTripEvent {
  const ClearErrorMsgEvent();
}
