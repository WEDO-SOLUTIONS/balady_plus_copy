import 'package:async/async.dart';
import 'package:dgis_map/library.dart';

import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search.g.dart';

enum SearchType {
  fetchSuggest,
  searchByText,
  searchByQuery,
  quickSearch,
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

  bool get isSearchRunning => _previousType != null;

  @override
  SearchState build(String scope) => const SearchStateHistory();

  void clear() {
    _searchOperation?.cancel();
    state = const SearchStateHistory();
    _previousType = null;
    _previousQuery = null;
    _previousSearchQueryMessage = null;
    _previousQuickSearch = null;
  }

  Future<void> searchQueryChanged(String query) async {
    Metrics.logEvent(
      'SearchQuery',
      object: runtimeType,
      extras: {'value': query},
    );

    if (query.isEmpty) {
      clear();
    }

    await fetchSuggest(query);
  }

  Future<void> fetchSuggest(String query) async {
    try {
      await _searchOperation?.cancel();
      if (query.isEmpty) {
        state = const SearchStateHistory();
        return;
      }

      _updateSearchText(query);
      _previousType = SearchType.fetchSuggest;
      _previousQuery = query;
      // -- Analytics
      AdvancedMetrics.instance.startSearchResponse(
        queryType: _previousType!.name,
        searchQuery: query,
      );
      Metrics.logEvent(
        'fetchSuggest',
        object: runtimeType,
      );
      mixpanel?.timeEvent('Search: fetchSuggest');
      // -- Analytics

      final dgisController = await ref.read(dgisControllerProvider.future);
      final searchRect =
          ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect.geoRectMessage();

      final searchOperation = CancelableOperation.fromFuture(
        dgisController.fetchSuggest(
          query,
          searchRect: searchRect,
        ),
      );
      _searchOperation = searchOperation;
      final result = await searchOperation.value;

      state = result.suggests.isEmpty
          ? SearchStateEmpty(searchText: query)
          : SearchStateSuggest(
              suggest: result,
              searchText: query,
            );
      // -- Analytics
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider).track);
      await mixpanel?.track('Search: fetchSuggest');
      // -- Analytics
    } on Exception catch (_) {
      state = SearchStateError(searchText: query);
      rethrow;
    }
  }

  Future<void> quickSearch(QuickFilter quickSearch, {List<GeoPointMessage>? spatialRestriction}) async {
    await _searchOperation?.cancel();
    final language = ref.read(appLanguageProvider);
    final searchQuery = quickSearch.query[language] ?? '';
    if (searchQuery.isEmpty) {
      state = const SearchStateHistory();
      return;
    }
    try {
      state = SearchStateLoading(searchText: searchQuery);

      _previousType = SearchType.quickSearch;
      _previousQuickSearch = quickSearch;
      final searchRect =
          ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect.geoRectMessage();

      // -- Analytics
      AdvancedMetrics.instance.startSearchResponse(
        queryType: _previousType!.name,
        searchQuery: searchQuery,
      );
      Metrics.logEvent(
        'quickSearch',
        object: runtimeType,
        extras: {'query': searchQuery},
      );
      mixpanel?.timeEvent('Search: quickSearch');
      // -- Analytics

      final dgisController = await ref.read(dgisControllerProvider.future);

      final searchOperation = CancelableOperation.fromFuture(
        dgisController.search(
          searchQuery,
          sortingType: SortingTypeMessage.byDistance,
          // TODO(Sergei): revert value to _saRestrictions when search performance is improved
          spatialRestriction: spatialRestriction ?? _saRestrictions,
          searchRect: searchRect,
        ),
      );
      _searchOperation = searchOperation;
      final results = await searchOperation.value;

      // -- Analytics
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider).track);
      await mixpanel?.track('Search: quickSearch');
      // -- Analytics

      state = (results.firstPage?.items.isEmpty ?? true)
          ? SearchStateEmpty(searchText: searchQuery)
          : SearchStateResults(
              results: results,
              searchText: searchQuery,
              markerType: quickSearch.markerType,
            );
    } on Exception catch (_) {
      state = SearchStateError(searchText: searchQuery);
      rethrow;
    }
  }

  Future<void> searchByText(String query) async {
    try {
      await _searchOperation?.cancel();
      state = SearchStateLoading(searchText: query);

      _previousType = SearchType.searchByText;
      _previousQuery = query;
      final searchRect =
          ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect.geoRectMessage();
      // -- Analytics
      AdvancedMetrics.instance.startSearchResponse(
        queryType: _previousType!.name,
        searchQuery: query,
      );
      Metrics.logEvent(
        'searchByText',
        object: runtimeType,
        extras: {'query': query},
      );
      mixpanel?.timeEvent('Search: searchByText');
      // -- Analytics

      final dgisController = await ref.read(dgisControllerProvider.future);

      final searchOperation = CancelableOperation.fromFuture(
        dgisController.search(
          query,
          sortingType: SortingTypeMessage.byDistance,
          // TODO(Sergei): revert value to _saRestrictions when search performance is improved
          // TODO(Dmitrii): Search improved but we have to test it more so we could return `_getRestrictionFromRect()` here
          spatialRestriction: _saRestrictions,
          searchRect: searchRect,
        ),
      );
      _searchOperation = searchOperation;
      final results = await searchOperation.value;

      state = (results.firstPage?.items.isEmpty ?? true)
          ? SearchStateEmpty(searchText: query)
          : SearchStateResults(
              results: results,
              searchText: query,
            );
      // -- Analytics
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider).track);
      await mixpanel?.track('Search: searchByText');
      // -- Analytics
    } on Exception catch (_) {
      state = SearchStateError(searchText: query);
      rethrow;
    }
  }

  Future<void> searchByQuery(SearchQueryMessage query, String text, {List<GeoPointMessage>? spatialRestriction}) async {
    try {
      await _searchOperation?.cancel();
      state = SearchStateLoading(searchText: text);

      _previousType = SearchType.searchByQuery;
      _previousQuery = text;
      _previousSearchQueryMessage = query;
      final searchRect =
          ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect.geoRectMessage();
      // -- Analytics
      AdvancedMetrics.instance.startSearchResponse(
        queryType: _previousType!.name,
        searchQuery: text,
      );
      Metrics.logEvent(
        'Search/searchByQuery',
        object: runtimeType,
        extras: {'query_id': query.id},
      );
      mixpanel?.timeEvent('Search: searchByQuery');
      // -- Analytics

      final dgisController = await ref.read(dgisControllerProvider.future);

      final searchOperation = CancelableOperation.fromFuture(
        dgisController.searchByQuery(
          query,
          sortingType: SortingTypeMessage.byDistance,
          // TODO(Sergei): revert value to _saRestrictions when search performance is improved
          spatialRestriction: spatialRestriction ?? _saRestrictions,
          searchRect: searchRect,
        ),
      );
      _searchOperation = searchOperation;
      final results = await searchOperation.value;

      state = (results.firstPage?.items.isEmpty ?? true)
          ? SearchStateEmpty(searchText: text)
          : SearchStateResults(
              results: results,
              searchText: text,
            );
      // -- Analytics
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider).track);
      await mixpanel?.track('Search: searchByQuery');
      // -- Analytics
    } on Exception catch (_) {
      state = SearchStateError(searchText: text);
      rethrow;
    }
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
        // TODO(Sergei): workaround for fast search from searchInThisArea, remove spatialRestriction param when search performance is improved
        searchByQuery(_previousSearchQueryMessage!, _previousQuery!, spatialRestriction: _getRestrictionFromRect());
        break;
      case SearchType.quickSearch:
        // TODO(Sergei): workaround for fast search from searchInThisArea, remove spatialRestriction param when search performance is improved
        quickSearch(_previousQuickSearch!, spatialRestriction: _getRestrictionFromRect());
        break;
    }
  }

  void _updateSearchText(String searchText) {
    final oldState = state;
    state = switch (oldState) {
      SearchStateHistory() => oldState.copyWith(searchText: searchText),
      SearchStateEmpty() => oldState.copyWith(searchText: searchText),
      SearchStateSuggest() => oldState.copyWith(searchText: searchText),
      SearchStateResults() => oldState.copyWith(searchText: searchText),
      SearchStateLoading() => oldState.copyWith(searchText: searchText),
      SearchStateError() => oldState.copyWith(searchText: searchText),
    };
  }

  // TODO(Sergei): remove when search performance is improved (_saRestrictions will be used)
  List<GeoPointMessage>? _getRestrictionFromRect() {
    final rect = ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect;
    if (rect == null) {
      return null;
    }
    const areaExpansion = 0.06;
    return [
      GeoPointMessage(latitude: rect.northEastLat + areaExpansion, longitude: rect.northEastLon + areaExpansion),
      GeoPointMessage(latitude: rect.northEastLat + areaExpansion, longitude: rect.southWestLon - areaExpansion),
      GeoPointMessage(latitude: rect.southWestLat - areaExpansion, longitude: rect.southWestLon - areaExpansion),
      GeoPointMessage(latitude: rect.southWestLat - areaExpansion, longitude: rect.northEastLon + areaExpansion),
    ];
  }
}
