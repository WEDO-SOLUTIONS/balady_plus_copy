part of 'bytedance_trending_data_source.dart';

@freezed
abstract class BytedanceTrendingResponse with _$BytedanceTrendingResponse {
  const factory BytedanceTrendingResponse({
    required int total,
    required List<BytedanceTrendingItem> items,
  }) = _BytedanceTrendingResponse;

  factory BytedanceTrendingResponse.fromJson(Map<String, dynamic> json) => _$BytedanceTrendingResponseFromJson(json);
}

@freezed
abstract class BytedanceTrendingItem with _$BytedanceTrendingItem {
  const factory BytedanceTrendingItem({required String id}) = _BytedanceTrendingItem;

  factory BytedanceTrendingItem.fromJson(Map<String, dynamic> json) => _$BytedanceTrendingItemFromJson(json);
}
