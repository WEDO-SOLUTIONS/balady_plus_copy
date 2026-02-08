import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/src/common/shape_shadow.dart';
import 'package:balady_uikit/src/layouts/size_constraint.dart';
import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'v2/tabs_v2.dart';

/// A [Tabs] component for the [POI Card] showcasing a selectable button for category.
///
/// A widget displaying a tab button with an optional icon and counter value parameters.
/// Title is required for this widget. The widget supports tap actions and selected style.
///
/// See also:
/// * [Figma Design](https://www.figma.com/file/owbsr9Pf0mQSEHXlbiPGOv/Balady-%E2%80%93-Components-Library?type=design&node-id=2169-42554&mode=design&t=giNINL4hXcUJxD7o-0), design specs
class Tabs extends StatelessWidget {
  static int value = 3;

  final String title;
  final IconData? icon;
  final int? counterValue;
  final bool isSelected;
  final VoidCallback? onTap;
  final double? width;

  const Tabs({
    required this.title,
    this.icon,
    this.counterValue,
    this.onTap,
    this.width,
    this.isSelected = false,
    super.key,
  });

  static Widget v2({
    required VoidCallback onTap,
    TabsV2IconBuilder? leadingIcon,
    TabsV2IconBuilder? trailingIcon,
    String? title,
    bool isSelected = false,
    Color? activeColor,
    Color? dismissedColor,
    Color? activeTextColor,
    Color? dismissedTextColor,
    TextStyle? textStyle,
  }) =>
      _TabsV2(
        onTap: onTap,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        title: title,
        isSelected: isSelected,
        activeColor: activeColor,
        dismissedColor: dismissedColor,
        activeTextColor: activeTextColor,
        dismissedTextColor: dismissedTextColor,
        textStyle: textStyle,
      );

  @override
  Widget build(BuildContext context) {
    final _icon = icon;
    final _counterValue = counterValue;

    const borderRadius = BorderRadius.only(
      topLeft: Radius.circular(RadiusBorder.l),
      topRight: Radius.circular(RadiusBorder.l),
    );

    final colors = context.colors;

    return Material(
      borderRadius: borderRadius,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.$3x,
            horizontal: Spacing.$3x,
          ),
          child: SizedBox(
            height: SizeConstraints.tabsIcon,
            width: width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_icon != null)
                  SizedBox(
                    height: SizeConstraints.tabsIcon,
                    width: SizeConstraints.tabsIcon,
                    child: Icon(
                      _icon,
                      color: isSelected ? colors.accentActive : colors.foregroundSoft,
                    ),
                  ),
                Text(
                  title,
                  style: context.textStyles.bodySmallSemiBold.copyWith(
                    color: isSelected ? colors.accentActive : colors.foregroundSoft,
                  ),
                ),
                if (_counterValue != null)
                  SizedBox(
                    height: SizeConstraints.tabsIcon,
                    child: Counter(
                      count: counterValue,
                      color: isSelected ? colors.accentActive : colors.foregroundSoft,
                    ),
                  ),
              ]
                  .insertBetween(
                    const SizedBox(
                      width: Spacing.$1_5x,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
