import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/favorite_lists/data/models/favorite_list_place_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_type.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/data/models/pagination_dto.dart';

// ignore_for_file: invalid_annotation_target

part 'favorite_list_dto.freezed.dart';

part 'favorite_list_dto.g.dart';

@freezed
abstract class MarkerColorDto with _$MarkerColorDto {
  factory MarkerColorDto({
    required final String code,
    required final String hexValue,
    required final String nameEn,
    required final String nameAr,
  }) = _MarkerColorDto;

  factory MarkerColorDto.fromJson(Map<String, dynamic> json) => _$MarkerColorDtoFromJson(json);
}

@freezed
abstract class FavoriteListLimitsDto with _$FavoriteListLimitsDto {
  factory FavoriteListLimitsDto({
    required final int maxLists,
    required final int maxPlacesPerList,
  }) = _FavoriteListLimitsDto;

  factory FavoriteListLimitsDto.fromJson(Map<String, dynamic> json) => _$FavoriteListLimitsDtoFromJson(json);
}

@freezed
abstract class FavoriteListDto with _$FavoriteListDto {
  factory FavoriteListDto({
    required final String id,
    required final String name,
    required final String? description,
    required final bool isDefault,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    @JsonKey(unknownEnumValue: MarkerColorCode.unknown) required final MarkerColorCode markerColorCode,
    @JsonKey(unknownEnumValue: FavoriteIconType.$default) final FavoriteIconType? iconType,
    // Present on "get all"/"get by id" responses, absent on create/update responses.
    final MarkerColorDto? markerColor,
    final int? placeCount,
    final List<FavoriteListPlaceDto>? places,
  }) = _FavoriteListDto;

  factory FavoriteListDto.fromJson(Map<String, dynamic> json) => _$FavoriteListDtoFromJson(json);
}

@freezed
abstract class FavoriteListRequestDto with _$FavoriteListRequestDto {
  factory FavoriteListRequestDto({
    required final String name,
    final String? description,
    @JsonKey(unknownEnumValue: MarkerColorCode.unknown) final MarkerColorCode? markerColorCode,
    @JsonKey(unknownEnumValue: FavoriteIconType.$default) final FavoriteIconType? iconType,
  }) = _FavoriteListRequestDto;

  factory FavoriteListRequestDto.fromJson(Map<String, dynamic> json) => _$FavoriteListRequestDtoFromJson(json);
}

@freezed
abstract class FavoriteListsResponseDto with _$FavoriteListsResponseDto {
  factory FavoriteListsResponseDto({
    required final List<FavoriteListDto> lists,
    required final String displayMode,
    required final FavoriteListLimitsDto limits,
  }) = _FavoriteListsResponseDto;

  factory FavoriteListsResponseDto.fromJson(Map<String, dynamic> json) => _$FavoriteListsResponseDtoFromJson(json);
}

@freezed
abstract class FavoriteListResponseDto with _$FavoriteListResponseDto {
  factory FavoriteListResponseDto({
    required final FavoriteListDto list,
  }) = _FavoriteListResponseDto;

  factory FavoriteListResponseDto.fromJson(Map<String, dynamic> json) => _$FavoriteListResponseDtoFromJson(json);
}

@freezed
abstract class FavoriteListDetailResponseDto with _$FavoriteListDetailResponseDto {
  factory FavoriteListDetailResponseDto({
    required final FavoriteListDto list,
    required final PaginationDto pagination,
  }) = _FavoriteListDetailResponseDto;

  factory FavoriteListDetailResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FavoriteListDetailResponseDtoFromJson(json);
}

@freezed
abstract class DeleteFavoriteListResultDto with _$DeleteFavoriteListResultDto {
  factory DeleteFavoriteListResultDto({
    required final bool deleted,
    required final int removedPlaces,
    required final int orphanedCount,
  }) = _DeleteFavoriteListResultDto;

  factory DeleteFavoriteListResultDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteFavoriteListResultDtoFromJson(json);
}
