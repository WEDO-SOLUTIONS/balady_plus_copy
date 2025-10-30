part of 'map_bloc.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class GetZonesEvent extends MapEvent {
  final double lat;
  final double lon;

  const GetZonesEvent({required this.lat, required this.lon});
}

class GetGISDataEvent extends MapEvent {
  final double lat;
  final double lon;

  const GetGISDataEvent({required this.lat, required this.lon});
}

class ValidatePointEvent extends MapEvent {
  final double lat;
  final double lon;
  const ValidatePointEvent({required this.lat, required this.lon});
}

class ClearGISDataEvent extends MapEvent {
  const ClearGISDataEvent();
}

class GetLayersEvent extends MapEvent {
  final double southWestLongitude;
  final double southWestLlatitude;
  final double northEastLongitude;
  final double northEastLatitude;
  const GetLayersEvent(
      {required this.southWestLongitude,
      required this.southWestLlatitude,
      required this.northEastLongitude,
      required this.northEastLatitude});
}
