import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

/// Saudi Pass color¬s overriding for [Chips] from uikit
class ChipsLocalWidget extends StatelessWidget {
  const ChipsLocalWidget({
    required this.onTap,
    required this.style,
    this.leadingIcon,
    this.trailingIcon,
    this.title,
    this.label,
    this.isSelected = false,
    this.size = ChipsSize.small,
    super.key,
  });

  final ChipsIconBuilder? leadingIcon;
  final ChipsIconBuilder? trailingIcon;
  final String? title;
  final String? label;
  final ChipsStyle style;
  final ChipsSize size;

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = context.color;
    final colorsV2 = context.colorsV2;
    final textStyle = context.textStyle;

    final backgroundColor = isSelected ? colorsV2.accentSecondaryDefault : colorsV2.neutralContainerDefault;
    final textColor = isSelected ? colorsV2.accentOnAccent : colorsV2.foregroundDefault;

    final overriddenColor = color.copyWith(
      surfaceBaseSecondary: backgroundColor, // background
      textAndIconsBasePrimary: textColor, // icons
      textAndIconsBaseTertiary: colorsV2.accentSecondaryMuted, // label
    );
    final overriddenTextStyle = textStyle.copyWith(callout: textStyle.callout.copyWith(color: textColor));

    return Theme(
      data: theme.overrideExtension(overriddenTextStyle).overrideExtension(overriddenColor),
      child: Chips(
        onTap: onTap,
        style: ChipsStyle.whiteBackground,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
        title: title,
        label: label,
        size: ChipsSize.medium,
      ),
    );
  }
}

extension ThemeExtensionOverrideExt on ThemeData {
  ThemeData overrideExtension<T extends ThemeExtension<T>>(ThemeExtension<T> style) => copyWith(
        extensions: {...extensions, T: style}.values,
      );
}
