import 'package:dgis_map/library.dart';

sealed class SearchState {}

class SearchStateHistory extends SearchState {}

class SearchStateEmpty extends SearchState {}

class SearchStateSuggest extends SearchState {

  SearchStateSuggest(this.suggest);
  final SuggestResultMessage suggest;
}

class SearchStateResults extends SearchState {

  SearchStateResults(this.results);
  final SearchResultMessage results;
}

extension SearchStateMap on SearchState {
  T map<T>({
    required T Function() empty,
    required T Function() history,
    required T Function(SuggestResultMessage suggest) suggest,
    required T Function(SearchResultMessage results) results,
  }) => switch (this) {
      SearchStateEmpty() => empty(),
      SearchStateHistory() => history(),
      SearchStateSuggest(suggest: final value) => suggest(value),
      SearchStateResults(results: final value) => results(value),
    };
}
