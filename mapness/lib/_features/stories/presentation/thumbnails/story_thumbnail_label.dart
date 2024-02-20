import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';


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
          style: Theme.of(context).extension<ThemeTextStyles>()!.headingS.copyWith(color: NonThemeColor.color5),
        ),
      ),
    );
  }
}
