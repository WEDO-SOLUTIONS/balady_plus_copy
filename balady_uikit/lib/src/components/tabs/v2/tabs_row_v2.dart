part of 'package:balady_uikit/src/components/tabs/tabs_row.dart';

/// [_TabsRowV2] component based on [ChipsRow].
///
/// A widget displaying a row of chip buttons based on provided [ChipRowContent] list with
/// optional icon (leading or trailing), title, and label. One of them should be provided.
/// The widget supports tap actions, styles (on white and on colorful background)
///
/// See also:
/// * [Figma Design](https://www.figma.com/design/owbsr9Pf0mQSEHXlbiPGOv/Components-Library?node-id=9330-28437&t=km38JE4brkLmgTM5-0), design specs
class _TabsRowV2 extends StatefulWidget {
  final int initialIndex;
  final List<TabsRowV2Content> tabsContent;
  final ValueChanged<int?>? onIndexChanged;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? dismissedColor;
  final EdgeInsetsGeometry? padding;
  final Color? activeTextColor;
  final Color? dismissedTextColor;
  final TextStyle? textStyle;
  final double? separationPadding;

  const _TabsRowV2({
    required this.tabsContent,
    this.onIndexChanged,
    this.initialIndex = 0,
    this.backgroundColor,
    this.activeColor,
    this.dismissedColor,
    this.padding,
    this.activeTextColor,
    this.dismissedTextColor,
    this.textStyle,
    this.separationPadding,
  });

  @override
  State<_TabsRowV2> createState() => _TabsRowV2State();
}

class _TabsRowV2State extends State<_TabsRowV2> with TickerProviderStateMixin {
  late int? currentIndex;
  late final SymmetricScrollController controller;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    controller = SymmetricScrollController(
      vsync: this,
      initialIndex: currentIndex ?? 0,
    );
  }

  @override
  void didUpdateWidget(covariant _TabsRowV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentIndex = widget.initialIndex;
    controller.animateToItem(currentIndex ?? 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusBorder.l),
          color: widget.backgroundColor,
        ),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: SizedBox(
            height: Spacing.$10x,
            child: SymmetricExpandableList(
              controller: controller,
              separationPadding: widget.separationPadding ?? Spacing.$2x,
              children: widget.tabsContent
                  .map(
                    (content) => Tabs.v2(
                      activeColor: widget.activeColor,
                      dismissedColor: widget.dismissedColor,
                      activeTextColor: widget.activeTextColor,
                      dismissedTextColor: widget.dismissedTextColor,
                      textStyle: widget.textStyle,
                      onTap: () {
                        content.onTap?.call();
                        setState(() {
                          final _currentIndex = widget.tabsContent.indexOf(content);
                          if (_currentIndex != currentIndex) {
                            widget.onIndexChanged?.call(_currentIndex);
                            controller.animateToItem(_currentIndex);
                            currentIndex = _currentIndex;
                          }
                        });
                      },
                      title: content.title,
                      leadingIcon: content.leadingIcon,
                      trailingIcon: content.trailingIcon,
                      isSelected: widget.tabsContent.indexOf(content) == currentIndex,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      );
}

final class TabsRowV2Content {
  final TabsV2IconBuilder? leadingIcon;
  final TabsV2IconBuilder? trailingIcon;

  /// Primary label text for the Chip.
  final String? title;

  final VoidCallback? onTap;

  TabsRowV2Content({
    this.leadingIcon,
    this.trailingIcon,
    this.title,
    this.onTap,
  });
}
