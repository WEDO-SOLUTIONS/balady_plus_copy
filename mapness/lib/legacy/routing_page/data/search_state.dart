import 'package:dgis_map/library.dart';

import 'object_info.dart';

class SearchState {
  SearchState({
    required this.isLoading,
    this.data,
    this.suggests,
  });

  factory SearchState.initial() => SearchState(isLoading: false);

  factory SearchState.loading() => SearchState(isLoading: true);

  factory SearchState.data(List<ObjectInfo> data) =>
      SearchState(isLoading: false, data: data);

  factory SearchState.suggests(List<SuggestMessage> suggests) => SearchState(
        isLoading: false,
        suggests: suggests,
      );

  final bool isLoading;
  final List<ObjectInfo>? data;
  final List<SuggestMessage>? suggests;

  bool get isInitial => !isLoading && data == null;

  bool get hasData => !isLoading && data != null;

  bool get hasSuggests =>
      !isLoading &&
      suggests != null &&
      suggests!.isNotEmpty &&
      (data == null || (data?.isEmpty ?? true));

  bool get isEmpty => hasData && data!.isEmpty;
}
