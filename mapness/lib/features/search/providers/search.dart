import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/search_state.dart';

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
  String build(String scope) => "";

  void update(String value) {
    ref.read(urbiMetricsProvider.notifier).logEvent(
      "SearchQuery",
      {"value": value},
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

  Future<void> fetchSuggest(String query) async {
    ref.read(urbiMetricsProvider.notifier).logEvent("Search/fetchSuggest");
    mixpanel?.timeEvent("Search: fetchSuggest");
    _searchOperation?.cancel();
    if (query.isEmpty) {
      state = SearchStateHistory();
      return;
    }
    final dgisController = await ref.read(dgisControllerProvider.future);

    final searchOperation =
        CancelableOperation.fromFuture(dgisController.fetchSuggest(query));
    _searchOperation = searchOperation;
    searchOperation.value.then(
      (result) => state = result.suggests.isEmpty
          ? SearchStateEmpty()
          : SearchStateSuggest(result),
    );
    mixpanel?.track("Search: fetchSuggest");
  }

  Future<void> searchByText(String query) async {
    ref.read(urbiMetricsProvider.notifier).logEvent(
      "Search/searchByText",
      {"query": query},
    );
    mixpanel?.timeEvent("Search: searchByText");
    _searchOperation?.cancel();
    final dgisController = await ref.read(dgisControllerProvider.future);

    final searchOperation =
        CancelableOperation.fromFuture(dgisController.search(
      query,
      sortingType: SortingTypeMessage.byDistance,
      spatialRestriction: saRestrictions,
    ));
    _searchOperation = searchOperation;
    searchOperation.value.then(
      (results) => state = (results.firstPage?.items.isEmpty ?? true)
          ? SearchStateEmpty()
          : SearchStateResults(results),
    );
    mixpanel?.track("Search: fetchSuggest");
  }

  Future<void> searchByQuery(SearchQueryMessage query) async {
    ref.read(urbiMetricsProvider.notifier).logEvent(
      'Search/searchByQuery',
      {'query_id': query.id},
    );
    mixpanel?.timeEvent("Search: searchByQuery");
    _searchOperation?.cancel();
    final dgisController = await ref.read(dgisControllerProvider.future);

    final searchOperation =
        CancelableOperation.fromFuture(dgisController.searchByQuery(
      query,
      sortingType: SortingTypeMessage.byDistance,
      spatialRestriction: saRestrictions,
    ));
    _searchOperation = searchOperation;
    searchOperation.value.then(
      (results) => state = (results.firstPage?.items.isEmpty ?? true)
          ? SearchStateEmpty()
          : SearchStateResults(results),
    );
    mixpanel?.track("Search: searchByQuery");
  }
}
