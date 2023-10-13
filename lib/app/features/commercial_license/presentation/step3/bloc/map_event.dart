part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class GetGISDataEvent extends MapEvent {
  GISParams params;
  bool popPage;
  bool refreshLocation;
  GetGISDataEvent(
      {required this.params,
      this.popPage = true,
      this.refreshLocation = false});
}

class InitMapEvent extends MapEvent {
  InitMapEvent();
}

class GetCurentUserLocationEvent extends MapEvent {
  GetCurentUserLocationEvent();
}

class SelectLocationEvent extends MapEvent {
  LatLng location;
  SelectLocationEvent({required this.location});
}
