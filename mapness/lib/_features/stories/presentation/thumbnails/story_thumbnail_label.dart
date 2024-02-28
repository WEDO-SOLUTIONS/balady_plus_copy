import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';


class StoryThumbnailLabel extends StatelessWidget {
  const StoryThumbnailLabel({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
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
