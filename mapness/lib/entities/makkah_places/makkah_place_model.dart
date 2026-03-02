// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'makkah_place_model.freezed.dart';
part 'makkah_place_model.g.dart';

@freezed
abstract class MakkahPlaceFeature with _$MakkahPlaceFeature {
  @JsonSerializable(explicitToJson: true)
  const factory MakkahPlaceFeature({
    String? code,
    @JsonKey(name: 'text_en') String? textEn,
    @JsonKey(name: 'text_ar') String? textAr,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'short_tag_en') String? shortTagEn,
    @JsonKey(name: 'short_tag_ar') String? shortTagAr,
  }) = _MakkahPlaceFeature;

  factory MakkahPlaceFeature.fromJson(Map<String, dynamic> json) => _$MakkahPlaceFeatureFromJson(json);
}

@freezed
abstract class MakkahPlace with _$MakkahPlace {
  @JsonSerializable(explicitToJson: true)
  const factory MakkahPlace({
    @JsonKey(name: 'place_id') String? placeId,
    @JsonKey(name: 'dgis_id') String? dgisId,
    @JsonKey(name: 'is_original_object') bool? isOriginalObject,
    @JsonKey(name: 'title_en') String? titleEn,
    @JsonKey(name: 'title_ar') String? titleAr,
    @JsonKey(name: 'description_en') String? descriptionEn,
    @JsonKey(name: 'description_ar') String? descriptionAr,
    @JsonKey(name: 'marker_image_url') String? markerImageUrl,
    double? lon,
    double? lat,
    @JsonKey(name: 'preview_image_url') String? previewImageUrl,
    @JsonKey(name: 'photo_urls') List<String>? photoUrls,
    @JsonKey(name: 'workhours_en') String? workhoursEn,
    @JsonKey(name: 'workhours_ar') String? workhoursAr,
    String? website,
    String? phone,
    @JsonKey(name: 'tags_en') List<String>? tagsEn,
    @JsonKey(name: 'tags_ar') List<String>? tagsAr,
    @JsonKey(name: 'general_tag_en') String? generalTagEn,
    @JsonKey(name: 'general_tag_ar') String? generalTagAr,
    @JsonKey(name: 'features_en') String? featuresEn,
    @JsonKey(name: 'features_ar') String? featuresAr,
    @JsonKey(name: 'features') List<MakkahPlaceFeature>? features,
    @JsonKey(name: 'accessibility_en') String? accessibilityEn,
    @JsonKey(name: 'accessibility_ar') String? accessibilityAr,
    @JsonKey(name: 'address_en') String? addressEn,
    @JsonKey(name: 'address_ar') String? addressAr,
    @JsonKey(name: 'fixed_order_position') int? fixedOrderPosition,
    @JsonKey(name: 'workhours_json') Map<String, dynamic>? workhoursJson,
    @JsonKey(name: 'poi_id') String? poiId,
  }) = _MakkahPlace;

  factory MakkahPlace.fromJson(Map<String, dynamic> json) => _$MakkahPlaceFromJson(json);
}
