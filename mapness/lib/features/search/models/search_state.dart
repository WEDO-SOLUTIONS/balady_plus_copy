import 'package:dgis_map/library.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';

sealed class SearchState {
  final String searchText;

  const SearchState({required this.searchText});
}

class SearchStateHistory extends SearchState {
  const SearchStateHistory({super.searchText = ''});

  SearchStateHistory copyWith({String? searchText}) => SearchStateHistory(
        searchText: searchText ?? this.searchText,
      );
}

class SearchStateError extends SearchState {
  final String? errorMessage;

  const SearchStateError({
    this.errorMessage,
    super.searchText = '',
  });

  SearchStateError copyWith({String? searchText}) => SearchStateError(
        searchText: searchText ?? this.searchText,
      );
}

class SearchStateEmpty extends SearchState {
  const SearchStateEmpty({required super.searchText});

  SearchStateEmpty copyWith({String? searchText}) => SearchStateEmpty(
        searchText: searchText ?? this.searchText,
      );
}

class SearchStateLoading extends SearchState {
  const SearchStateLoading({required super.searchText});

  SearchStateLoading copyWith({String? searchText}) => SearchStateLoading(
        searchText: searchText ?? this.searchText,
      );
}

class SearchStateSuggest extends SearchState {
  final SuggestResultMessage suggest;

  const SearchStateSuggest({
    required this.suggest,
    required super.searchText,
  });

  SearchStateSuggest copyWith({
    SuggestResultMessage? suggest,
    String? searchText,
  }) =>
      SearchStateSuggest(
        suggest: suggest ?? this.suggest,
        searchText: searchText ?? this.searchText,
      );
}

class SearchStateResults extends SearchState {
  final SearchResultMessage results;
  final MapMarkersType? markerType;

  const SearchStateResults({
    required this.results,
    required super.searchText,
    this.markerType,
  });

  SearchStateResults copyWith({
    SearchResultMessage? results,
    String? searchText,
    MapMarkersType? markerType,
  }) =>
      SearchStateResults(
        results: results ?? this.results,
        searchText: searchText ?? this.searchText,
        markerType: markerType ?? this.markerType,
      );
}

extension SearchStateMap on SearchState {
  T map<T>({
    required T Function() empty,
    required T Function() history,
    required T Function() loading,
    required T Function(SuggestResultMessage suggest) suggest,
    required T Function(SearchResultMessage results) results,
    required T Function(
      String query,
      String? errorMessage,
    ) failure,
  }) =>
      switch (this) {
        SearchStateEmpty() => empty(),
        SearchStateHistory() => history(),
        SearchStateLoading() => loading(),
        SearchStateSuggest(suggest: final value) => suggest(value),
        SearchStateResults(results: final value) => results(value),
        SearchStateError(searchText: final query, errorMessage: final errorMessage) => failure(query, errorMessage),
      };
}
