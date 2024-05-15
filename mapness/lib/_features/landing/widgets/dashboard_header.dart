import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/map_quick_filters.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  DashboardHeaderDelegate({
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      DashboardHeader(
        draggableScrollableController: draggableScrollableController,
      );

  @override
  double get maxExtent => 140;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    required this.draggableScrollableController,
    super.key,
  });

  final DraggableScrollableController draggableScrollableController;

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
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: context.color.surfaceContrastMid.withOpacity(0.24),
                  borderRadius: const BorderRadius.all(Radius.circular(99)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(urbiMetricsProvider.notifier)
                      .logEvent('Explore/Search field => Tap');
                  ref.read(searchByRubricsQueryProvider.notifier).update(null);
                  const SearchRoute().push(context);
                  draggableScrollableController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
                child: AbsorbPointer(
                  child: BaladyInput.search(
                    hintText: context.l10n.search,
                    readOnly: true,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const MapQuickFilters(),
            const SizedBox(height: 16),
          ],
        ),
      );
}
