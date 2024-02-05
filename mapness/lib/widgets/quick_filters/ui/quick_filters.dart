import 'package:flutter/material.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filter.dart';

class QuickFilters extends StatelessWidget {
  const QuickFilters({
    super.key,
    required this.filters,
    this.selectedIndex,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    this.itemBackground = const Color(0x0D1E2A36),
  });

  final EdgeInsets padding;
  final int? selectedIndex;
  final List<FilterItem> filters;
  final Color itemBackground;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: padding,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: filters.length,
          itemBuilder: (BuildContext context, int index) {
            final item = filters[index];
            return QuickFilter(
              item: item,
              selected: index == selectedIndex,
              background: itemBackground,
            );
          },
        ),
      );
}
