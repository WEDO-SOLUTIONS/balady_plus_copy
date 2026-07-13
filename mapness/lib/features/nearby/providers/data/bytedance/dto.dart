part of 'bytedance_nearby_data_source.dart';

@freezed
abstract class BytedanceNearbyResponse with _$BytedanceNearbyResponse {
  const factory BytedanceNearbyResponse({
    required int total,
    required List<BytedanceNearbyItem> items,
  }) = _BytedanceNearbyResponse;

  factory BytedanceNearbyResponse.fromJson(Map<String, dynamic> json) => _$BytedanceNearbyResponseFromJson(json);
}

@freezed
abstract class BytedanceNearbyItem with _$BytedanceNearbyItem {
  const factory BytedanceNearbyItem({required String id}) = _BytedanceNearbyItem;

  factory BytedanceNearbyItem.fromJson(Map<String, dynamic> json) => _$BytedanceNearbyItemFromJson(json);
}
