part of 'map_bloc.dart';

class MapState extends Equatable {
  final BlocStatus zonesStatus;
  final BlocStatus gisDataStatus;
  final BlocStatus validatePointStatus;
  final BlocStatus layerStatus;
  final List<ZoneItem>? zones;
  final List<ValidatePointResponse>? valiadtePoints;
  final GisDataResponse? gisDataResponse;
  final GISDataRequest? gisDataRequest;
  final String? errorMessage;
  final bool? clearGISData;
  final List<PointLayersData>? layerData;

  const MapState(
      {this.zonesStatus = BlocStatus.initial,
      this.gisDataStatus = BlocStatus.initial,
      this.validatePointStatus = BlocStatus.initial,
      this.layerStatus = BlocStatus.initial,
      this.zones,
      this.gisDataResponse,
      this.valiadtePoints,
      this.errorMessage,
      this.gisDataRequest,
      this.clearGISData,
      this.layerData});

  @override
  List<Object?> get props => [
        zonesStatus,
        gisDataStatus,
        validatePointStatus,
        zones,
        valiadtePoints,
        gisDataResponse,
        errorMessage,
        gisDataRequest,
        clearGISData,
        layerData,
        layerStatus
      ];

  MapState copyWith(
      {BlocStatus? zonesStatus,
      BlocStatus? gisDataStatus,
      BlocStatus? validatePointStatus,
      List<ZoneItem>? zones,
      List<ValidatePointResponse>? valiadtePoints,
      GisDataResponse? gisDataResponse,
      GISDataRequest? gisDataRequest,
      String? errorMessage,
      bool? clearGISData,
      List<PointLayersData>? layerData,
      BlocStatus? layerStatus}) {
    return MapState(
        layerStatus: layerStatus ?? this.layerStatus,
        zonesStatus: zonesStatus ?? this.zonesStatus,
        gisDataStatus: gisDataStatus ?? this.gisDataStatus,
        validatePointStatus: validatePointStatus ?? this.validatePointStatus,
        zones: zones ?? this.zones,
        valiadtePoints: valiadtePoints ?? this.valiadtePoints,
        gisDataResponse: gisDataResponse ?? this.gisDataResponse,
        errorMessage: errorMessage ?? this.errorMessage,
        gisDataRequest: gisDataRequest ?? this.gisDataRequest,
        clearGISData:
            clearGISData == true ? null : clearGISData ?? this.clearGISData,
        layerData: layerData ?? this.layerData);
  }
}
