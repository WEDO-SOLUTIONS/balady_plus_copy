import 'dart:async';
import 'dart:math';

import 'package:async/async.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/app_analytics/app_analytics_repository.dart';
import 'package:mapness/features/app_analytics/datafinder_source_tracker.dart';
import 'package:mapness/features/app_analytics/models/datafinder_mappers.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/balady_analytics/events/search_events.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/shared/constants/advanced_metrics_constants.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/geo_point_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/location.dart';
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

  /// Google search rubric id
  static const googleSearchRubricId = 900913;

  /// The [scope] value for the Routes-tab search (mirror of
  /// `SearchScopeEnum.routes.value`; kept here so the provider layer doesn't
  /// depend on the widget-coupled scope enum). Used to force a `routes` origin.
  static const _routingSearchScope = 'RoutingSearch';

  /// The [scope] values of the surfaces covered by the Phase-1 Balady search
  /// events (mirrors of `SearchScopeEnum.map.value` / `SearchScopeEnum.navi.value`,
  /// kept here for the same reason as [_routingSearchScope]).
  static const _mapSearchScope = 'MapSearch';
  static const _naviSearchScope = 'NaviSearch';
  static const _minVisibleQuickFilterPlaces = 3;
  static const _quickFilterExtraHorizontalPadding = 32.0;
  static const _quickFilterExtraTopPadding = 24.0;
  static const _quickFilterExtraBottomPadding = 140.0;

  SearchType? _previousType;
  SearchResultMessage? _result;
  String? _previousQuery;
  bool _isGoogleSearch = false;
  SearchQueryMessage? _previousSearchQueryMessage;
  QuickFilter? _previousQuickSearch;
  CancelableOperation? _searchOperation;
  SearchRequestLang? _currentQueryLocale;

  // ── DataFinder (ByteDance) correlators ──────────────────────────────────────
  // Client-generated ids per ByteDance's decision (no 2GIS server request id).
  // A new suggestion session starts on each fresh suggest; a new search session
  // on each full search. `_requestId` is regenerated per SDK call.
  String? _suggestionSessionId;
  String? _searchSessionId;
  String _requestId = '';

  /// True when the current search was started by tapping a history record, so
  /// `search_results_exposure` reports `search_type: History`. Reset on the next
  /// fresh (typed/quick/suggest) search.
  bool _searchFromHistory = false;

  /// True when the current search was started by a quick-filter chip that runs
  /// via `searchByText` (the search bottom sheet), so the exposure reports
  /// `search_type: Quick search` to match the top-level quick filters.
  bool _searchFromQuickFilter = false;

  bool get isGoogleSearch => _isGoogleSearch;

  // Timer to start full search if we don't get any results
  // Should be canceled
  Timer? _fullSearchTimer;

  // Debounces fetchSuggest so it doesn't fire on every keystroke while the
  // user is still typing (e.g. entering coordinates digit by digit).
  Timer? _searchQueryDebounce;
  static const _searchQueryDebounceDuration = Duration(milliseconds: 400);

  bool get isSearchRunning => _previousType != null;

  bool get isQuickSearchRunning => _previousType == SearchType.quickSearch;

  bool get searchFromSuggest => _previousType == SearchType.searchByQuery;

  @override
  SearchState build(String scope) {
    // Closing the search sheet disposes this autoDispose notifier while an
    // in-flight suggest / fallback timer may still be pending; cancel them so
    // they can't write `state` on a dead notifier.
    ref.onDispose(() {
      _searchOperation?.cancel();
      _fullSearchTimer?.cancel();
      _fullSearchTimer = null;
    });

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
    _isGoogleSearch = false;
    _result = null;
    _previousSearchQueryMessage = null;
    _previousQuickSearch = null;
    _currentQueryLocale = null;
    _fullSearchTimer?.cancel();
    _fullSearchTimer = null;
    _searchQueryDebounce?.cancel();
    _searchQueryDebounce = null;
    _suggestionSessionId = null;
    _searchSessionId = null;
    _requestId = '';
    _searchFromHistory = false;
    _searchFromQuickFilter = false;
  }

  // ── DataFinder analytics helpers ────────────────────────────────────────────

  /// Shortcut to the analytics service (events fan out to the tools that opted
  /// into the DataFinder capability — today BytePlus only).
  DataFinderAnalyticsRepository get _analytics => ref.read(appAnalyticsProvider);

  /// Resolves the [DataFinderSourcePage] (`event_source`).
  ///
  /// Balady is a single map screen with overlay controllers, so the source is
  /// decided by the **origin** the user entered from (stamped by entry controls
  /// into [DataFinderSourceTracker]) combined with the live navigation state:
  ///  * in turn-by-turn navigation (`PathNavRoute`) → "Direction"
  ///  * editing a drawn route (`RoutingRoutes`/`RouteDetails`) → "Path Changing"
  ///
  /// The search scope refines the origin where it is unambiguous: a search in
  /// the Routes flow is always `routes`; a navigation search is at least
  /// `explore` (never the Explore main page default while navigating).
  DataFinderSourcePage get _sourcePage {
    final inNavigation = _isRouteActive(PathNavRoute.name);
    final pathChanging = _isRouteActive(RoutingRoutesRoute.name) || _isRouteActive(RouteDetailsRoute.name);

    var origin = ref.read(dataFinderSourceTrackerProvider);

    // The Routes search surface is itself the entry control for the Routes
    // flow, so it always resolves to a `routes` origin regardless of any
    // earlier stamp. (NaviSearch keeps the stamped map/explore origin — Map→Go
    // stays Map-Main, Explore→Go becomes Explore-Direction via the nav flags.)
    if (scope == _routingSearchScope) {
      origin = DataFinderOrigin.routes;
    }

    return origin.resolve(inNavigation: inNavigation, pathChanging: pathChanging);
  }

  /// Public accessor so UI-fired events (search box, favourite dialog) can tag
  /// the same `event_source` the notifier computes.
  DataFinderSourcePage get dataFinderEventSource => _sourcePage;

  /// Balady analytics (PostHog): the `source` of the Phase-1 search events for
  /// this scope's surface, or null when the surface is outside the tracking
  /// plan (routing/favourites/feedback searches). The navi search sheet is its
  /// own surface; within the shared map search sheet, a `Map-*` DataFinder
  /// source page means the journey started on the map (POI tap), anything else
  /// is the landing/dashboard entry.
  SearchEventSource? get _baladySearchSource {
    if (scope == _naviSearchScope) {
      return SearchEventSource.navi;
    }
    if (scope != _mapSearchScope) {
      return null;
    }
    return switch (_sourcePage) {
      DataFinderSourcePage.mapMainPage || DataFinderSourcePage.mapDirectionPathChanging => SearchEventSource.map,
      _ => SearchEventSource.landing,
    };
  }

  /// Fires `search_performed` once a full search executed and its results are
  /// known (never for per-keystroke suggests). No-op for surfaces outside the
  /// tracking plan.
  void _trackBaladySearchPerformed(String query, SearchResultMessage results) {
    final source = _baladySearchSource;
    if (source == null) {
      return;
    }
    trackSearchPerformed(query: query, source: source, resultsCount: results.firstPage?.items.length ?? 0);
  }

  /// Marks the next search as originating from a tapped history record, so its
  /// `search_results_exposure` reports `search_type: History`.
  void markSearchFromHistory() => _searchFromHistory = true;

  /// Marks the next `searchByText` as originating from a quick-filter chip (the
  /// search bottom sheet), so its `search_results_exposure` reports
  /// `search_type: Quick search`.
  void markSearchFromQuickFilter() => _searchFromQuickFilter = true;

  /// True if [routeName] is anywhere in the current navigation stack.
  bool _isRouteActive(String routeName) {
    try {
      return ref.read(appRouterProvider).currentSegments.any((s) => s.name == routeName);
    } catch (_) {
      return false;
    }
  }

  /// Current user location, if granted, for distance computation.
  ({double lat, double lon})? get _myLocation {
    final pos = ref.read(locationProvider);
    if (pos == null) {
      return null;
    }
    return (lat: pos.latitude, lon: pos.longitude);
  }

  /// Builds the `search_param` (flat string) from the query, viewport corners,
  /// user location, page size and suggestor type.
  DataFinderSearchParam _buildSearchParam({String? suggestType}) {
    final rect = ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect;
    final loc = _myLocation;
    return DataFinderSearchParam(
      q: _previousQuery,
      viewpoint1: rect == null ? null : (rect.southWestLat, rect.southWestLon),
      viewpoint2: rect == null ? null : (rect.northEastLat, rect.northEastLon),
      suggestType: suggestType,
      pageSize: 20,
      location: loc == null ? null : (loc.lat, loc.lon),
    );
  }

  /// Maps the current search entry type to the spec's `search_type` value.
  DataFinderSearchType get _searchType {
    if (_searchFromHistory) {
      return DataFinderSearchType.history;
    }
    if (_searchFromQuickFilter) {
      return DataFinderSearchType.quickSearch;
    }
    switch (_previousType) {
      case SearchType.quickSearch:
        return DataFinderSearchType.quickSearch;
      case SearchType.searchByQuery:
        return DataFinderSearchType.clickSuggestion;
      case SearchType.searchByText:
      case SearchType.fetchSuggest:
      case null:
        return _isSearchInThisArea ? DataFinderSearchType.searchInThisArea : DataFinderSearchType.manual;
    }
  }

  Future<void> searchQueryChanged(String query) async {
    Metrics.logEvent(
      'SearchQuery',
      object: runtimeType,
      extras: {'value': query},
    );
    _searchQueryDebounce?.cancel();

    if (query.isEmpty) {
      clear();
      return;
    }

    _searchQueryDebounce = Timer(_searchQueryDebounceDuration, () {
      fetchSuggest(query);
    });
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
      _isGoogleSearch = false;
      _previousQuery = query;

      state = SearchStateLoading(searchText: query);

      final searchRect = ref
          .read(dgisControllerProvider.notifier)
          .visibleRectSubject
          .valueOrNull
          ?.visibleRect
          .geoRectMessage();
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
      if (!ref.mounted) {
        return;
      }
      await _searchOperation?.cancel();
      if (!ref.mounted) {
        return;
      }
      if (query.isEmpty) {
        state = const SearchStateHistory();
        return;
      }
      await _setUpLocale(query);
      if (!ref.mounted) {
        return;
      }

      _updateSearchText(query);
      _previousType = SearchType.fetchSuggest;
      _previousQuery = query;
      _isGoogleSearch = false;
      // DataFinder: typing is a fresh (non-history, non-quick) search.
      _searchFromHistory = false;
      _searchFromQuickFilter = false;
      // DataFinder: start a suggestion session on the first keystroke of a query
      // and refresh the request id for this suggest call.
      _suggestionSessionId ??= DataFinderIds.uuid();
      _requestId = DataFinderIds.uuid();
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

      final searchRect = ref
          .read(dgisControllerProvider.notifier)
          .visibleRectSubject
          .valueOrNull
          ?.visibleRect
          .geoRectMessage();
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
      if (!ref.mounted) {
        return;
      }
      // BSA-1931: We need to start full search if we don't get any results
      // and user types more than 2 symbols
      if (result.suggests.isNotEmpty) {
        state = SearchStateSuggest(
          suggest: result,
          searchText: query,
        );
        _reportSuggestionDisplay(result.suggests, query);
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
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider.notifier).trackWithPrint);
      await mixpanel?.track('Search: fetchSuggest');
      // -- Analytics
    } on Exception catch (_) {
      if (ref.mounted) {
        state = SearchStateError(searchText: query);
      }
      rethrow;
    }
    _searchInThisAreaMetric();
  }

  Future<void> quickSearch(
    QuickFilter quickSearch, {
    List<GeoPointMessage>? spatialRestriction,
    bool isGoogle = false,
  }) async {
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
      _previousQuery = searchQuery;
      _isGoogleSearch = isGoogle;
      _searchFromHistory = false;
      _searchFromQuickFilter = false;
      // DataFinder: new search session + request id for this full search.
      _searchSessionId = DataFinderIds.uuid();
      _requestId = DataFinderIds.uuid();
      // DataFinder: quick_search_click with the actual query (matches search_param q=).
      _analytics.quickSearchClick(eventSource: _sourcePage, searchText: searchQuery);
      final searchRect = ref
          .read(dgisControllerProvider.notifier)
          .visibleRectSubject
          .valueOrNull
          ?.visibleRect
          .geoRectMessage();

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
          rubricIds: isGoogle ? [googleSearchRubricId] : null,
          searchRect: searchRect,
          locale: _currentQueryLocale?.localeForMapness,
        ),
      );
      _searchOperation = searchOperation;
      final results = await searchOperation.value;

      await _ensureQuickFilterPlacesAreVisible(results: results);

      // -- Analytics
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider.notifier).trackWithPrint);
      await mixpanel?.track('Search: quickSearch');
      // -- Analytics

      state = (results.firstPage?.items.isEmpty ?? true)
          ? SearchStateEmpty(searchText: searchQuery)
          : await _handleResults(results, searchQuery, markerType: quickSearch.markerType);
      _result = results;
      _trackBaladySearchPerformed(searchQuery, results);
    } on Exception catch (_) {
      state = SearchStateError(searchText: searchQuery);
      rethrow;
    }
    _searchInThisAreaMetric();
  }

  Future<void> searchByText(String query, {bool isGoogle = false}) async {
    try {
      await _searchOperation?.cancel();
      state = SearchStateLoading(searchText: query); // for loading only Suggests use (state is! SearchStateSuggest)
      await _setUpLocale(query);

      _previousType = SearchType.searchByText;
      _previousQuery = query;
      _isGoogleSearch = isGoogle;
      // DataFinder: new search session + request id for this full search.
      _searchSessionId = DataFinderIds.uuid();
      _requestId = DataFinderIds.uuid();
      final searchRect = ref
          .read(dgisControllerProvider.notifier)
          .visibleRectSubject
          .valueOrNull
          ?.visibleRect
          .geoRectMessage();
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
          rubricIds: isGoogle ? [googleSearchRubricId] : null,
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
          : await _handleResults(results, query);

      _result = results;
      _trackBaladySearchPerformed(query, results);
      // -- Analytics
      if (state is SearchStateEmpty) {
        await ref
            .read(urbiAnalyticsProvider.notifier)
            .trackWithPrint('${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.emptySearchResult}');
      }
      await ref
          .read(urbiAnalyticsProvider.notifier)
          .trackWithPrint('${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.searchResult_}');
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider.notifier).trackWithPrint);
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
      _isGoogleSearch = false;
      // DataFinder: new search session + request id for this full search.
      _searchSessionId = DataFinderIds.uuid();
      _requestId = DataFinderIds.uuid();

      final searchRect = ref
          .read(dgisControllerProvider.notifier)
          .visibleRectSubject
          .valueOrNull
          ?.visibleRect
          .geoRectMessage();
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
          : await _handleResults(results, text);
      _result = results;
      _trackBaladySearchPerformed(text, results);
      // -- Analytics
      await AdvancedMetrics.instance.stopSearchResponse(track: ref.read(urbiAnalyticsProvider.notifier).trackWithPrint);
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
    ref
        .read(urbiAnalyticsProvider)
        .track(
          MapnessConstants.analyticsSearchInThisAreaPressed,
          properties: {
            'status': _searchInThisAreaStarted,
          },
        );
    // We need it to track request in logs and look on it.
    // Why do we use print for this: see `Future<void> runMapnessApp`

    logger.log(
      '${AdvancedMetricsConstants.debugConsole}::${MapnessConstants.analyticsSearchInThisAreaPressed}: status $_searchInThisAreaStarted',
    );

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

  /// Search with Google. We put not existing rubric id to search to execute search by Google on the backend side
  /// BSA-2685
  Future<void> alternativeSearch() async {
    final previousQuery = _previousQuery;
    _isGoogleSearch = true;
    if (_previousType == SearchType.searchByText && previousQuery != null) {
      state = SearchStateLoading(searchText: previousQuery);
      await searchByText(previousQuery, isGoogle: true);
    } else if (_previousType == SearchType.quickSearch && _previousQuickSearch != null) {
      state = SearchStateLoading(
        searchText: _previousQuickSearch!.query[ref.read(appLanguageProvider).languageCode] ?? '',
      );
      await quickSearch(_previousQuickSearch!, isGoogle: true);
    }
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
    ref
        .read(urbiAnalyticsProvider)
        .track(
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
      await ref
          .read(cameraPositionProvider.notifier)
          .animateToRepresentativeArea(
            results.representativeArea!,
            options: _quickFilterCameraOptions(),
          );
    }
  }

  Future<void> _ensureQuickFilterPlacesAreVisible({
    required SearchResultMessage results,
  }) async {
    final points = _uniqueResultPoints(results);
    if (points.isEmpty) {
      return;
    }

    final requiredVisiblePlaces = min(_minVisibleQuickFilterPlaces, points.length);
    final visibleRect = ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect;
    final visiblePlacesCount = visibleRect == null
        ? 0
        : points.where((point) => _isInsideVisibleRect(point, visibleRect)).length;

    if (visibleRect != null) {
      if (visiblePlacesCount >= requiredVisiblePlaces) {
        return;
      }
    }

    if (results.representativeArea != null && points.length > 1) {
      await _animateToRepresentativeArea(results: results);
      return;
    }

    await ref
        .read(cameraPositionProvider.notifier)
        .animateToGeoPoints(
          points.take(max(_minVisibleQuickFilterPlaces, visiblePlacesCount)).toList(),
          options: _quickFilterCameraOptions(),
          keepCameraPositionPoint: true,
        );
  }

  List<GeoPointMessage> _uniqueResultPoints(SearchResultMessage results) {
    final markerInfos = results.itemMarkerInfos;
    if (markerInfos == null) {
      return const [];
    }

    final uniquePoints = <GeoPointMessage>[];
    final uniqueCoordinates = <String>{};

    for (final markerInfo in markerInfos) {
      final point = markerInfo.geoPoint.geoPoint;
      final coordinateKey = '${point.latitude}:${point.longitude}';
      if (uniqueCoordinates.add(coordinateKey)) {
        uniquePoints.add(point);
      }
    }

    return uniquePoints;
  }

  bool _isInsideVisibleRect(GeoPointMessage point, VisibleRect visibleRect) =>
      point.latitude <= visibleRect.northEastLat &&
      point.latitude >= visibleRect.southWestLat &&
      point.longitude >= visibleRect.southWestLon &&
      point.longitude <= visibleRect.northEastLon;

  CalcPositionOptionsMessage _quickFilterCameraOptions() {
    final mediaQuery = ref.read(mediaQueryInfoProvider);
    final devicePixelRatio = mediaQuery?.devicePixelRatio ?? 1.0;

    return CalcPositionOptionsMessage(
      screenArea: CameraSetPaddingMessage(
        leftPadding: (devicePixelRatio * ((mediaQuery?.padding.left ?? 0) + _quickFilterExtraHorizontalPadding))
            .toInt(),
        rightPadding: (devicePixelRatio * ((mediaQuery?.padding.right ?? 0) + _quickFilterExtraHorizontalPadding))
            .toInt(),
        topPadding: (devicePixelRatio * ((mediaQuery?.padding.top ?? 0) + _quickFilterExtraTopPadding)).toInt(),
        bottomPadding: (devicePixelRatio * ((mediaQuery?.padding.bottom ?? 0) + _quickFilterExtraBottomPadding))
            .toInt(),
      ),
    );
  }

  Future<void> _setUpLocale(String query) async {
    final currentLang = ref.read(appLanguageProvider).languageCode;
    final localeOfRequest = LanguageDetector.detectLanguageConLocale(query, currentLang);

    if (localeOfRequest != _currentQueryLocale) {
      _currentQueryLocale = localeOfRequest;
    }
  }

  Future<SearchStateResults> _handleResults(
    SearchResultMessage results,
    String searchQuery, {
    MapMarkersType? markerType,
  }) async {
    _reportResultsExposure(results, searchQuery);

    return SearchStateResults(
      results: results,
      searchText: searchQuery,
      markerType: markerType,
    );
  }

  /// Fires `search_results_click` when the user taps a search result. Called by
  /// the results UI, which already knows the tapped [item] and its [rank].
  void reportSearchResultsClick({
    required DirectoryObjectMessage item,
    required int rank,
    DataFinderClickAction clickAction = DataFinderClickAction.viewPoiDetails,
  }) {
    if (_baladySearchSource != null) {
      trackSearchResultSelected(query: _previousQuery ?? '', rank: rank, resultType: searchResultTypeOf(item));
    }
    final loc = _myLocation;
    _analytics.searchResultsClick(
      eventSource: _sourcePage,
      requestId: _requestId,
      sessionId: _searchSessionId ??= DataFinderIds.uuid(),
      searchText: _previousQuery ?? '',
      clickAction: clickAction,
      poi: item.toDataFinderPoi(rank: rank, myLat: loc?.lat, myLon: loc?.lon),
    );
  }

  /// Fires `suggestion_click` when the user taps a suggestion. Called by the
  /// suggest UI, which knows the tapped [suggest] and its [rank].
  void reportSuggestionClick({required SuggestMessage suggest, required int rank}) {
    final suggestResultType = suggestResultTypeOf(suggest);
    if (_baladySearchSource != null && suggestResultType != null) {
      trackSearchResultSelected(query: _previousQuery ?? '', rank: rank, resultType: suggestResultType);
    }
    final loc = _myLocation;
    _analytics.suggestionClick(
      eventSource: _sourcePage,
      requestId: _requestId,
      sessionId: _suggestionSessionId ??= DataFinderIds.uuid(),
      searchText: _previousQuery ?? '',
      suggestionType: suggest.dataFinderSuggestionType,
      poi: suggest.toDataFinderPoi(rank: rank, myLat: loc?.lat, myLon: loc?.lon),
    );
  }

  /// Fires `suggestion_exposure` once per suggest response (list-level). Only
  /// the suggestions actually returned are reported.
  void _reportSuggestionDisplay(List<SuggestMessage> suggests, String searchQuery) {
    if (suggests.isEmpty) {
      return;
    }
    final loc = _myLocation;
    final pois = [
      for (var i = 0; i < suggests.length; i++)
        suggests[i].toDataFinderPoi(rank: i + 1, myLat: loc?.lat, myLon: loc?.lon),
    ];
    _analytics.suggestionExposure(
      requestId: _requestId,
      sessionId: _suggestionSessionId ??= DataFinderIds.uuid(),
      searchText: searchQuery,
      // suggest_type = the suggestor mode used by fetchSuggest (default object).
      searchParam: _buildSearchParam(suggestType: 'object'),
      pois: pois,
    );
  }

  /// Fires `search_results_exposure` for the FIRST result page. Subsequent pages
  /// (infinite scroll) are reported via [reportResultsPageExposure].
  void _reportResultsExposure(SearchResultMessage results, String searchQuery) {
    final items = results.firstPage?.items ?? const <DirectoryObjectMessage>[];
    // Remember the query so paginated pages report the same search_text.
    _exposureSearchText = searchQuery;
    _exposedResultsCount = 0;
    _reportResultsPage(items.whereType<DirectoryObjectMessage>().toList());
  }

  /// Fires `search_results_exposure` for a newly-loaded page of results
  /// (infinite scroll / pagination). Ranks continue from the previous pages
  /// (page-2 item-1 → rank 21, etc.) and the same request_id/search_session_id
  /// are reused so the dashboard groups all pages under one search. Called from
  /// the results UI after `SearchPagination.fetchNext()` loads more items.
  void reportResultsPageExposure(List<DirectoryObjectMessage> newItems) {
    _reportResultsPage(newItems);
  }

  /// Running count of result items already reported for the current search, so
  /// pagination ranks continue correctly across pages.
  int _exposedResultsCount = 0;

  /// The query of the current search, reused for paginated page exposures.
  String _exposureSearchText = '';

  void _reportResultsPage(List<DirectoryObjectMessage> items) {
    if (items.isEmpty) {
      return;
    }
    final loc = _myLocation;
    final base = _exposedResultsCount;
    final pois = [
      for (var i = 0; i < items.length; i++)
        items[i].toDataFinderPoi(rank: base + i + 1, myLat: loc?.lat, myLon: loc?.lon),
    ];
    _exposedResultsCount += items.length;
    _analytics.searchResultsExposure(
      eventSource: _sourcePage,
      requestId: _requestId,
      sessionId: _searchSessionId ??= DataFinderIds.uuid(),
      searchText: _exposureSearchText,
      searchType: _searchType,
      searchParam: _buildSearchParam(),
      pois: pois,
    );
  }
}
