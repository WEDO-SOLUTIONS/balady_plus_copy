part of 'location_bloc.dart';

class LocationState extends Equatable {
  final BlocRequestStatus requestsStatus;

  final String? errorMessage;
  final GISParams? gisParams;
  final GISResponse? gisResponse;
  final BlocStatus locationPermissionStatus;
  final BlocStatus locationStatus;

  const LocationState(
      {this.requestsStatus = BlocRequestStatus.initial,
      this.locationPermissionStatus = BlocStatus.initial,
      this.locationStatus = BlocStatus.initial,
      this.errorMessage,
      this.gisParams,
      this.gisResponse});

  String get error => errorMessage ?? '';

  LocationState copyWith({
    BlocRequestStatus? requestsStatus,
    String? errorMessage,
    GISParams? gisParams,
    GISResponse? gisResponse,
    BlocStatus? locationPermissionStatus,
    BlocStatus? locationStatus,
  }) {
    return LocationState(
        requestsStatus: requestsStatus ?? this.requestsStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        gisResponse: gisResponse ?? this.gisResponse,
        locationPermissionStatus:
            locationPermissionStatus ?? this.locationPermissionStatus,
        locationStatus: locationStatus ?? this.locationStatus);
  }

  @override
  List<Object?> get props => [
        requestsStatus,
        errorMessage,
        gisResponse,
        locationPermissionStatus,
        locationStatus
      ];
}
