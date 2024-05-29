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
  }

  Future<void> fetchSuggest(String query) async {
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
    final searchRect = ref.watch(searchInRectProvider.select((value) => value.$1));
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
        //   spatialRestriction: saRestrictions,
        searchRect: searchRect,
      ),
    );
    _searchOperation = searchOperation;
    final results = await searchOperation.value;
    state = (results.firstPage?.items.isEmpty ?? true) ? SearchStateEmpty() : SearchStateResults(results, query);
    mixpanel?.track('Search: fetchSuggest');
  }

  Future<void> searchByQuery(SearchQueryMessage query, String text) async {
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
        // spatialRestriction: saRestrictions,
        searchRect: searchRect,
      ),
    );
    _searchOperation = searchOperation;
    final results = await searchOperation.value;
    state = (results.firstPage?.items.isEmpty ?? true) ? SearchStateEmpty() : SearchStateResults(results, text);
    mixpanel?.track('Search: searchByQuery');
  }
}
