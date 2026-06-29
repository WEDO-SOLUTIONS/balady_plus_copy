import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/city_by_location/city_by_location.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/pages/map_search/ui/map_lost_internet.dart';
import 'package:mapness/pages/map_search/ui/map_search_empty.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_history.dart';
import 'package:mapness/pages/navi_search/ui/navi_search_results.dart';
import 'package:mapness/pages/navi_search/ui/navi_suggest_list.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:mapness/widgets/navi_search/navi_quick_filter.dart';
import 'package:provider/provider.dart';

class NaviSearchContent extends ConsumerStatefulWidget {
  final ScrollController bottomSheetContentScrollController;
  final bool showMoreQuickFilters;
  final ValueChanged<bool>? onMoreQuickFiltersChanged;

  const NaviSearchContent({
    required this.bottomSheetContentScrollController,
    this.showMoreQuickFilters = false,
    this.onMoreQuickFiltersChanged,
    super.key,
  });

  @override
  ConsumerState<NaviSearchContent> createState() => _MapSearchContentState();
}

class _MapSearchContentState extends ConsumerState<NaviSearchContent> {
  bool _hasConnection = true;
  Timer? _debounceTimer;

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

  void _sendNavigationEvent({required String searchText, required bool isResultsFound, required int resultCount}) {
    final city = ref.read(cityByLocationProvider);
    ref
        .read(appAnalyticsProvider)
        .navigationSearch(
          destinationCity: city.value?.name ?? '',
          keyword: searchText,
          originCity: city.value?.name ?? '',
          isResultsFound: isResultsFound,
          resultCount: resultCount,
        );
  }

  @override
  Widget build(BuildContext context) {
    _hasConnection = ref.watch(networkStatusProvider);
    final scope = context.read<SearchScope>();
    final searchState = ref.watch(searchProvider(scope.value));
    ref
      ..listen(searchProvider(scope.value), (_oldState, newState) {
        if (newState is SearchStateEmpty) {
          ref.read(urbiAnalyticsProvider).track('searchFailed', properties: {'text': newState.searchText});
        } else if (newState is SearchStateResults) {
          _sendNavigationEvent(
            searchText: newState.searchText,
            isResultsFound: newState.results.firstPage?.items.isNotEmpty ?? false,
            resultCount: newState.results.firstPage?.items.length ?? 0,
          );
        } else if (newState is SearchStateSuggest) {
          _sendNavigationEvent(
            searchText: newState.searchText,
            isResultsFound: newState.suggest.suggests.isNotEmpty,
            resultCount: newState.suggest.suggests.length,
          );
        }
      })
      ..listen(networkStatusProvider, (_, hasConnection) {
        _debouncedUpdate(context, hasConnection);
      });

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
      empty: () => const SafeArea(top: false, child: MapSearchEmpty()),
      history: () => SafeArea(
        top: false,
        child: Column(
          children: [
            NaviQuickFilter(
              showMoreView: widget.showMoreQuickFilters,
              onMoreTap: () => widget.onMoreQuickFiltersChanged?.call(true),
              onFilterSelected: (q) {
                widget.onMoreQuickFiltersChanged?.call(false);
                ref.read(searchProvider(scope.value).notifier).searchByText(q);
              },
            ),
            if (!widget.showMoreQuickFilters) ...[
              const SizedBox(height: Spacing.$4x),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                child: ContentWrapper(
                  color: context.colors.backgroundSurface1,
                  children: [
                    ContentRow(
                      isDividerEnabled: true,
                      leading: Icon(GeneralIcons.location, color: context.colors.accentDefault),
                      text: ContentRowTextOptions(title: context.l10n.selectOnTheMap),
                      trailing: ContentRowTextTrailingOptions(
                        icon: SystemIcons.arrowCornerRightSmall,
                        iconColor: context.colors.foregroundMuted,
                      ),
                      onTap: () => _specifyOnTheMap(context),
                    ),
                    ContentRow(
                      isDividerEnabled: true,
                      leading: Icon(
                        Directionality.of(context) == TextDirection.ltr
                            ? TransportIcons.locationLTR
                            : TransportIcons.locationRTL,
                        color: context.colors.accentDefault,
                        size: 22,
                      ),
                      text: ContentRowTextOptions(title: context.l10n.yourLocation),
                      trailing: ContentRowTextTrailingOptions(
                        icon: SystemIcons.arrowCornerRightSmall,
                        iconColor: context.colors.foregroundMuted,
                      ),
                      onTap: () => _onYourLocationTap(context, ref),
                    ),
                    ContentRow(
                      leading: Icon(SystemIcons.bookmark, color: context.colors.accentDefault),
                      text: ContentRowTextOptions(title: context.l10n.findInFav),
                      trailing: ContentRowTextTrailingOptions(
                        icon: SystemIcons.arrowCornerRightSmall,
                        iconColor: context.colors.foregroundMuted,
                      ),
                      onTap: () => ref
                          .read(authMethodsProvider.notifier)
                          .authAndOpen(context, callback: () => context.router.push(const NaviFavoritesRoute())),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.$3x),
              const NaviSearchHistory(),
            ],
          ],
        ),
      ),
      loading: () => SizedBox(
        height: MediaQuery.sizeOf(context).height * .8,
        child: SafeArea(
          top: false,
          child: Center(
            child: Loading(orientation: Axis.vertical, size: LoaderSize.large, title: context.l10n.loading),
          ),
        ),
      ),
      suggest: (suggest) => NaviSuggestList(suggest: suggest),
      results: (results) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: Spacing.$4x),
          child: NaviSearchResults(
            results: results,
            bottomSheetContentScrollController: widget.bottomSheetContentScrollController,
          ),
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

  Future<void> _specifyOnTheMap(BuildContext context) async {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    await context.router.push(const RoutingMapSelectRoute());
  }

  Future<void> _onYourLocationTap(BuildContext context, WidgetRef ref) async {
    final location = ref.read(locationProvider);
    if (location == null) {
      return;
    }

    final dgisController = await ref.read(dgisControllerProvider.future);
    await dgisController.setCameraPosition(
      CameraPositionMessage(
        point: GeoPointMessage(latitude: location.latitude, longitude: location.longitude),
        zoom: 16,
        tilt: 0,
        bearing: 0,
      ),
    );
    if (context.mounted) {
      context.router.pop();
    }
  }
}
