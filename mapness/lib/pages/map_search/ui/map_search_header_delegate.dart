import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/pages/map_search/ui/map_search_bar.dart';

class MapSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  MapSearchHeaderDelegate({required this.requestFocus, required this.onClose, required this.backgroundColor});

  final bool requestFocus;
  final VoidCallback onClose;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      DashboardHeader(requestFocus: requestFocus, onClose: onClose, backgroundColor: backgroundColor);

  @override
  double get maxExtent => 76;

  @override
  double get minExtent => 76;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({required this.requestFocus, required this.onClose, required this.backgroundColor, super.key});

  final bool requestFocus;
  final VoidCallback onClose;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
    ),
    child: Column(
      children: [
        Center(child: SheetDragger(draggerColor: context.colors.backgroundSurface5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: MapSearchBar(requestFocus: requestFocus, onClose: onClose),
        ),
        const SizedBox(height: Spacing.$4x),
      ],
    ),
  );
}
