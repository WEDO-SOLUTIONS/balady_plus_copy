import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filter.dart';

class QuickFilters extends StatelessWidget {
  const QuickFilters({
    required this.filters, super.key,
    this.selectedIndex,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    this.itemBackground = NonThemeColor.color11,
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
              // background: itemBackground,
              background: context.color.surface_base_secondary,
            );
          },
        ),
      );
}
