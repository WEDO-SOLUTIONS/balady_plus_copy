import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class SegmentTabsButton extends StatelessWidget {
  final List<TabsRowV2Content> tabsContent;
  final int initialIndex;
  final void Function(int?) onIndexChanged;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? dismissedColor;
  final Color? activeTextColor;
  final Color? dismissedTextColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const SegmentTabsButton({
    required this.tabsContent,
    required this.onIndexChanged,
    super.key,
    this.backgroundColor,
    this.activeColor,
    this.dismissedColor,
    this.activeTextColor,
    this.dismissedTextColor,
    this.padding,
    this.initialIndex = 0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TabsRow.v2(
      initialIndex: initialIndex,
      backgroundColor: backgroundColor ?? colors.neutralContainerDefault,
      activeColor: activeColor ?? colors.foregroundSegmentedControl,
      dismissedColor: dismissedColor ?? Colors.transparent,
      activeTextColor: activeTextColor ?? colors.foregroundDefault,
      dismissedTextColor: dismissedTextColor ?? colors.foregroundDefault,
      tabsContent: tabsContent,
      onIndexChanged: onIndexChanged,
      padding: padding ?? const EdgeInsets.all(Spacing.$0_5x),
      textStyle: textStyle ?? context.textStyles.bodySmallMedium,
    );
  }
}
