import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

class LabeledElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const LabeledElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? const Color(0xff4CA5B4),
        disabledBackgroundColor: const Color(0xffDDDFE1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        padding: const EdgeInsets.all(10),
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
