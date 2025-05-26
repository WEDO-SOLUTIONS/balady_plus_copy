part of 'add_trip_bloc.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object> get props => [];
}



class SubmitEvent extends TripEvent {
  const SubmitEvent();
}

class UpdateDriverLocationEvent extends TripEvent {
  const UpdateDriverLocationEvent();
}

class ClearErrorMsgEvent extends TripEvent {
  const ClearErrorMsgEvent();
}

class GetTripsEvent extends TripEvent {

  const GetTripsEvent();
}

class GetTripsStationEvent extends TripEvent {

  const GetTripsStationEvent();
}

class AddCustomPathEvent extends TripEvent {
  const AddCustomPathEvent();
}



class setCustomPathDataEvent extends TripEvent {
  final TripStations? item;
  final bool isStartupInfo;
  setCustomPathDataEvent({this.item,required this.isStartupInfo});
}
class EditTripPathData extends TripEvent {
  final TripDetailsModel? item;
  final bool? hidenScreen;
  EditTripPathData({this.item, required this.hidenScreen});
}
class DeleteTripPath extends TripEvent {
  final int? tripId;
  DeleteTripPath({this.tripId});
}
