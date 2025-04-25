import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/landing/quick_filter_request_source_screen.dart';
import 'package:mapness/features/landing/search_by_rubrics.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/widgets/landing/map_quick_filters.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TickerProvider _vsync;

  static const headerHeight = 24.0;

  DashboardHeaderDelegate({required TickerProvider vsync}) : _vsync = vsync;

  @override
  TickerProvider? get vsync => _vsync;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    const heightOfQuickFilters = QuickFilters.defaultHeight + Spacing.$4x;
    final currentHeaderExtent = minExtent + max(0.0, heightOfQuickFilters - shrinkOffset);

    return FlexibleSpaceBar.createSettings(
      minExtent: minExtent,
      maxExtent: maxExtent,
      currentExtent: currentHeaderExtent,
      child: _DashboardMenu(
        shrinkOffset: shrinkOffset,
      ),
    );
  }

  @override
  double get maxExtent => headerHeight + QuickFilters.defaultHeight;

  @override
  double get minExtent => headerHeight - Spacing.$4x - Spacing.$2x;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => FloatingHeaderSnapConfiguration();

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _DashboardMenu extends ConsumerWidget {
  final double shrinkOffset;

  const _DashboardMenu({required this.shrinkOffset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const heightOfQuickFilters = QuickFilters.defaultHeight + Spacing.$2x * 2;
    final remainingSpaceForQuickFilters = max(0.0, heightOfQuickFilters - shrinkOffset);
    final quickFilterSizeProportion = remainingSpaceForQuickFilters / heightOfQuickFilters;

    return ColoredBox(
      color: context.colorsV2.backgroundSurface2,
      child: ClipRect(
        clipBehavior: Clip.antiAlias,
        child: Opacity(
          opacity: quickFilterSizeProportion,
          child: SizedOverflowBox(
            size: Size(
              double.infinity,
              remainingSpaceForQuickFilters,
            ),
            child: SizedBox(
              height: QuickFilters.defaultHeight,
              child: MapQuickFilters(
                id: QuickFilterScreen.dashboard,
                customFilters: [
                  FilterItemConfig(
                    filterType: FilterType.custom,
                    title: context.l10n.go,
                    icon: 'assets/icons/svg/quick_filters/free_roam.svg',
                    onTap: () {
                      ref.read(locationProvider.notifier).checkLocationPermission();
                      ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);
                      context.router.push(const FreeRoamRoute());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.colorsV2.backgroundSurface2),
        child: Padding(
          padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$2x),
          child: GestureDetector(
            onTap: () {
              Metrics.logEventAdvanced(
                MetricsConstants.exploreKeys.searchField,
                action: MetricAction.tap.name,
                group: MetricsConstants.exploreTag,
              );

              ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreSearch);

              ref.read(searchByRubricsQueryProvider.notifier).update(null);
              // Here we clean the search query on tap on the search field
              // So the user can see the search history, not previous search results
              ref.read(searchProvider(SearchScopeEnum.map.value).notifier).clear();

              ref.read(urbiAnalyticsProvider).track(
                    '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.uniqueSearchInitialized}',
                  );
              context.router.push(SearchRoute(expansion: Expansion.expanded));
            },
            child: AbsorbPointer(
              child: BaladyTextInput.search(
                inputState: BaladyInputState.readOnly,
                config: BaladyInputConfig(
                  hintText: context.l10n.searchPlaceOrAddress,
                  fillColor: context.colorsV2.neutralContainerDefault,
                  hintColor: context.colorsV2.foregroundSoft,
                  textStyle: context.textStyleV3.bodySmallRegular,
                ),
              ),
            ),
          ),
        ),
      );
}
