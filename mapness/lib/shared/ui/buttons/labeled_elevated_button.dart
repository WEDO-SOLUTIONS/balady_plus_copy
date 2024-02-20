import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class LabeledElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;

  const LabeledElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? context.color.stroke_accent,
        disabledBackgroundColor: context.color.surface_base_primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        padding: padding ?? const EdgeInsets.all(10),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .extension<ThemeTextStyles>()
            ?.textM
            .copyWith(color: textColor ?? Colors.white),
      ),
    );
  }
}
