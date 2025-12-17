import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

/// Saudi Pass colors overriding for [Chips] from uikit
class SaudiPassChipsWidget extends StatelessWidget {
  const SaudiPassChipsWidget({
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
    final bool hasText = (title?.trim().isNotEmpty ?? false) ||
        (label?.trim().isNotEmpty ?? false);
    final labelColor = isSelected ? context.colors.accentSecondaryMuted : null;
    return Chips(
      onPressed: onTap,
      type: isSelected ? ChipsType.accentSecondary : ChipsType.neutral,
      options: hasText
          ? ChipsLabelOptions(
              labelFirst: title ?? '',
              labelSecond: label,
              labelSecondColor: labelColor,
              leadingIcon: leadingIcon,
              trailingIcon: trailingIcon,
            )
          : (leadingIcon != null || trailingIcon != null)
              ? ChipsIconOptions(icon: leadingIcon ?? trailingIcon!)
              : null,
    );
  }
}
