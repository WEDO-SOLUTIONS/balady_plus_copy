// ignore_for_file: invalid_annotation_target
part of 'model.dart';

@freezed
abstract class BusLineDto with _$BusLineDto {
  const factory BusLineDto({
    required String type,
    required List<BusLineDtoFeature> features,
  }) = _BusLineDto;

  factory BusLineDto.fromJson(Map<String, dynamic> json) => _$BusLineDtoFromJson(json);
}

@freezed
abstract class BusLineDtoFeature with _$BusLineDtoFeature {
  const factory BusLineDtoFeature({
    required String type,
    required int id,
    required BusLineDtoGeometry geometry,
    required BusLineDtoProperties properties,
  }) = _BusLineDtoFeature;

  factory BusLineDtoFeature.fromJson(Map<String, dynamic> json) => _$BusLineDtoFeatureFromJson(json);
}

@freezed
abstract class BusLineDtoGeometry with _$BusLineDtoGeometry {
  const factory BusLineDtoGeometry({
    required String type,

    /// [longitude, latitude]
    required List<List<double>> coordinates,
  }) = _BusLineDtoGeometry;

  factory BusLineDtoGeometry.fromJson(Map<String, dynamic> json) => _$BusLineDtoGeometryFromJson(json);
}

@freezed
abstract class BusLineDtoProperties with _$BusLineDtoProperties {
  const factory BusLineDtoProperties({
    @JsonKey(name: 'OBJECTID') required int objectId,
    @JsonKey(name: 'route_short_name_en') required String routeShortNameEn,
    @JsonKey(name: 'route_short_name_ar') required String routeShortNameAr,
    @JsonKey(name: 'route_long_name_en') required String routeLongNameEn,
    @JsonKey(name: 'route_long_name_ar') required String routeLongNameAr,
    @JsonKey(name: 'from_name_en') required String fromNameEn,
    @JsonKey(name: 'from_name_ar') required String fromNameAr,
    @JsonKey(name: 'to_name_en') required String toNameEn,
    @JsonKey(name: 'to_name_ar') required String toNameAr,
    @JsonKey(name: 'direction_idx') required int directionIdx,
    @JsonKey(name: 'direction_type') required String directionType,
    @JsonKey(name: 'num_platforms') required int numPlatforms,
    @JsonKey(name: 'Color_Code') required String colorCode,
    @JsonKey(name: 'Shape_Length') required double shapeLength,
  }) = _BusLineDtoProperties;

  const BusLineDtoProperties._();

  factory BusLineDtoProperties.fromJson(Map<String, dynamic> json) => _$BusLineDtoPropertiesFromJson(json);
}
