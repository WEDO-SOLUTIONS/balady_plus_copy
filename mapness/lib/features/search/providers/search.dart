import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
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
    _searchOperation?.cancel();
    if (query.isEmpty) {
      state = SearchStateHistory();
      return;
    }
    final dgisController = ref.read(dgisControllerProvider);

    final searchOperation =
        CancelableOperation.fromFuture(dgisController!.fetchSuggest(query));
    _searchOperation = searchOperation;
    searchOperation.value.then(
      (result) => state = result.suggests.isEmpty
          ? SearchStateEmpty()
          : SearchStateSuggest(result),
    );
  }

  Future<void> searchByText(String query) async {
    _searchOperation?.cancel();
    final dgisController = ref.read(dgisControllerProvider);

    final searchOperation =
        CancelableOperation.fromFuture(dgisController!.search(
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
  }

  Future<void> searchByQuery(SearchQueryMessage query) async {
    _searchOperation?.cancel();
    final dgisController = ref.read(dgisControllerProvider);

    final searchOperation =
        CancelableOperation.fromFuture(dgisController!.searchByQuery(
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
  }
}
