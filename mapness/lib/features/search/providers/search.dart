import 'dart:async';

import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/utils/language_detector.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
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
  /// Keys to detect properties in analytics
  static const _searchInThisAreaStarted = 'search_started';
  static const _searchInThisAreaSuccess = 'finished_with_success';
  static const _searchInThisAreaError = 'finished_with_error';

  /// Search area limit
  static final _saRestrictions = [
    GeoPointMessage(latitude: 32.568765, longitude: 56.694472),
    GeoPointMessage(latitude: 32.568765, longitude: 32.61185),
    GeoPointMessage(latitude: 15.506104, longitude: 32.61185),
    GeoPointMessage(latitude: 15.506104, longitude: 56.694472),
  ];

  SearchType? _previousType;
  SearchResultMessage? _result;
  String? _previousQuery;
  SearchQueryMessage? _previousSearchQueryMessage;
  QuickFilter? _previousQuickSearch;
  CancelableOperation? _searchOperation;
  SearchRequestLang? _currentQueryLocale;

  // Timer to start full search if we don't get any results
  // Should be canceled
  Timer? _fullSearchTimer;

  bool get isSearchRunning => _previousType != null;

  bool get isQuickSearchRunning => _previousType == SearchType.quickSearch;
  bool get searchFromSuggest => _previousType == SearchType.searchByQuery;

  @override
  SearchState build(String scope) {
    if (_result != null && _previousQuery != null) {
      return SearchStateResults(results: _result!, searchText: _previousQuery!);
    }

    return SearchStateHistory(searchText: _previousQuery ?? '');
  }

  void clear() {
    _searchOperation?.cancel();
    state = const SearchStateHistory();
    _previousType = null;
    _previousQuery = null;
    _result = null;
    _previousSearchQueryMessage = null;
    _previousQuickSearch = null;
    _currentQueryLocale = null;
    _fullSearchTimer?.cancel();
    _fullSearchTimer = null;
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

  Future<void> searchAddress(String query) async {
    try {
      await _searchOperation?.cancel();
      if (query.isEmpty) {
        state = const SearchStateHistory();
        return;
      }
      await _setUpLocale(query);

      _updateSearchText(query);
      _previousType = SearchType.fetchSuggest;
      _previousQuery = query;

      state = SearchStateLoading(searchText: query);

      final searchRect =
          ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect.geoRectMessage();
      final dgisController = await ref.read(dgisControllerProvider.future);

      final searchOperation = CancelableOperation.fromFuture(
        dgisController.fetchSuggest(
          query,
          searchRect: searchRect,
          locale: _currentQueryLocale?.localeForMapness,
          suggestorType: SuggestorTypeEnum.address,
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
    } on Exception catch (_) {
      state = SearchStateError(searchText: query);
      rethrow;
    }
  }

  Future<void> fetchSuggest(String query) async {
    try {
      await _searchOperation?.cancel();
      if (query.isEmpty) {
        state = const SearchStateHistory();
        return;
      }
      await _setUpLocale(query);

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

      final searchRect =
          ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect.geoRectMessage();
      final dgisController = await ref.read(dgisControllerProvider.future);

      final searchOperation = CancelableOperation.fromFuture(
        dgisController.fetchSuggest(
          query,
          searchRect: searchRect,
          locale: _currentQueryLocale?.localeForMapness,
        ),
      );
      _searchOperation = searchOperation;
      final result = await searchOperation.value;
      // BSA-1931: We need to start full search if we don't get any results
      // and user types more than 2 symbols
      if (result.suggests.isNotEmpty) {
        state = SearchStateSuggest(
          suggest: result,
          searchText: query,
        );
      } else if (query.length > 2) {
        await ref
            .read(urbiAnalyticsProvider.notifier)
            .trackWithPrint('${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.emptySuggestResult}');

        _fullSearchTimer?.cancel();
        _fullSearchTimer = Timer(
          const Duration(seconds: 1),
          () {
            searchByText(query);
          },
        );
      }
      // -- Analytics
      await ref
          .read(urbiAnalyticsProvider.notifier)
          .trackWithPrint('${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.suggestResult}');
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider).track);
      await mixpanel?.track('Search: fetchSuggest');
      // -- Analytics
    } on Exception catch (_) {
      state = SearchStateError(searchText: query);
      rethrow;
    }
    _searchInThisAreaMetric();
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
      await _setUpLocale(searchQuery);

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
          // TODO(Sergei): revert value to _saRestrictions when search performance is improved
          spatialRestriction: spatialRestriction ?? _saRestrictions,
          searchRect: searchRect,
          locale: _currentQueryLocale?.localeForMapness,
        ),
      );
      _searchOperation = searchOperation;
      final results = await searchOperation.value;

      await _animateToRepresentativeArea(results: results);

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
      _result = results;
    } on Exception catch (_) {
      state = SearchStateError(searchText: searchQuery);
      rethrow;
    }
    _searchInThisAreaMetric();
  }

  Future<void> searchByText(String query) async {
    try {
      await _searchOperation?.cancel();
      if (state is! SearchStateSuggest) {
        state = SearchStateLoading(searchText: query);
      }
      await _setUpLocale(query);

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
          // TODO(Sergei): revert value to _saRestrictions when search performance is improved
          // TODO(Dmitrii): Search improved but we have to test it more so we could return `_getRestrictionFromRect()` here
          spatialRestriction: _saRestrictions,
          searchRect: searchRect,
          locale: _currentQueryLocale?.localeForMapness,
        ),
      );
      _searchOperation = searchOperation;
      final results = await searchOperation.value;

      final zoom = ref.watch(cameraPositionProvider)?.zoom ?? 0;
      if (zoom > 13 && state is! SearchStateSuggest) {
        await _animateToRepresentativeArea(results: results);
      }

      state = (results.firstPage?.items.isEmpty ?? true)
          ? SearchStateEmpty(searchText: query)
          : SearchStateResults(
              results: results,
              searchText: query,
            );

      _result = results;
      // -- Analytics
      if (state is SearchStateEmpty) {
        await ref
            .read(urbiAnalyticsProvider.notifier)
            .trackWithPrint('${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.emptySearchResult}');
      }
      await ref
          .read(urbiAnalyticsProvider.notifier)
          .trackWithPrint('${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.searchResult_}');
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider).track);
      await mixpanel?.track('Search: searchByText');
      // -- Analytics
    } on Exception catch (_) {
      state = SearchStateError(searchText: query);
      rethrow;
    }
    _searchInThisAreaMetric();
  }

  // We use this method to search after press on category in suggester. So to determine
  // if press on the card was made from suggest (not from search / history), we use
  // `_previousType` variable. If it was `searchByQuery`, we know that user pressed on suggest category
  // and then pressed on the search result
  Future<void> searchByQuery(SearchQueryMessage query, String text, {List<GeoPointMessage>? spatialRestriction}) async {
    try {
      await _searchOperation?.cancel();
      state = SearchStateLoading(searchText: text);
      await _setUpLocale(text);

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
          // TODO(Sergei): revert value to _saRestrictions when search performance is improved
          spatialRestriction: spatialRestriction ?? _saRestrictions,
          searchRect: searchRect,
          locale: _currentQueryLocale?.localeForMapness,
        ),
      );
      _searchOperation = searchOperation;
      final results = await searchOperation.value;

      await _animateToRepresentativeArea(results: results);

      state = (results.firstPage?.items.isEmpty ?? true)
          ? SearchStateEmpty(searchText: text)
          : SearchStateResults(
              results: results,
              searchText: text,
            );
      _result = results;
      // -- Analytics
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider).track);
      await mixpanel?.track('Search: searchByQuery');
      // -- Analytics
    } on Exception catch (_) {
      state = SearchStateError(searchText: text);
      rethrow;
    }
    _searchInThisAreaMetric();
  }

  /// Flag that indicates that search was started from searchInThisArea button
  bool _isSearchInThisArea = false;

  /// Method that starts search in the visible area
  void searchInThisArea(String scope) {
    _isSearchInThisArea = true;
    ref.read(urbiAnalyticsProvider).track(
      MapnessConstants.analyticsSearchInThisAreaPressed,
      properties: {
        'status': _searchInThisAreaStarted,
      },
    );
    // We need it to track request in logs and look on it.
    // Why do we use print for this: see `Future<void> runMapnessApp`

    logger.log(
        '${AdvancedMetricsConstants.debugConsole}::${MapnessConstants.analyticsSearchInThisAreaPressed}: status $_searchInThisAreaStarted');

    ref.read(searchInRectProvider(scope).notifier).searchInThisAreaSwitch(value: true);
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

  Future<void> searchMore(String query) async {
    state = SearchStateLoading(searchText: query);
    await searchByText(query);
  }

  /// Here we send additional metrics because we want to know
  /// a) How many requests finished with success
  /// b) How many request finished with error
  /// c) How many requests was made and didn't finished ((finished_with_success + finished_with_error) / search_started)
  void _searchInThisAreaMetric() {
    if (!_isSearchInThisArea) {
      return;
    }

    _isSearchInThisArea = false;
    final isSuccess = state is! SearchStateError;
    final status = isSuccess ? _searchInThisAreaSuccess : _searchInThisAreaError;
    ref.read(urbiAnalyticsProvider).track(
      MapnessConstants.analyticsSearchInThisAreaPressed,
      properties: {
        'status': status,
      },
    );
    // We need it to track request in logs and look on it.
    logger.log(
      '${AdvancedMetricsConstants.debugConsole}::${MapnessConstants.analyticsSearchInThisAreaPressed}: status $status',
    );
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

  Future<void> _animateToRepresentativeArea({
    required SearchResultMessage results,
  }) async {
    if (results.representativeArea != null) {
      final _mediaQuery = ref.read(mediaQueryInfoProvider);
      final devicePixelRatio = _mediaQuery?.devicePixelRatio ?? 1.0;
      await ref.read(cameraPositionProvider.notifier).animateToRepresentativeArea(
            results.representativeArea!,
            options: CalcPositionOptionsMessage(
              screenArea: CameraSetPaddingMessage(
                leftPadding: (devicePixelRatio * (_mediaQuery?.padding.left ?? 0)).toInt(),
                rightPadding: (devicePixelRatio * (_mediaQuery?.padding.right ?? 0)).toInt(),
                topPadding: (devicePixelRatio * (_mediaQuery?.padding.top ?? 0)).toInt(),
                bottomPadding: (devicePixelRatio * (_mediaQuery?.padding.bottom ?? 0)).toInt(),
              ),
            ),
          );
    }
  }

  Future<void> _setUpLocale(String query) async {
    final currentLang = ref.read(appLanguageProvider).languageCode;
    final localeOfRequest = LanguageDetector.detectLanguageConLocale(query, currentLang);

    if (localeOfRequest != _currentQueryLocale) {
      _currentQueryLocale = localeOfRequest;
    }
  }
}
