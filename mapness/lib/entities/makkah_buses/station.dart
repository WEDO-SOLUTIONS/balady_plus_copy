// ignore_for_file: invalid_annotation_target
part of 'model.dart';

@freezed
abstract class BusStationDto with _$BusStationDto {
  const factory BusStationDto({
    required String type,
    required List<BusStationDtoFeature> features,
  }) = _BusStationDto;

  factory BusStationDto.fromJson(Map<String, dynamic> json) => _$BusStationDtoFromJson(json);
}

@freezed
abstract class BusStationDtoFeature with _$BusStationDtoFeature {
  const factory BusStationDtoFeature({
    required String type,
    required int id,
    required BusStationDtoGeometry geometry,
    required BusStationDtoProperties properties,
  }) = _BusStationDtoFeature;

  factory BusStationDtoFeature.fromJson(Map<String, dynamic> json) => _$BusStationDtoFeatureFromJson(json);
}

@freezed
abstract class BusStationDtoGeometry with _$BusStationDtoGeometry {
  const factory BusStationDtoGeometry({
    required String type,

    /// [longitude, latitude]
    required List<double> coordinates,
  }) = _BusStationDtoGeometry;

  factory BusStationDtoGeometry.fromJson(Map<String, dynamic> json) => _$BusStationDtoGeometryFromJson(json);
}

@freezed
abstract class BusStationDtoProperties with _$BusStationDtoProperties {
  const factory BusStationDtoProperties({
    @JsonKey(name: 'OBJECTID') required int objectId,
    @JsonKey(name: 'station_id') required String stationId,
    @JsonKey(name: 'station_name_en') required String stationNameEn,
    @JsonKey(name: 'station_name_ar') required String stationNameAr,

    /// Comma-separated route names, e.g. "L10,L11,L12"
    @JsonKey(name: 'route_names_en') required String routeNamesEn,
    @JsonKey(name: 'route_count') required int routeCount,
  }) = _BusStationDtoProperties;

  const BusStationDtoProperties._();

  factory BusStationDtoProperties.fromJson(Map<String, dynamic> json) => _$BusStationDtoPropertiesFromJson(json);

  List<String> get routesNamesEnList => routeNamesEn.split(',');
}
