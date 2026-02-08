import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/components/tabs/slivers/sliver_selected_item_indicator.dart';
import 'package:balady_uikit/src/layouts/size_constraint.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

part 'v2/tabs_row_v2.dart';

/// A [TabsRow] component for the [POI Card] showcasing a row of [Tabs].
///
/// A widget displaying a row of [Tabs] buttons based on provided [TabContent] list with
/// an optional icon and counter value parameters. Title is required for this widget.
/// The widget supports tap actions and selected style.
///
/// See also:
/// * [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2547%3A50934&mode=design&t=wJ6tU2tio7vzEDAi-1), design specs
class TabsRow extends StatefulWidget {
  final List<TabContent> tabs;
  final int initialIndex;
  final void Function(int index)? onIndexChanged;
  final SymmetricScrollController? controller;
  final bool showFirstTab;

  @Deprecated('Use TabsRow.v2 instead')
  const TabsRow({
    required this.tabs,
    this.onIndexChanged,
    this.controller,
    this.initialIndex = 0,
    this.showFirstTab = false,
    super.key,
  });

  static Widget v2({
    required List<TabsRowV2Content> tabsContent,
    ValueChanged<int?>? onIndexChanged,
    int initialIndex = 0,
    Color? backgroundColor,
    Color? activeColor,
    Color? dismissedColor,
    EdgeInsetsGeometry? padding,
    double? separationPadding,
    Color? activeTextColor,
    Color? dismissedTextColor,
    TextStyle? textStyle,
  }) =>
      _TabsRowV2(
        tabsContent: tabsContent,
        onIndexChanged: onIndexChanged,
        initialIndex: initialIndex,
        backgroundColor: backgroundColor,
        activeColor: activeColor,
        dismissedColor: dismissedColor,
        padding: padding,
        separationPadding: separationPadding,
        activeTextColor: activeTextColor,
        dismissedTextColor: dismissedTextColor,
        textStyle: textStyle,
      );

  @override
  State<TabsRow> createState() => _TabsRowState();
}

class _TabsRowState extends State<TabsRow> with TickerProviderStateMixin {
  late int currentIndex;
  late SymmetricScrollController controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    controller = widget.controller ?? SymmetricScrollController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant TabsRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!const ListEquality().equals(oldWidget.tabs, widget.tabs)) {
      if (currentIndex >= widget.tabs.length) {
        currentIndex = 0;
      }
      controller.jumpToItem(currentIndex);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabs.isEmpty || !widget.showFirstTab && widget.tabs.length == 1) {
      return const SizedBox.shrink();
    }

    final colors = context.colors;

    final indicatorStyle = UnderlineTabIndicator(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(RadiusBorder.xxs),
        topRight: Radius.circular(RadiusBorder.xxs),
      ),
      borderSide: BorderSide(
        color: colors.accentActive,
        width: SizeConstraints.tabsIndicator,
      ),
    );

    return SizedBox(
      height: SizeConstraints.tabsRowVertical,
      child: DecoratedBox(
        decoration: UnderlineTabIndicator(
          borderSide: BorderSide(color: colors.backgroundSurface5),
        ),
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
              sliver: SliverSelectedItemIndicator(
                controller: controller,
                indicator: indicatorStyle,
                sliver: SliverSymmetricExpandableList(
                  scrollController: controller,
                  contentPadding: Spacing.$4x,
                  delegate: SliverChildListDelegate(
                    widget.tabs
                        .map<Widget>(
                          (content) => NoExpand(
                            isExpanded: content.isExpanded,
                            child: Tabs(
                              title: content.title,
                              icon: content.icon,
                              counterValue: content.counterValue,
                              isSelected: widget.tabs.indexOf(content) == currentIndex,
                              onTap: () {
                                setState(() {
                                  currentIndex = widget.tabs.indexOf(content);
                                  widget.onIndexChanged?.call(currentIndex);
                                  controller.animateToItem(currentIndex);
                                });
                              },
                            ),
                          ),
                        )
                        .toList(),
                    addSemanticIndexes: false,
                    addRepaintBoundaries: false,
                    addAutomaticKeepAlives: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class TabContent {
  final IconData? icon;
  final String title;
  final int? counterValue;
  final bool isExpanded;

  const TabContent({
    required this.title,
    this.icon,
    this.counterValue,
    this.isExpanded = true,
  });
}
