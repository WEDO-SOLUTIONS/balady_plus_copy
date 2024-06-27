import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
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

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  DashboardHeaderDelegate({
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => DashboardHeader(
        draggableScrollableController: draggableScrollableController,
        shrinkOffset: shrinkOffset,
      );

  @override
  double get maxExtent => 140;

  @override
  double get minExtent => 140 - 16 - 40;

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
            const SizedBox(height: 8),
            const Center(child: SheetDragger()),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  max(0, 40 + 16 + 16 - shrinkOffset),
                ),
                child: const Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: 16),
                  MapQuickFilters(id: QuickFilterScreen.dashboard, isDashboard: true),
                  SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      );
}
