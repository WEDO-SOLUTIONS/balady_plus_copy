part of 'map_bloc.dart';

class MapState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final ComplainceGISResponse? gisResponse;
  final GISParams? location;
  final GISParams? userLocation;
  final bool? isLocationAllowed;
  final bool? readOnly;
  final int? requestNo;
  MapState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.gisResponse,
      this.location,
      this.userLocation,
      this.isLocationAllowed = true,
      this.readOnly = false,
      this.requestNo});

  MapState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      final ComplainceGISResponse? gisResponse,
      final GISParams? location,
      final GISParams? userLocation,
      final bool? isLocationAllowed,
      final bool? readOnly,
      final int? requestNo}) {
    return MapState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        gisResponse: gisResponse ?? this.gisResponse,
        location: location ?? this.location,
        userLocation: userLocation ?? this.userLocation,
        isLocationAllowed: isLocationAllowed ?? this.isLocationAllowed,
        readOnly: readOnly ?? this.readOnly,
        requestNo: requestNo ?? this.requestNo);
  }

  @override
  List<Object?> get props => [
        status,
        location,
        userLocation,
        gisResponse,
        isLocationAllowed,
        readOnly,
        requestNo
      ];
}
