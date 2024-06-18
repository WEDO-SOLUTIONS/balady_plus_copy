import 'package:dgis_map/library.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';

sealed class SearchState {
  const SearchState();
}

class SearchStateHistory extends SearchState {}

class SearchStateEmpty extends SearchState {}

class SearchStateSuggest extends SearchState {
  final SuggestResultMessage suggest;

  const SearchStateSuggest(this.suggest);
}

class SearchStateResults extends SearchState {
  final SearchResultMessage results;
  final String searchText;
  final MapMarkersType? markerType;

  const SearchStateResults(this.results, this.searchText, {this.markerType});
}

extension SearchStateMap on SearchState {
  T map<T>({
    required T Function() empty,
    required T Function() history,
    required T Function(SuggestResultMessage suggest) suggest,
    required T Function(SearchResultMessage results) results,
  }) =>
      switch (this) {
        SearchStateEmpty() => empty(),
        SearchStateHistory() => history(),
        SearchStateSuggest(suggest: final value) => suggest(value),
        SearchStateResults(results: final value) => results(value),
      };
}
