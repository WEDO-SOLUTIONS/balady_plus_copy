import 'package:balady_uikit/balady_uikit.dart' hide BaladyInputStyle;
import 'package:flutter/material.dart';
import 'package:mapness/balady_uikit/components/text_input/input_styles.dart';

enum BaladyInputAffixType {
  prefix,
  suffix,
}

enum BaladyInputAffixAlignment {
  top,
  center,
  bottom,
}

sealed class BaladyInputAffixBase {
  final BaladyInputAffixAlignment? alignment;

  const BaladyInputAffixBase({
    this.alignment,
  });

  /// Base default padding for affix widget
  EdgeInsetsDirectional padding(BaladyInputStyle inputStyle, BaladyInputAffixType type) => switch (type) {
        BaladyInputAffixType.prefix => inputStyle.prefixPadding,
        BaladyInputAffixType.suffix => inputStyle.suffixPadding,
      };

  /// Calculate the padding of the affix widget and those paddings
  double widgetWithPadding(BaladyInputStyle inputStyle, BaladyInputAffixType type) =>
      padding(inputStyle, type).start + padding(inputStyle, type).end + width();

  /// Width of the affix widget
  double width();

  AlignmentDirectional inStackAlignment(BaladyInputAffixType type) {
    final alignmentValue_ = alignment ?? BaladyInputAffixAlignment.center;
    return switch (type) {
      BaladyInputAffixType.prefix => switch (alignmentValue_) {
          BaladyInputAffixAlignment.top => AlignmentDirectional.topStart,
          BaladyInputAffixAlignment.center => AlignmentDirectional.centerStart,
          BaladyInputAffixAlignment.bottom => AlignmentDirectional.bottomStart,
        },
      BaladyInputAffixType.suffix => switch (alignmentValue_) {
          BaladyInputAffixAlignment.top => AlignmentDirectional.topEnd,
          BaladyInputAffixAlignment.center => AlignmentDirectional.centerEnd,
          BaladyInputAffixAlignment.bottom => AlignmentDirectional.bottomEnd,
        },
    };
  }
}

class BaladyInputAffixWidget extends BaladyInputAffixBase {
  /// Affix widget that we provide as parameter
  final Widget widget;

  /// Width of this widget. You have to provide it because we render the widget and
  /// we don't want to make "automatic" calculation to detect the size of the widget
  /// Also we need to restrict the widget height
  final double _width;

  /// Paddings for this widget. If you want to create custom padding (not default) for this widget
  /// you can provide it here
  final EdgeInsetsDirectional? customPadding;

  const BaladyInputAffixWidget({
    required this.widget,
    required double width,
    this.customPadding,
    super.alignment,
  }) : _width = width;

  @override
  EdgeInsetsDirectional padding(BaladyInputStyle inputStyle, BaladyInputAffixType type) =>
      customPadding ?? super.padding(inputStyle, type);

  @override
  double width() => _width;
}

class BaladyInputAffixIcon extends BaladyInputAffixBase {
  static const defaultAffixIconSize = AppSizes.xxs;

  final IconData icon;
  final double? iconSize;
  final Color? iconColor;

  final EdgeInsetsDirectional? customPadding;
  final VoidCallback? onPressed;
  final bool isVisible;

  const BaladyInputAffixIcon({
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.customPadding,
    super.alignment,
    this.isVisible = true,
  });

  BaladyInputAffixIcon copyWith({
    IconData? icon,
    double? iconSize,
    Color? iconColor,
    EdgeInsetsDirectional? customPadding,
    VoidCallback? onPressed,
    bool? isVisible,
    BaladyInputAffixAlignment? alignment,
  }) =>
      BaladyInputAffixIcon(
        icon: icon ?? this.icon,
        iconSize: iconSize ?? this.iconSize,
        iconColor: iconColor ?? this.iconColor,
        customPadding: customPadding ?? this.customPadding,
        onPressed: onPressed ?? this.onPressed,
        isVisible: isVisible ?? this.isVisible,
        alignment: alignment ?? this.alignment,
      );

  @override
  EdgeInsetsDirectional padding(BaladyInputStyle inputStyle, BaladyInputAffixType type) =>
      customPadding ?? super.padding(inputStyle, type);

  @override
  double width() => iconSize ?? defaultAffixIconSize;
}

class BaladyInputAffixCleanIcon extends BaladyInputAffixIcon {
  final bool cleanOnPressed;

  const BaladyInputAffixCleanIcon({
    required void Function() onPressed,
    this.cleanOnPressed = true,
    super.alignment,
    super.isVisible,
  }) : super(icon: SystemIcons.closeSmall, onPressed: onPressed);
}
