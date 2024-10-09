import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/map_quick_filters.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/free_roam.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TickerProvider _vsync;

  static const headerHeight = 72.0;

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
  double get maxExtent => headerHeight;

  @override
  double get minExtent => headerHeight - Spacing.$4x - QuickFilters.defaultHeight - Spacing.$2x;

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
    const heightOfQuickFilters = QuickFilters.defaultHeight + Spacing.$4x * 2;
    final remainingSpaceForQuickFilters = max(0.0, heightOfQuickFilters - shrinkOffset);
    final quickFilterSizeProportion = remainingSpaceForQuickFilters / heightOfQuickFilters;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [Elevation.s],
      ),
      child: ClipRect(
        clipBehavior: Clip.antiAlias,
        child: Opacity(
          opacity: quickFilterSizeProportion,
          child: SizedOverflowBox(
            size: Size(
              double.infinity,
              remainingSpaceForQuickFilters,
            ),
            child: MapQuickFilters(
              id: QuickFilterScreen.dashboard,
              isDashboard: true,
              customFilters: [
                FilterItemConfig(
                  filterType: FilterType.custom,
                  title: context.l10n.go,
                  icon: 'assets/icons/svg/quick_filters/free_roam.svg',
                  onTap: () => FreeRoamRoute.open(ref.watch(goRouterProvider)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends ConsumerWidget {
  final StatefulBottomSheetController bottomSheetController;

  const DashboardHeader({
    required this.bottomSheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: GestureDetector(
            onTap: () {
              Metrics.logEventAdvanced(
                MetricsConstants.exploreKeys.searchField,
                action: MetricAction.tap.name,
                group: MetricsConstants.exploreTag,
              );
              ref.read(searchByRubricsQueryProvider.notifier).update(null);
              // Here we clean the search query on tap on the search field
              // So the user can see the search history, not previous search results
              ref.read(searchProvider(SearchScopeEnum.map.value).notifier).clear();
              context.router.push(SearchRoute());
            },
            child: AbsorbPointer(
              child: BaladyInput.searchV2(
                hintText: context.l10n.searchPlaceOrAddress,
                readOnly: true,
                fillColor: context.colorsV2.neutralContainerDefault,
                hintColor: context.colorsV2.foregroundSoft,
                textStyle: context.textStyleV3.bodySmallRegular,
              ),
            ),
          ),
        ),
      );
}
