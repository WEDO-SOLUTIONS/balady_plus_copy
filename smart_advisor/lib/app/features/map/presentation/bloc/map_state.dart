part of 'map_bloc.dart';

class MapState extends Equatable {
  final BlocStatus zonesStatus;
  final BlocStatus gisDataStatus;
  final BlocStatus validatePointStatus;
  final List<ZoneItem>? zones;
  final List<ValidatePointResponse>? valiadtePoints;
  final GisDataResponse? gisDataResponse;
  final GISDataRequest? gisDataRequest;
  final String? errorMessage;

  const MapState({
    this.zonesStatus = BlocStatus.initial,
    this.gisDataStatus = BlocStatus.initial,
    this.validatePointStatus = BlocStatus.initial,
    this.zones,
    this.gisDataResponse,
    this.valiadtePoints,
    this.errorMessage,
    this.gisDataRequest,
  });

  @override
  List<Object?> get props => [
        zonesStatus,
        gisDataStatus,
        validatePointStatus,
        zones,
        valiadtePoints,
        gisDataResponse,
        errorMessage,
        gisDataRequest
      ];

  MapState copyWith({
    BlocStatus? zonesStatus,
    BlocStatus? gisDataStatus,
    BlocStatus? validatePointStatus,
    List<ZoneItem>? zones,
    List<ValidatePointResponse>? valiadtePoints,
    GisDataResponse? gisDataResponse,
    GISDataRequest? gisDataRequest,
    String? errorMessage,
  }) {
    return MapState(
        zonesStatus: zonesStatus ?? this.zonesStatus,
        gisDataStatus: gisDataStatus ?? this.gisDataStatus,
        validatePointStatus: validatePointStatus ?? this.validatePointStatus,
        zones: zones ?? this.zones,
        valiadtePoints: valiadtePoints ?? this.valiadtePoints,
        gisDataResponse: gisDataResponse ?? this.gisDataResponse,
        errorMessage: errorMessage ?? this.errorMessage,
        gisDataRequest: gisDataRequest ?? this.gisDataRequest);
  }
}
