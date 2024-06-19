import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

enum SearchType {
  fetchSuggest,
  searchByText,
  searchByQuery,
  quickSearch,
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build(String scope) => '';

  void update(String value) {
    Metrics.logEvent(
      'SearchQuery',
      object: runtimeType,
      extras: {'value': value},
    );
    mixpanel?.track('SearchQuery', properties: {'value': value});
    state = value;
  }
}

@riverpod
class Search extends _$Search {
  /// Search area limit
  static final _saRestrictions = [
    GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
    GeoPointMessage(latitude: 32.568765, longitude: 32.61185),
    GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
    GeoPointMessage(latitude: 15.506104, longitude: 56.694472),
  ];

  SearchType? _previousType;
  String? _previousQuery;
  SearchQueryMessage? _previousSearchQueryMessage;
  QuickFilter? _previousQuickSearch;
  CancelableOperation? _searchOperation;

  @override
  SearchState build(String scope) {
    ref.listen(searchQueryProvider(scope), (_, next) {
      fetchSuggest(next);
    });

    return SearchStateHistory();
  }

  void clear() {
    state = SearchStateHistory();
    _previousType = null;
    _previousQuery = null;
    _previousSearchQueryMessage = null;
    _previousQuickSearch = null;
  }

  Future<void> fetchSuggest(String query) async {
    _previousType = SearchType.fetchSuggest;
    _previousQuery = query;
    Metrics.logEvent(
      'fetchSuggest',
      object: runtimeType,
    );

    mixpanel?.timeEvent('Search: fetchSuggest');
    await _searchOperation?.cancel();
    if (query.isEmpty) {
      state = SearchStateHistory();
      return;
    }
    final dgisController = await ref.read(dgisControllerProvider.future);
    final searchRect = ref.read(searchInRectProvider.select((value) => value.$1));

    final searchOperation = CancelableOperation.fromFuture(dgisController.fetchSuggest(
      query,
      searchRect: searchRect,
    ));
    _searchOperation = searchOperation;
    final result = await searchOperation.value;
    state = result.suggests.isEmpty ? SearchStateEmpty() : SearchStateSuggest(result);
    mixpanel?.track('Search: fetchSuggest');
  }

  Future<void> quickSearch(QuickFilter quickSearch) async {
    final language = ref.read(appLanguageProvider);
    _previousType = SearchType.quickSearch;
    _previousQuickSearch = quickSearch;
    final searchQuery = quickSearch.query[language] ?? '';
    final searchRect = ref.read(searchInRectProvider.select((value) => value.$1));
    Metrics.logEvent(
      'quickSearch',
      object: runtimeType,
      extras: {'query': searchQuery},
    );

    mixpanel?.timeEvent('Search: quickSearch');
    await _searchOperation?.cancel();
    final dgisController = await ref.read(dgisControllerProvider.future);

    final searchOperation = CancelableOperation.fromFuture(
      dgisController.search(
        searchQuery,
        sortingType: SortingTypeMessage.byDistance,
        spatialRestriction: _saRestrictions,
        searchRect: searchRect,
      ),
    );
    _searchOperation = searchOperation;
    final results = await searchOperation.value;
    state = (results.firstPage?.items.isEmpty ?? true)
        ? SearchStateEmpty()
        : SearchStateResults(
            results,
            searchQuery,
            markerType: quickSearch.markerType,
          );
    mixpanel?.track('Search: quickSearch');
  }

  Future<void> searchByText(String query) async {
    _previousType = SearchType.searchByText;
    _previousQuery = query;
    final searchRect = ref.read(searchInRectProvider.select((value) => value.$1));
    Metrics.logEvent(
      'searchByText',
      object: runtimeType,
      extras: {'query': query},
    );

    mixpanel?.timeEvent('Search: searchByText');
    await _searchOperation?.cancel();
    final dgisController = await ref.read(dgisControllerProvider.future);

    final searchOperation = CancelableOperation.fromFuture(
      dgisController.search(
        query,
        sortingType: SortingTypeMessage.byDistance,
        spatialRestriction: _saRestrictions,
        searchRect: searchRect,
      ),
    );
    _searchOperation = searchOperation;
    final results = await searchOperation.value;
    state = (results.firstPage?.items.isEmpty ?? true) ? SearchStateEmpty() : SearchStateResults(results, query);
    mixpanel?.track('Search: searchByText');
  }

  Future<void> searchByQuery(SearchQueryMessage query, String text) async {
    _previousType = SearchType.searchByQuery;
    _previousQuery = text;
    _previousSearchQueryMessage = query;
    final searchRect = ref.read(searchInRectProvider.select((value) => value.$1));

    Metrics.logEvent(
      'Search/searchByQuery',
      object: runtimeType,
      extras: {'query_id': query.id},
    );
    mixpanel?.timeEvent('Search: searchByQuery');
    await _searchOperation?.cancel();
    final dgisController = await ref.read(dgisControllerProvider.future);

    final searchOperation = CancelableOperation.fromFuture(
      dgisController.searchByQuery(
        query,
        sortingType: SortingTypeMessage.byDistance,
        spatialRestriction: _saRestrictions,
        searchRect: searchRect,
      ),
    );
    _searchOperation = searchOperation;
    final results = await searchOperation.value;
    state = (results.firstPage?.items.isEmpty ?? true) ? SearchStateEmpty() : SearchStateResults(results, text);
    mixpanel?.track('Search: searchByQuery');
  }

  void searchInThisArea() {
    switch (_previousType) {
      case null:
        break;
      case SearchType.fetchSuggest:
        fetchSuggest(_previousQuery!);
        break;
      case SearchType.searchByText:
        searchByText(_previousQuery!);
        break;
      case SearchType.searchByQuery:
        searchByQuery(_previousSearchQueryMessage!, _previousQuery!);
        break;
      case SearchType.quickSearch:
        quickSearch(_previousQuickSearch!);
        break;
    }
  }
}
