import 'package:balady_uikit/src/components/chips/tools/chips_icon_builder.dart';
import 'package:flutter/material.dart';

/// The options that will be displayed in the chips
sealed class ChipsOptions {
  const ChipsOptions();
}

/// The options for the icon state
final class ChipsIconOptions extends ChipsOptions {
  /// The icon that will be displayed in the chips
  final ChipsIconBuilder icon;

  /// The color of the icon
  final Color? color;

  const ChipsIconOptions({
    required this.icon,
    this.color,
  });
}

/// The options for the label state
/// [labelFirst] is required
final class ChipsLabelOptions extends ChipsOptions {
  /// The leading icon that will be displayed before the label
  final ChipsIconBuilder? leadingIcon;

  /// The color of the leading icon
  /// If not provided, the type's foreground color will be used
  final Color? leadingIconColor;

  /// The label that will be displayed in the chips
  final String labelFirst;

  /// The color of the first label
  /// If not provided, the type's foreground color will be used
  final Color? labelFirstColor;

  /// The second label that will be displayed in the chips
  final String? labelSecond;

  /// The color of the second label
  /// If not provided, the type's foreground color will be used
  final Color? labelSecondColor;

  /// The trailing icon that will be displayed after the label
  final ChipsIconBuilder? trailingIcon;

  /// The color of the trailing icon
  /// If not provided, the type's foreground color will be used
  final Color? trailingIconColor;

  /// The [onTrailingIconPressed] callback that will be called when the trailing icon is pressed
  final VoidCallback? onTrailingIconPressed;

  const ChipsLabelOptions({
    required this.labelFirst,
    this.labelSecond,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.leadingIconColor,
    this.labelFirstColor,
    this.labelSecondColor,
    this.trailingIconColor,
  });
}
