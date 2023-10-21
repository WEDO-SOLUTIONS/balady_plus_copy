part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class GetGISDataEvent extends MapEvent {
  final GISParams params;
  final bool popPage;
  final bool refreshLocation;
  const GetGISDataEvent(
      {required this.params,
      this.popPage = true,
      this.refreshLocation = false});
}

class InitMapEvent extends MapEvent {
  const InitMapEvent();
}

class GetCurentUserLocationEvent extends MapEvent {
  const GetCurentUserLocationEvent();
}

class SelectLocationEvent extends MapEvent {
  final LatLng location;
  const SelectLocationEvent({required this.location});
}

class SaveLocationDataEvent extends MapEvent {
  const SaveLocationDataEvent();
}
