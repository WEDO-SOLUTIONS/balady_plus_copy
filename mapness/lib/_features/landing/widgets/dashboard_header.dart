import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/map_quick_filters.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DraggableScrollableController draggableScrollableController;

  static const headerHeight = 140.0;

  DashboardHeaderDelegate({
    required this.draggableScrollableController,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => DashboardHeader(
        draggableScrollableController: draggableScrollableController,
        shrinkOffset: shrinkOffset,
      );

  @override
  double get maxExtent => headerHeight;

  @override
  double get minExtent => headerHeight - Spacing.$4x - QuickFilters.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  final double shrinkOffset;
  final DraggableScrollableController draggableScrollableController;

  const DashboardHeader({
    required this.draggableScrollableController,
    required this.shrinkOffset,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: Spacing.$2x),
            const Center(child: SheetDragger()),
            const SizedBox(height: Spacing.$2x),
            Padding(
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
                  const SearchRoute().push(context);
                  draggableScrollableController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
                child: AbsorbPointer(
                  child: BaladyInput.search(
                    hintText: context.l10n.searchPlaceOrAddress,
                    readOnly: true,
                  ),
                ),
              ),
            ),
            ClipRect(
              clipBehavior: Clip.antiAlias,
              child: SizedOverflowBox(
                size: Size(
                  double.infinity,
                  max(0, QuickFilters.height + Spacing.$4x * 2 - shrinkOffset),
                ),
                child: const Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: Spacing.$4x),
                  MapQuickFilters(id: QuickFilterScreen.dashboard, isDashboard: true),
                  SizedBox(height: Spacing.$4x),
                ]),
              ),
            ),
          ],
        ),
      );
}
