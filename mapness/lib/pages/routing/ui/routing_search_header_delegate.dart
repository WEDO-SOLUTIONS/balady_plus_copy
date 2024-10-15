import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/pages/routing/ui/routing_search_bar.dart';

class RoutingSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String placeholder;
  final Color backgroundColor;

  RoutingSearchHeaderDelegate({
    required this.placeholder,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => DashboardHeader(
        placeholder: placeholder,
        backgroundColor: backgroundColor,
      );

  @override
  double get maxExtent => 76;

  @override
  double get minExtent => 76;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  final String placeholder;
  final Color backgroundColor;

  const DashboardHeader({
    required this.placeholder,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 6),
            const Center(child: SheetDragger()),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RoutingSearchBar(
                placeholder: placeholder,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      );
}
