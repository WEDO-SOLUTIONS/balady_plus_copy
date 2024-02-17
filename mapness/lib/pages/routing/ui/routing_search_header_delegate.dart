import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/routing/ui/routing_search_bar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class RoutingSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  RoutingSearchHeaderDelegate({
    required this.placeholder,
    required this.draggableScrollableController,
  });

  final String placeholder;
  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return DashboardHeader(
      placeholder: placeholder,
      draggableScrollableController: draggableScrollableController,
    );
  }

  @override
  double get maxExtent => 84;

  @override
  double get minExtent => 84;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    super.key,
    required this.placeholder,
    required this.draggableScrollableController,
  });

  final String placeholder;
  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
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
              decoration:  BoxDecoration(
                color: context.color.surface_base_primary,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RoutingSearchBar(
              placeholder: placeholder,
              draggableScrollableController: draggableScrollableController,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
