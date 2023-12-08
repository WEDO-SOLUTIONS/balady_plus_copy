part of 'dc_map_bloc.dart';

class DCMapState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final GISResponse? gisResponse;
  final GISParams? location;
  final GISParams? userLocation;
  final bool? isLocationAllowed;
  DCMapState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.gisResponse,
      this.location,
      this.userLocation,
      this.isLocationAllowed = true});

  DCMapState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final GISResponse? gisResponse,
      final GISParams? location,
      final GISParams? userLocation,
      final bool? isLocationAllowed}) {
    return DCMapState(
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
