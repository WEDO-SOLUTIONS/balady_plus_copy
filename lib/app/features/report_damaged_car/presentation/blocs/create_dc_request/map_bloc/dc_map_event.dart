part of 'dc_map_bloc.dart';

abstract class DCMapEvent extends Equatable {
  const DCMapEvent();

  @override
  List<Object> get props => [];
}

class GetGISDataEvent extends DCMapEvent {
  GISParams params;
  bool popPage;
  bool refreshLocation;
  GetGISDataEvent(
      {required this.params,
      this.popPage = true,
      this.refreshLocation = false});
}

class InitMapEvent extends DCMapEvent {
  InitMapEvent();
}

class GetCurentUserLocationEvent extends DCMapEvent {
  GetCurentUserLocationEvent();
}

class SelectLocationEvent extends DCMapEvent {
  LatLng location;
  SelectLocationEvent({required this.location});
}
