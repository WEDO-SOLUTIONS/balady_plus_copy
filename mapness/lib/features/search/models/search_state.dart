import 'package:dgis_map/library.dart';

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
  final String suggestionSessionId;

  const SearchStateSuggest({
    required this.suggest,
    required this.suggestionSessionId,
    required super.searchText,
  });

  SearchStateSuggest copyWith({
    SuggestResultMessage? suggest,
    String? searchText,
    String? suggestionSessionId,
  }) => SearchStateSuggest(
    suggest: suggest ?? this.suggest,
    searchText: searchText ?? this.searchText,
    suggestionSessionId: suggestionSessionId ?? this.suggestionSessionId,
  );
}

class SearchStateResults extends SearchState {
  final SearchResultMessage results;
  final String searchSessionId;
  final MapMarkersType? markerType;

  const SearchStateResults({
    required this.results,
    required this.searchSessionId,
    required super.searchText,
    this.markerType,
  });

  SearchStateResults copyWith({
    SearchResultMessage? results,
    String? searchSessionId,
    String? searchText,
    MapMarkersType? markerType,
  }) => SearchStateResults(
    results: results ?? this.results,
    searchSessionId: searchSessionId ?? this.searchSessionId,
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
    )
    failure,
  }) => switch (this) {
    SearchStateEmpty() => empty(),
    SearchStateHistory() => history(),
    SearchStateLoading() => loading(),
    SearchStateSuggest(suggest: final value) => suggest(value),
    SearchStateResults(results: final value) => results(value),
    SearchStateError(searchText: final query, errorMessage: final errorMessage) => failure(query, errorMessage),
  };
}
