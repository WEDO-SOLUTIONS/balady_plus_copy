import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/debouncer.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/quick_filters/ui/quick_filters.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MapQuickFilters extends ConsumerStatefulWidget {
  final List<FilterItem>? customFilters;
  final void Function(FilterItem)? onCustomTap;
  final bool forMap;

  final double? height;
  final ItemScrollController? itemScrollController;

  const MapQuickFilters({
    super.key,
    this.customFilters,
    this.onCustomTap,
    this.forMap = false,
    this.height,
    this.itemScrollController,
  });

  @override
  ConsumerState<MapQuickFilters> createState() => _MapQuickFiltersState();
}

class _MapQuickFiltersState extends ConsumerState<MapQuickFilters> {
  final _debouncer = Debouncer(milliseconds: 400);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = MapObjectManagerSettings.search();
    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    return QuickFilters(
      height: widget.height,
      itemScrollController: widget.itemScrollController,
      onFavouritesBookmarkTap: () => ref
          .read(authMethodsProvider.notifier)
          .authAndOpen(
            context,
            callback: () async {
              if (!mounted) {
                return;
              }
              Metrics.logEventAdvanced(
                MetricsConstants.exploreKeys.bookmarkIcon,
                action: MetricAction.tap.name,
                group: MetricsConstants.exploreTag,
              );

              ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);
              final isAllowed = await ref.read(locationProvider.notifier).checkLocationPermission();
              if (isAllowed) {
                await context.router.push(const FavoriteListsRoute());
              }
            },
          ),
      onQuickFilterTap: (quickFilter) {
        ref
            .read(urbiAnalyticsProvider)
            .track(
              'quickFilterSearch',
              properties: {
                'filter': quickFilter.name,
              },
            );
        ref.read(appAnalyticsProvider).categorySelected(quickFilter.name);
        ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreSearch);
        final language = ref.read(appLanguageProvider);
        final query = quickFilter.query[language];
        if (query != null) {
          BssService.instance.sendEvent(
            BssRequest(
              eventType: BSSEventType.action,
              actionType: BSSActionType.tap,
              uiElement: const BssUIElement(
                name: BssUIElementNames.searchStart,
                ownerName: BssUIElementNames.searchBar,
              ),
              payload: BssPayload(
                searchRequest: BssSearchRequest(text: query),
              ),
            ),
          );
        }
        context.router.push(SearchRoute(requestFocus: false));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(searchProvider(SearchScopeEnum.map.value).notifier).quickSearch(quickFilter);
        });
      },
      onFavouritesTap: () {
        _debouncer.run(() {
          Metrics.logEventAdvanced(
            MetricsConstants.exploreKeys.bookmarkIcon,
            action: MetricAction.tap.name,
            group: MetricsConstants.exploreTag,
          );

          searchObjectManager.removeAllMarkers();
        });
      },
      customFilters: widget.customFilters,
      onCustomTap: widget.onCustomTap,

      padding: widget.forMap
          ? const EdgeInsets.symmetric(horizontal: Spacing.$3x)
          : const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    );
  }
}
