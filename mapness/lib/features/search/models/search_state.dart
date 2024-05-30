import 'package:dgis_map/library.dart';

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

  const SearchStateResults(this.results, this.searchText);
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
