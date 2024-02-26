import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

import 'package:mapness/_features/stories/domain/frame/story_text_style.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FrameActionButton extends StatelessWidget {

  const FrameActionButton({
    required this.title, required this.onPressed, required this.backgroundColor, required this.textStyle, super.key,
  });
  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final StoryTextStyle? textStyle;

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
        style: Theme.of(context).extension<ThemeTextStyles>()!.accentS.copyWith(
              color: textStyle?.color ?? context.color.stroke_accent,
            ),
      ),
    );
  }
}
