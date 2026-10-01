import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_type.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/data/models/place_type.dart';

// ignore_for_file: invalid_annotation_target

part 'map_marker_dto.freezed.dart';

part 'map_marker_dto.g.dart';

@freezed
abstract class MapMarkerPointDto with _$MapMarkerPointDto {
  factory MapMarkerPointDto({
    required final double lat,
    required final double lon,
  }) = _MapMarkerPointDto;

  factory MapMarkerPointDto.fromJson(Map<String, dynamic> json) => _$MapMarkerPointDtoFromJson(json);
}

@freezed
abstract class MapMarkerDto with _$MapMarkerDto {
  factory MapMarkerDto({
    required final String placeId,
    required final PlaceType placeType,
    @JsonKey(unknownEnumValue: MarkerColorCode.unknown) required final MarkerColorCode markerColorCode,
    required final String markerColorHex,
    required final DateTime addedAt,
    required final bool colorPinned,
    @JsonKey(unknownEnumValue: FavoriteIconType.$default) final FavoriteIconType? iconType,
    // Absent for some markers (e.g. legacy/unresolved places) — resolve lazily via
    // searchByObjectId when null, same as before this field existed.
    final MapMarkerPointDto? point,
    // Absent for some markers (e.g. legacy/unresolved places) — falls back to a
    // native searchByObjectId lookup when null, same as before this field existed.
    final String? name,
  }) = _MapMarkerDto;

  factory MapMarkerDto.fromJson(Map<String, dynamic> json) => _$MapMarkerDtoFromJson(json);
}

@freezed
abstract class MapMarkersResponseDto with _$MapMarkersResponseDto {
  factory MapMarkersResponseDto({
    required final List<MapMarkerDto> markers,
  }) = _MapMarkersResponseDto;

  factory MapMarkersResponseDto.fromJson(Map<String, dynamic> json) => _$MapMarkersResponseDtoFromJson(json);
}
