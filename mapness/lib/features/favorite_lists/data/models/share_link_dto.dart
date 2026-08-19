import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_type.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/data/models/pagination_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/place_type.dart';

// ignore_for_file: invalid_annotation_target

part 'share_link_dto.freezed.dart';

part 'share_link_dto.g.dart';

@freezed
abstract class ShareLinkDto with _$ShareLinkDto {
  factory ShareLinkDto({
    required final String code,
    required final String shareUrl,
    required final int placeCount,
    required final DateTime snapshotAt,
    required final DateTime? expiresAt,
    required final bool wasExistingLink,
  }) = _ShareLinkDto;

  factory ShareLinkDto.fromJson(Map<String, dynamic> json) => _$ShareLinkDtoFromJson(json);
}

@freezed
abstract class SharedPlaceDto with _$SharedPlaceDto {
  factory SharedPlaceDto({
    required final String placeId,
    required final PlaceType placeType,
  }) = _SharedPlaceDto;

  factory SharedPlaceDto.fromJson(Map<String, dynamic> json) => _$SharedPlaceDtoFromJson(json);
}

@freezed
abstract class SharedListSummaryDto with _$SharedListSummaryDto {
  factory SharedListSummaryDto({
    required final String name,
    required final String? description,
    @JsonKey(unknownEnumValue: MarkerColorCode.unknown) required final MarkerColorCode markerColorCode,
    required final int placeCount,
    required final List<SharedPlaceDto> places,
  }) = _SharedListSummaryDto;

  factory SharedListSummaryDto.fromJson(Map<String, dynamic> json) => _$SharedListSummaryDtoFromJson(json);
}

@freezed
abstract class SharedListPreviewDto with _$SharedListPreviewDto {
  factory SharedListPreviewDto({
    required final String code,
    required final SharedListSummaryDto list,
    required final PaginationDto pagination,
    required final DateTime snapshotAt,
    required final bool isOwnList,
    required final bool alreadyAccepted,
    required final String? acceptedListId,
    required final bool canAccept,
  }) = _SharedListPreviewDto;

  factory SharedListPreviewDto.fromJson(Map<String, dynamic> json) => _$SharedListPreviewDtoFromJson(json);
}

@freezed
abstract class AcceptedFavoriteListDto with _$AcceptedFavoriteListDto {
  factory AcceptedFavoriteListDto({
    required final String id,
    required final String name,
    required final String? description,
    @JsonKey(unknownEnumValue: MarkerColorCode.unknown) required final MarkerColorCode markerColorCode,
    required final bool isDefault,
    @JsonKey(unknownEnumValue: FavoriteIconType.$default) final FavoriteIconType? iconType,
    final int? placeCount,
  }) = _AcceptedFavoriteListDto;

  factory AcceptedFavoriteListDto.fromJson(Map<String, dynamic> json) => _$AcceptedFavoriteListDtoFromJson(json);
}

@freezed
abstract class AcceptShareLinkResultDto with _$AcceptShareLinkResultDto {
  factory AcceptShareLinkResultDto({
    required final bool alreadyAccepted,
    required final AcceptedFavoriteListDto list,
    required final int importedCount,
    required final bool nameWasAdjusted,
  }) = _AcceptShareLinkResultDto;

  factory AcceptShareLinkResultDto.fromJson(Map<String, dynamic> json) => _$AcceptShareLinkResultDtoFromJson(json);
}
