import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filter.dart';

class QuickFilters extends ConsumerStatefulWidget {
  final EdgeInsets padding;
  final List<FilterItem> filters;

  final double height;
  final ScrollController? scrollController;

  static const defaultHeight = AppSizes.m + Spacing.$2x;

  const QuickFilters({
    required this.filters,
    double? height,
    super.key,
    this.padding = const EdgeInsets.only(),
    this.scrollController,
  }) : height = height ?? defaultHeight;

  @override
  ConsumerState<QuickFilters> createState() => _QuickFiltersState();
}

class _QuickFiltersState extends ConsumerState<QuickFilters> {
  /// Only set when no controller was supplied, so we dispose exactly what we own.
  ScrollController? _ownedController;

  ScrollController get _scrollController => widget.scrollController ?? (_ownedController ??= ScrollController());

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = ref.watch(uiDirectionProvider) == TextDirection.rtl;

    // Was ScrollablePositionedList. Its build starts with a LayoutBuilder, which
    // owns a BuildScope for every item built inside it - and the items are
    // ConsumerWidgets. Riverpod 3 makes every consumer depend on TickerMode, so
    // a route pop flipping TickerMode marked that LayoutBuilder for relayout
    // mid-frame (`_debugRelayoutBoundaryAlreadyMarkedNeedsLayout`).
    //
    // The only thing ItemScrollController was used for is a single
    // `scrollTo(index: 0)` in MapHiddenStateControls, which a plain
    // ScrollController does with `animateTo(0)`. Dropping the package also drops
    // the `reverse: isArabic` workaround for its RTL bug (flutter.widgets#192):
    // a horizontal ListView already follows the ambient Directionality, which is
    // pinned here to the same value the workaround was derived from.
    return SizedBox(
      height: widget.height,
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: widget.padding,
          controller: _scrollController,
          separatorBuilder: (_, __) => const SizedBox(width: Spacing.$2x),
          itemCount: widget.filters.length,
          itemBuilder: (context, index) {
            final item = widget.filters[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.$0_5x),
              child: switch (item) {
                FilterItemConfig() => QuickFilter(item: item, selected: item.selected, chipsType: ChipsType.map),
                FilterItemBuilder() => item.builder(context, isSelected: item.selected),
              },
            );
          },
        ),
      ),
    );
  }
}
