import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/discover/discover.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/trending/trending.dart';
import 'package:mapness/pages/map_search/ui/map_lost_internet.dart';
import 'package:mapness/pages/map_search/ui/map_search_empty.dart';
import 'package:mapness/pages/map_search/ui/map_search_history.dart';
import 'package:mapness/pages/map_search/ui/map_search_results.dart';
import 'package:mapness/pages/map_search/ui/map_suggest_list.dart';
import 'package:mapness/shared/constants/metrics_constants.dart' as metric_const;
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/search_type_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:mapness/widgets/navi_search/navi_find_in_fav.dart';
import 'package:mapness/widgets/navi_search/navi_quick_filter.dart';
import 'package:mapness/widgets/search/ui/search_discover.dart';
import 'package:mapness/widgets/search/ui/search_trending.dart';
import 'package:provider/provider.dart';

class MapSearchContent extends ConsumerStatefulWidget {
  final ScrollController bottomSheetContentScrollController;
  final bool showMoreQuickFilters;
  final ValueChanged<bool>? onMoreQuickFiltersChanged;

  const MapSearchContent({
    required this.bottomSheetContentScrollController,
    this.showMoreQuickFilters = false,
    this.onMoreQuickFiltersChanged,
    super.key,
  });

  @override
  ConsumerState<MapSearchContent> createState() => _MapSearchContentState();

  static void scrollSendEvent({
    required SearchState searchState,
    required int historyListSize,
    required void Function(BssRequest) sendEvent,
  }) {
    final BssRequest? request = switch (searchState) {
      SearchStateHistory() => BssRequest(
        eventType: BSSEventType.action,
        actionType: BSSActionType.scroll,
        uiElement: const BssUIElement(
          name: BssUIElementNames.historyList,
          ownerName: BssUIElementNames.directorySearchScreen,
        ),
        payload: BssPayload(
          searchRequest: BssSearchRequest(text: searchState.searchText),
          historyList: BssHistoryList(
            size: historyListSize,
          ),
        ),
      ),
      SearchStateError() => null,
      SearchStateEmpty() => null,
      SearchStateLoading() => null,
      SearchStateSuggest() => BssRequest(
        eventType: BSSEventType.action,
        actionType: BSSActionType.scroll,
        uiElement: const BssUIElement(
          name: BssUIElementNames.suggestList,
          ownerName: BssUIElementNames.directorySearchScreen,
        ),
        payload: BssPayload(
          searchRequest: BssSearchRequest(text: searchState.searchText),
          suggestList: BssSuggestList(
            size: searchState.suggest.suggests.length,
          ),
        ),
      ),
      SearchStateResults() => BssRequest(
        eventType: BSSEventType.action,
        actionType: BSSActionType.scroll,
        uiElement: const BssUIElement(
          name: BssUIElementNames.searchResultList,
          ownerName: BssUIElementNames.directorySearchScreen,
        ),
        payload: BssPayload(
          searchRequest: BssSearchRequest(text: searchState.searchText),
          searchResultList: BssSearchResultList(
            size: searchState.results.itemMarkerInfos?.length ?? 0,
            searchType: searchState.results.searchResultType.toBss(),
            firstResultClass: searchState.results.searchResultType.toBss(),
          ),
        ),
      ),
    };
    if (request != null) {
      sendEvent(request);
    }
  }
}

class _MapSearchContentState extends ConsumerState<MapSearchContent> {
  bool _hasConnection = true;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        BssService.instance.sendEvent(
          const BssRequest(
            eventType: BSSEventType.view,
            uiElement: BssUIElement(
              name: BssUIElementNames.directorySearchScreen,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateInternetStatus(BuildContext context, bool hasConnection) {
    if (context.mounted) {
      // If the [hasConnection] value has changed we rebuild widget with `setState`
      // Otherwise we do nothing
      if (hasConnection != _hasConnection) {
        setState(() {
          _hasConnection = hasConnection;
        });
      }
    }
  }

  void _debouncedUpdate(BuildContext context, bool hasConnection) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _updateInternetStatus(context, hasConnection);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    _hasConnection = ref.watch(networkStatusProvider);
    final scope = context.read<SearchScope>();
    final searchState = ref.watch(searchProvider(scope.value));
    ref
      ..listen(searchProvider(scope.value), (_oldState, newState) {
        if (newState.runtimeType != _oldState.runtimeType) {
          if (newState is SearchStateResults) {
            BssService.instance.sendEvent(
              BssRequest(
                eventType: BSSEventType.view,
                uiElement: const BssUIElement(
                  name: BssUIElementNames.searchResultList,
                  ownerName: BssUIElementNames.directorySearchScreen,
                ),
                payload: BssPayload(
                  searchRequest: BssSearchRequest(text: newState.searchText),
                  searchResultList: BssSearchResultList(
                    size: newState.results.itemMarkerInfos?.length ?? newState.results.firstPage?.items.length ?? 0,
                    searchType: newState.results.searchResultType.toBss(),
                    firstResultClass: newState.results.searchResultType.toBss(),
                  ),
                ),
              ),
            );
          } else if (newState is SearchStateEmpty) {
            BssService.instance.sendEvent(
              const BssRequest(
                eventType: BSSEventType.view,
                uiElement: BssUIElement(
                  name: BssUIElementNames.searchResultList,
                  ownerName: BssUIElementNames.directorySearchScreen,
                ),
                payload: BssPayload(
                  searchResultList: BssSearchResultList(size: 0),
                ),
              ),
            );
            ref
                .read(urbiAnalyticsProvider)
                .track(
                  'searchFailed',
                  properties: {
                    'text': newState.searchText,
                  },
                );
          } else if (newState is SearchStateHistory) {
            final history = ref.read(searchHistoryProvider(scope.value));
            BssService.instance.sendEvent(
              BssRequest(
                eventType: BSSEventType.view,
                uiElement: const BssUIElement(
                  name: BssUIElementNames.historyList,
                  ownerName: BssUIElementNames.directorySearchScreen,
                ),
                payload: BssPayload(
                  historyList: BssHistoryList(size: history.length),
                ),
              ),
            );
          } else if (newState is SearchStateSuggest) {
            BssService.instance.sendEvent(
              BssRequest(
                eventType: BSSEventType.view,
                uiElement: const BssUIElement(
                  name: BssUIElementNames.suggestList,
                  ownerName: BssUIElementNames.directorySearchScreen,
                ),
                payload: BssPayload(
                  searchRequest: BssSearchRequest(text: newState.searchText),
                  suggestList: BssSuggestList(size: newState.suggest.suggests.length),
                ),
              ),
            );
          }
        }
      })
      ..listen(
        networkStatusProvider,
        (_, hasConnection) {
          _debouncedUpdate(context, hasConnection);
        },
      );

    if (!_hasConnection) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MapLostInternet(
            onTap: () async {
              await ref.read(networkStatusProvider.notifier).update();
              _updateInternetStatus(context, ref.read(networkStatusProvider));
            },
          ),
        ),
      );
    }

