/*import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/pages/map_search/ui/map_search_bar.dart';

class MapSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  MapSearchHeaderDelegate({
    required this.requestFocus,
    required this.onClose,
  });

  final bool requestFocus;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => DashboardHeader(
        requestFocus: requestFocus,
        onClose: onClose,
      );

  @override
  double get maxExtent => 84;

  @override
  double get minExtent => 84;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    required this.requestFocus,
    required this.onClose,
    super.key,
  });

  final bool requestFocus;
  final VoidCallback onClose;

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
              child: MapSearchBar(
                requestFocus: requestFocus,
                onClose: onClose,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
}
*/