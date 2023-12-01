import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

import 'package:mapness/_features/stories/domain/frame/story_frame_data.dart';

class StoryFrameContent extends StatelessWidget {
  final StoryFrameData frame;

  const StoryFrameContent({
    super.key,
    required this.frame,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  frame.title,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .headingL
                      .copyWith(
                        color: frame.titleStyle?.color ?? Colors.white,
                      ),
                ),
                if (frame.subtitle != null)
                  Text(
                    frame.subtitle!,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .headingL
                        .copyWith(
                          color: frame.titleStyle?.color ?? Colors.white,
                        ),
                  ),
                const SizedBox(height: 21),
                if (frame.description != null)
                  Text(
                    frame.description!,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textM
                        .copyWith(
                          color: frame.descriptionStyle?.color ?? Colors.white,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