    return searchState.map(
      empty: () => const SafeArea(
        top: false,
        child: MapSearchEmpty(),
      ),
      history: () {
        final favourites = ref.watch(favouriteCacheProvider);
        final hasFavourites = favourites.hasValue && favourites.requireValue.items.isNotEmpty;

        final history = ref.watch(searchHistoryProvider(scope.value));
        final shouldShowHistoryAndFavorites = !widget.showMoreQuickFilters;
        final discoverItems = ref.watch(discoverProvider).value ?? [];
        final trendingItems = ref.watch(trendingProvider).value ?? [];

        return SafeArea(
          top: false,
          child: Column(
            children: [
              NaviQuickFilter(
                showMoreView: widget.showMoreQuickFilters,
                onMoreTap: () => widget.onMoreQuickFiltersChanged?.call(true),
                onFilterSelected: (q) {
                  widget.onMoreQuickFiltersChanged?.call(false);
                  final searcher = ref.read(searchProvider(scope.value).notifier);
                  // DataFinder: quick-filter chip tap from the search bottom
                  // sheet. The top-level chips fire this inside quickSearch();
                  // this path runs via searchByText(), so fire `quick_search_click`
                  // here and flag the search so its exposure reports
                  // `search_type: Quick search`.
                  ref.read(appAnalyticsProvider).quickSearchClick(
                        eventSource: searcher.dataFinderEventSource,
                        searchText: q,
                      );
                  searcher
                    ..markSearchFromQuickFilter()
                    ..searchByText(q);
                  ref
                      .read(urbiAnalyticsProvider)
                      .track(
                        '${metric_const.MetricsConstants.searchTag}::${metric_const.MetricsConstants.searchKeys.searchButtonPressed}',
                      );
                  ref
                      .read(searchHistoryProvider(scope.value).notifier)
                      .put(SearchHistoryItem.fromQuery(query: q).toMessage());
                },
              ),
              if (shouldShowHistoryAndFavorites && hasFavourites)
                Padding(
                  padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
                  child: const NaviFindInFav(),
                ),
              if (shouldShowHistoryAndFavorites && history.isEmpty) const SizedBox(height: Spacing.$4x),
              if (shouldShowHistoryAndFavorites) const MapSearchHistory(),
              if (discoverItems.isNotEmpty) ...[
                const SizedBox(height: Spacing.$4x),
                SearchDiscover(
                  discoverItems: discoverItems,
                  onItemTap: ref.read(searchProvider(scope.value).notifier).fetchSuggest,
                ),
              ],
              if (trendingItems.isNotEmpty) ...[
                const SizedBox(height: Spacing.$4x),
                SearchTrending(
                  items: trendingItems,
                  onItemTap: (item) {
                    context.router.replaceOrPush(
                      route: PoiCardWidgetRoute(objectId: item.object.id),
                      toCompareRoutes: [PoiCardWidgetRoute.page],
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
      loading: () => SizedBox(
        height: height * .4,
        child: const Center(
          child: Loading(
            orientation: Axis.vertical,
            size: LoaderSize.large,
          ),
        ),
      ),
      suggest: (suggest) => SafeArea(
        top: false,
        child: MapSuggestList(
          suggest: suggest,
        ),
      ),
      results: (results) => SafeArea(
        top: false,
        child: MapSearchResults(
          results: results,
          bottomSheetContentScrollController: widget.bottomSheetContentScrollController,
        ),
      ),
      failure: (query, errorMessage) => BaseErrorWidget(
        errorLabel: errorMessage,
        onRetry: () {
          ref.read(searchProvider(scope.value).notifier).searchByText(query);
        },
      ),
    );
  }
}
