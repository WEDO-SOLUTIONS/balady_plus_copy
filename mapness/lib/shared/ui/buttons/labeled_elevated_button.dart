import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

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
          backgroundColor: backgroundColor ?? context.color.strokeAccent,
          disabledBackgroundColor: context.color.surfaceBasePrimary,
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
