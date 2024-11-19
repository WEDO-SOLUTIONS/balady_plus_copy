import 'package:dgis_map/library.dart';

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
}
