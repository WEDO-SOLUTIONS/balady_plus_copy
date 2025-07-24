part of 'bss_payload.dart';

class BssSuggestList {
  const BssSuggestList({
    required this.size,
    this.searchSegmentId,
    this.unisearchVersion,
    this.firstResultClass,
  });

  /// Number of elements in the list. Can be 0, since we agreed to register the event "showing empty results"
  final int size;

  /// Segment defined by search
  final BssStringId? searchSegmentId;

  /// Search version (UniSearch). For example 2.10.4
  final String? unisearchVersion;

  /// Class of the first search result
  /// Cannot be determined for queries that do not return any results.
  final int? firstResultClass;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'size': size,
    };
    if (searchSegmentId != null) {
      data['searchSegmentId'] = searchSegmentId;
    }
    if (unisearchVersion != null) {
      data['unisearchVersion'] = unisearchVersion;
    }
    if (firstResultClass != null) {
      data['firstResultClass'] = firstResultClass;
    }
    return data;
  }
}
