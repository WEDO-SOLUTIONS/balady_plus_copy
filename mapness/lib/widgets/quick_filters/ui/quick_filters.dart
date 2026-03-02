import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuickFilters extends ConsumerStatefulWidget {
  final EdgeInsets padding;
  final List<FilterItem> filters;

  final double height;
  final ItemScrollController? itemScrollController;

  static const defaultHeight = AppSizes.m + Spacing.$2x;

  const QuickFilters({
    required this.filters,
    double? height,
    super.key,
    this.padding = const EdgeInsets.only(),
    this.itemScrollController,
  }) : height = height ?? defaultHeight;

  @override
  ConsumerState<QuickFilters> createState() => _QuickFiltersState();
}

class _QuickFiltersState extends ConsumerState<QuickFilters> {
  late final ItemScrollController itemScrollController;

  @override
  void initState() {
    super.initState();
    itemScrollController = widget.itemScrollController ?? ItemScrollController();
  }

  @override
  void didUpdateWidget(QuickFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemScrollController != oldWidget.itemScrollController) {
      itemScrollController = widget.itemScrollController ?? ItemScrollController();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Workaround to fix issue: https://github.com/google/flutter.widgets/issues/192
    final originalDirectionality = Directionality.of(context);
    const positionedListDirectionality = TextDirection.ltr;
    final reverse = originalDirectionality == TextDirection.rtl;

    return SizedBox(
      height: widget.height,
      child: Directionality(
        textDirection: positionedListDirectionality,
        child: ScrollablePositionedList.separated(
          scrollDirection: Axis.horizontal,
          reverse: reverse,
          padding: widget.padding,
          itemScrollController: itemScrollController,
          separatorBuilder: (_, __) => const SizedBox(width: Spacing.$2x),
          itemCount: widget.filters.length,
          itemBuilder: (context, index) {
            final item = widget.filters[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.$0_5x),
              child: Directionality(
                textDirection: originalDirectionality,
                child: switch (item) {
                  FilterItemConfig() => QuickFilter(item: item, selected: item.selected, chipsType: ChipsType.map),
                  FilterItemBuilder() => item.builder(context, isSelected: item.selected),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
