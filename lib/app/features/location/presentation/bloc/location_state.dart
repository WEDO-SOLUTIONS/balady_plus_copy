part of 'location_bloc.dart';

class LocationState extends Equatable {
  final BlocStatus requestsStatus;
  final BlocStatus loadAppStatus;

  final String? errorMessage;
  final GISParams? gisParams;
  final GISResponse? gisResponse;
  final BlocStatus locationPermissionStatus;
  final BlocStatus locationServiceStatus;

  final BlocStatus locationStatus;

  const LocationState(
      {this.requestsStatus = BlocStatus.initial,
      this.loadAppStatus = BlocStatus.initial,
      this.locationPermissionStatus = BlocStatus.initial,
      this.locationServiceStatus = BlocStatus.initial,
      this.locationStatus = BlocStatus.initial,
      this.errorMessage,
      this.gisParams,
      this.gisResponse});

  String get error => errorMessage ?? '';

  LocationState copyWith(
      {BlocStatus? requestsStatus,
      String? errorMessage,
      GISParams? gisParams,
      GISResponse? gisResponse,
      BlocStatus? locationPermissionStatus,
      BlocStatus? locationServiceStatus,
      BlocStatus? locationStatus,
      BlocStatus? loadAppStatus}) {
    return LocationState(
        requestsStatus: requestsStatus ?? this.requestsStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        gisResponse: gisResponse ?? this.gisResponse,
        gisParams: gisParams ?? this.gisParams,
        locationPermissionStatus: locationPermissionStatus ?? this.locationPermissionStatus,
        locationServiceStatus: locationServiceStatus ?? this.locationServiceStatus,
        loadAppStatus: loadAppStatus ?? this.loadAppStatus,
        locationStatus: locationStatus ?? this.locationStatus);
  }

  @override
  List<Object?> get props => [
        requestsStatus,
        errorMessage,
        gisParams,
        gisResponse,
        loadAppStatus,
        locationPermissionStatus,
        locationServiceStatus,
        locationStatus
      ];
}
