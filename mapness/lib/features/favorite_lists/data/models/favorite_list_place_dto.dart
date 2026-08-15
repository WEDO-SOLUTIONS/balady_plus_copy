import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/favorite_lists/data/models/pagination_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/place_type.dart';

part 'favorite_list_place_dto.freezed.dart';

part 'favorite_list_place_dto.g.dart';

@freezed
abstract class FavoriteListPlaceDto with _$FavoriteListPlaceDto {
  factory FavoriteListPlaceDto({
    required final String placeId,
    required final PlaceType placeType,
    required final DateTime addedAt,
    final String? customName,
  }) = _FavoriteListPlaceDto;

  factory FavoriteListPlaceDto.fromJson(Map<String, dynamic> json) => _$FavoriteListPlaceDtoFromJson(json);
}

@freezed
abstract class AddPlaceRequestDto with _$AddPlaceRequestDto {
  factory AddPlaceRequestDto({
    required final String placeId,
  }) = _AddPlaceRequestDto;

  factory AddPlaceRequestDto.fromJson(Map<String, dynamic> json) => _$AddPlaceRequestDtoFromJson(json);
}

@freezed
abstract class FavoriteListPlacesResponseDto with _$FavoriteListPlacesResponseDto {
  factory FavoriteListPlacesResponseDto({
    required final List<FavoriteListPlaceDto> places,
    required final PaginationDto pagination,
  }) = _FavoriteListPlacesResponseDto;

  factory FavoriteListPlacesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FavoriteListPlacesResponseDtoFromJson(json);
}

@freezed
abstract class AddPlaceResultDto with _$AddPlaceResultDto {
  factory AddPlaceResultDto({
    required final String placeId,
    required final PlaceType placeType,
    required final bool wasAlreadyPresent,
  }) = _AddPlaceResultDto;

  factory AddPlaceResultDto.fromJson(Map<String, dynamic> json) => _$AddPlaceResultDtoFromJson(json);
}

@freezed
abstract class RemovePlaceResultDto with _$RemovePlaceResultDto {
  factory RemovePlaceResultDto({
    required final String placeId,
    required final PlaceType placeType,
    required final bool removed,
    required final bool removedFromFavorites,
  }) = _RemovePlaceResultDto;

  factory RemovePlaceResultDto.fromJson(Map<String, dynamic> json) => _$RemovePlaceResultDtoFromJson(json);
}

@freezed
abstract class BulkAssignPlaceRequestDto with _$BulkAssignPlaceRequestDto {
  factory BulkAssignPlaceRequestDto({
    required final List<String> addToListIds,
    required final List<String> removeFromListIds,
  }) = _BulkAssignPlaceRequestDto;

  factory BulkAssignPlaceRequestDto.fromJson(Map<String, dynamic> json) => _$BulkAssignPlaceRequestDtoFromJson(json);
}

@freezed
abstract class BulkAssignResultDto with _$BulkAssignResultDto {
  factory BulkAssignResultDto({
    required final String placeId,
    required final PlaceType placeType,
    required final List<String> addedToListIds,
    required final List<String> alreadyInListIds,
    required final int removedCount,
    required final bool removedFromFavorites,
  }) = _BulkAssignResultDto;

  factory BulkAssignResultDto.fromJson(Map<String, dynamic> json) => _$BulkAssignResultDtoFromJson(json);
}
