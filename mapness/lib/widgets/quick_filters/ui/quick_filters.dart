import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class QuickFilters extends ConsumerStatefulWidget {
  final EdgeInsets padding;
  final List<FilterItem> filters;
  final QuickFilterScreen id;
  final bool isDashboard;
  final double height;

  static const defaultHeight = 40.0;

  const QuickFilters({
    required this.filters,
    required this.id,
    double? height,
    this.isDashboard = false,
    super.key,
    this.padding = const EdgeInsets.only(bottom: 16),
  }) : height = height ?? defaultHeight;

  @override
  ConsumerState<QuickFilters> createState() => _QuickFiltersState();
}

class _QuickFiltersState extends ConsumerState<QuickFilters> {
  late final ItemScrollController itemScrollController;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
  }

  @override
  void didUpdateWidget(QuickFilters oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final requestId = ref.read(quickFiltersRequestSourceScreenProvider);
      if (requestId != null && requestId != widget.id) {
        final selectedIndex = widget.filters.indexWhere((element) => element.selected);
        if (selectedIndex != -1) {
          itemScrollController.jumpTo(index: selectedIndex, alignment: 0.03);
        }
        ref.read(quickFiltersRequestSourceScreenProvider.notifier).reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // We watch [scrollToSelectedQuickFilterProvider] to keep it alive in the widget tree
    ref.watch(quickFiltersRequestSourceScreenProvider);

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
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: widget.filters.length,
          itemBuilder: (context, index) {
            final item = widget.filters[index];
            return Center(
              child: Directionality(
                textDirection: originalDirectionality,
                child: switch (item) {
                  FilterItemConfig() => QuickFilter(
                      item: item,
                      selected: item.selected,
                      background:
                          widget.isDashboard ? context.color.surfaceBaseSecondary : context.color.surfaceBasePrimary,
                    ),
                  FilterItemBuilder() => item.builder(
                      context,
                      isSelected: item.selected,
                      isDashboard: widget.isDashboard,
                    ),
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
