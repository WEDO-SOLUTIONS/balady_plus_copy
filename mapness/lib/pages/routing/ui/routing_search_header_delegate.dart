import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/routing/ui/routing_search_bar.dart';

class RoutingSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String placeholder;

  RoutingSearchHeaderDelegate({
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => DashboardHeader(
        placeholder: placeholder,
      );

  @override
  double get maxExtent => 84;

  @override
  double get minExtent => 84;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  final String placeholder;

  const DashboardHeader({
    required this.placeholder,
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
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Container(
                height: 4,
                width: 26,
                decoration: BoxDecoration(
                  color: context.color.surfaceBasePrimary,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
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
