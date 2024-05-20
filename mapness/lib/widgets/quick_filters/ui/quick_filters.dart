import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filter.dart';

class QuickFilters extends StatelessWidget {
  const QuickFilters({
    required this.filters,
    super.key,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    this.itemBackground = NonThemeColor.color11,
  });

  final EdgeInsets padding;
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
          itemBuilder: (context, index) {
            final item = filters[index];
            return QuickFilter(
              item: item,
              selected: item.selected,
              // background: itemBackground,
              background: context.color.surfaceBaseSecondary,
            );
          },
        ),
      );
}
