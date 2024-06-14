import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

List<GeoPointMessage> saRestrictions = [
  GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
  GeoPointMessage(latitude: 32.568765, longitude: 32.61185),
  GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
  GeoPointMessage(latitude: 15.506104, longitude: 56.694472),
];

enum SearchType {
  fetchSuggest,
  searchByText,
  searchByQuery,
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
  SearchType? previousType;
  String? previousQuery;
  SearchQueryMessage? prevSearchQueryMessage;
  @override
  SearchState build(String scope) {
    ref.listen(searchQueryProvider(scope), (_, next) {
      fetchSuggest(next);
    });

    return SearchStateHistory();
  }

  CancelableOperation? _searchOperation;

  void clear() {
    state = SearchStateHistory();
    previousType = null;
    previousQuery = null;
    prevSearchQueryMessage = null;
  }

  void refresh() {
    ref.invalidateSelf();
  }

  Future<void> fetchSuggest(String query) async {
    previousType = SearchType.fetchSuggest;
    previousQuery = query;
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

  Future<void> searchByText(String query) async {
    previousType = SearchType.searchByText;
    previousQuery = query;
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
        spatialRestriction: getListFromRect(searchRect),
        searchRect: searchRect,
      ),
    );
    _searchOperation = searchOperation;
    final results = await searchOperation.value;
    state = (results.firstPage?.items.isEmpty ?? true) ? SearchStateEmpty() : SearchStateResults(results, query);
    mixpanel?.track('Search: fetchSuggest');
  }

  Future<void> searchByQuery(SearchQueryMessage query, String text) async {
    previousType = SearchType.searchByQuery;
    previousQuery = text;
    prevSearchQueryMessage = query;
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
        spatialRestriction: getListFromRect(searchRect),
        searchRect: searchRect,
      ),
    );
    _searchOperation = searchOperation;
    final results = await searchOperation.value;
    state = (results.firstPage?.items.isEmpty ?? true) ? SearchStateEmpty() : SearchStateResults(results, text);
    mixpanel?.track('Search: searchByQuery');
  }

  void searchInThisArea() {
    switch (previousType) {
      case null:
        break;
      case SearchType.fetchSuggest:
        fetchSuggest(previousQuery!);
        break;
      case SearchType.searchByText:
        searchByText(previousQuery!);
        break;
      case SearchType.searchByQuery:
        searchByQuery(prevSearchQueryMessage!, previousQuery!);
        break;
    }
  }
}

List<GeoPointMessage>? getListFromRect(GeoRectMessage? rect) {
  if (rect == null) {
    return null;
  }
  return [
    GeoPointMessage(latitude: rect.northEast.latitude, longitude: rect.northEast.longitude),
    GeoPointMessage(latitude: rect.northEast.latitude, longitude: rect.southWest.longitude),
    GeoPointMessage(latitude: rect.southWest.latitude, longitude: rect.southWest.longitude),
    GeoPointMessage(latitude: rect.southWest.latitude, longitude: rect.northEast.longitude),
  ];
}
