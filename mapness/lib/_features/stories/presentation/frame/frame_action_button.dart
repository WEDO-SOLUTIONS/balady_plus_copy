import 'package:flutter/material.dart';
import 'package:mapness/shared/config/package_fonts.dart';
import 'package:mapness/_features/stories/domain/frame/story_text_style.dart';

class FrameActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final StoryTextStyle? textStyle;

  const FrameActionButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.backgroundColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: backgroundColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: PackageFonts.frutigerArabic(
          color: textStyle?.color ?? const Color(0xFF4CA5B4),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.30,
        ),
      ),
    );
  }
}
