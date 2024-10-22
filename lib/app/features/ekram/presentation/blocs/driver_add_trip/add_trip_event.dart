part of 'add_trip_bloc.dart';

abstract class AddTripEvent extends Equatable {
  const AddTripEvent();

  @override
  List<Object> get props => [];
}






class ChangeArrivalTimeEvent extends AddTripEvent {
  final String? time;
  ChangeArrivalTimeEvent({this.time});
}

class SubmitEvent extends AddTripEvent {
  const SubmitEvent();
}

class UpdateDriverLocationEvent extends AddTripEvent {
  const UpdateDriverLocationEvent();
}

class ClearErrorMsgEvent extends AddTripEvent {
  const ClearErrorMsgEvent();
}

class GetTripsEvent extends AddTripEvent {

  const GetTripsEvent();
}

class GetTripsStationEvent extends AddTripEvent {

  const GetTripsStationEvent();
}

class updateCurrentTripStation extends AddTripEvent {
  final TripStations? item;
  updateCurrentTripStation({this.item});
}
