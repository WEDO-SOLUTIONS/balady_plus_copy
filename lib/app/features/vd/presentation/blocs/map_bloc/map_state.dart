part of 'map_bloc.dart';

class MapState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final GISResponse? gisResponse;
  final GISParams? location;
  final GISParams? userLocation;
  final bool? isLocationAllowed;
  MapState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.gisResponse,
      this.location,
      this.userLocation,
      this.isLocationAllowed = true});

  MapState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final GISResponse? gisResponse,
      final GISParams? location,
      final GISParams? userLocation,
      final bool? isLocationAllowed}) {
    return MapState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        gisResponse: gisResponse ?? this.gisResponse,
        location: location ?? this.location,
        userLocation: userLocation ?? this.userLocation,
        isLocationAllowed: isLocationAllowed ?? this.isLocationAllowed);
  }

  @override
  List<Object?> get props =>
      [status, location, userLocation, gisResponse, isLocationAllowed];
}
