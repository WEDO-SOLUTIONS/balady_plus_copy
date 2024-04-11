import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/_features/stories/presentation/story_localizations.dart';

class StoryFrameContent extends StatelessWidget {

  const StoryFrameContent({
    required this.frame, super.key,
  });
  final StoryFrameData frame;

  @override
  Widget build(BuildContext context) => SafeArea(
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
                  frame.titleOrFailback(StoryLocalizations.of(context)!.locale),
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .accent
                      .copyWith(
                        color: frame.titleStyle?.color ?? Colors.white,
                      ),
                ),
                if (frame.subtitle != null)
                  Text(
                    frame.subtitle!,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .accent
                        .copyWith(
                          color: frame.titleStyle?.color ?? Colors.white,
                        ),
                  ),
                const SizedBox(height: 21),
                if (frame.description != null)
                  Text(
                    frame.descriptionOrFailback(
                            StoryLocalizations.of(context)!.locale,) ??
                        '',
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .text
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
