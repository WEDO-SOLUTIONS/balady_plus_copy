import 'package:flutter/material.dart';
import 'package:mapness/features/common/config/package_fonts.dart';

class StoryThumbnailLabel extends StatelessWidget {
  final String title;
  const StoryThumbnailLabel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: PackageFonts.frutigerArabic(
            color: const Color(0xFF141414),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 0.06,
            letterSpacing: -0.40,
          ),
        ),
      ),
    );
  }
}
