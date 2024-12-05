import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';

@immutable
class SearchInRectState {
  final GeoRectMessage? rect;
  final bool isButtonVisible;
  final bool isSearchInThisAreaRequest;

  const SearchInRectState({
    required this.rect,
    required this.isButtonVisible,
    this.isSearchInThisAreaRequest = false,
  });

  SearchInRectState copyWith({
    GeoRectMessage? rect,
    bool? isButtonVisible,
    bool? isSearchInThisAreaRequest,
  }) =>
      SearchInRectState(
        rect: rect ?? this.rect,
        isButtonVisible: isButtonVisible ?? this.isButtonVisible,
        isSearchInThisAreaRequest: isSearchInThisAreaRequest ?? this.isSearchInThisAreaRequest,
      );

  @override
  String toString() =>
      'SearchInRectState(rect: ne: (${rect?.northEast.latitude}, ${rect?.northEast.longitude}) sw: (${rect?.southWest.latitude}, ${rect?.southWest.longitude}), isButtonVisible: $isButtonVisible, isSearchInThisAreaRequest: $isSearchInThisAreaRequest)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchInRectState &&
          rect == other.rect &&
          isButtonVisible == other.isButtonVisible &&
          isSearchInThisAreaRequest == other.isSearchInThisAreaRequest;

  @override
  int get hashCode => Object.hash(rect, isButtonVisible, isSearchInThisAreaRequest);
}
