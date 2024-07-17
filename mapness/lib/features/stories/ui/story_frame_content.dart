import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_data.dart';
import 'package:mapness/features/stories/ui/stories_screen.dart';
import 'package:mapness/features/stories/ui/story_localization.dart';

class StoryFrameContent extends StatelessWidget {
  final StoryFrameData frame;
  final void Function(StoryFrameAction action)? onActionPressed;

  const StoryFrameContent({
    required this.frame,
    this.onActionPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = StoryLocalization.of(context).locale;
    final storyTheme = StoryTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: storyTheme.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            frame.titleOrFailback(l10n),
            style: storyTheme.titleStyle ??
                context.textStyleV3.h1SemiBold.copyWith(
                  color: context.color.textAndIconsBaseInversePrimary,
                ),
          ),
          if (frame.subtitle != null)
            Text(
              frame.subtitle!,
              style: storyTheme.titleStyle ??
                  context.textStyle.heading2.copyWith(
                    color: context.color.textAndIconsBaseInversePrimary,
                  ),
            ),
          const SizedBox(height: 12),
          if (frame.description != null)
            Text(
              frame.descriptionOrFailback(l10n) ?? '',
              style: storyTheme.descriptionStyle ??
                  context.textStyleV3.bodyLargeRegular.copyWith(
                    color: context.color.textAndIconsBaseInversePrimary,
                  ),
            ),
          if (frame.additionalContent != null)
            ...frame.additionalContent!(
              context,
              onActionPressed,
            ),
        ],
      ),
    );
  }
}
