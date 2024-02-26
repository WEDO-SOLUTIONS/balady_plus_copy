import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/map_quick_filters.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/search/ui/search_field.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  DashboardHeaderDelegate({
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return DashboardHeader(
      draggableScrollableController: draggableScrollableController,
    );
  }

  @override
  double get maxExtent => 135;

  @override
  double get minExtent => 135;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    required this.draggableScrollableController, super.key,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Center(
            child: Container(
              height: 4,
              width: 26,
              decoration: BoxDecoration(
                color: context.color.surface_base_primary,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                ref.read(searchByRubricsQueryProvider.notifier).update(null);
                const SearchRoute().push(context);
                draggableScrollableController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
              },
              child: const AbsorbPointer(
                child: SearchField(),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const MapQuickFilters(),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
