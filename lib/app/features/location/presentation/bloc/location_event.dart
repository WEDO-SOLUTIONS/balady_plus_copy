part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class GetRequestsEvent extends LocationEvent {}

class GettingLocationPermissionEvent extends LocationEvent {
  const GettingLocationPermissionEvent();
}

class GettingLocationDataEvent extends LocationEvent {
  const GettingLocationDataEvent();
}
