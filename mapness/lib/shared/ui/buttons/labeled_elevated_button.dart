import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class LabeledElevatedButton extends StatelessWidget {
  const LabeledElevatedButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.padding,
  });

  final VoidCallback onPressed;
  final bool enabled;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? context.colors.accentOnContainer,
          disabledBackgroundColor: context.colors.backgroundSurface1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          padding: padding ?? const EdgeInsets.all(10),
        ),
        child: Text(
          label,
          style: context.textStyle.callout.copyWith(
            color: textColor ?? Colors.white,
          ),
        ),
      );
}
