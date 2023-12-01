import 'package:flutter/material.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filter.dart';

class QuickFilters extends StatelessWidget {
  const QuickFilters({
    super.key,
    required this.filters,
    required this.onTap,
    this.selectedIndex,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    this.itemBackground = const Color(0x0D1E2A36),
  });

  final EdgeInsets padding;
  final int? selectedIndex;
  final List<FilterItem> filters;
  final Function(int) onTap;
  final Color itemBackground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: filters.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index == 0 ? 0 : 8,
            ),
            child: QuickFilter(
              item: filters[index],
              selected: index == selectedIndex,
              onTap: () {
                onTap(index);
              },
              background: itemBackground,
            ),
          );
        },
      ),
    );
  }
}
