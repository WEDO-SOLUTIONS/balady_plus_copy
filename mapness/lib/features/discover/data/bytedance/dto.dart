part of 'bytedance_discover_data_source.dart';

@freezed
abstract class BytedanceDiscoverResponse with _$BytedanceDiscoverResponse {
  const factory BytedanceDiscoverResponse({
    required int total,
    required List<BytedanceDiscoverItem> items,
  }) = _BytedanceDiscoverResponse;

  factory BytedanceDiscoverResponse.fromJson(Map<String, dynamic> json) => _$BytedanceDiscoverResponseFromJson(json);
}

@freezed
abstract class BytedanceDiscoverItem with _$BytedanceDiscoverItem {
  const factory BytedanceDiscoverItem({required String name}) = _BytedanceDiscoverItem;

  factory BytedanceDiscoverItem.fromJson(Map<String, dynamic> json) => _$BytedanceDiscoverItemFromJson(json);
}
