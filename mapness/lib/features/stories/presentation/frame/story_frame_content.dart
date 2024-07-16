import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/features/stories/presentation/story_localizations.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

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
    final AppLocalizations l10n = StoryLocalizations.of(context)!.locale;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: frame.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            frame.titleOrFallback(l10n),
            style: context.textStyleV3.h1SemiBold.copyWith(
              color: frame.titleStyle?.color ?? context.color.textAndIconsBaseInversePrimary,
              fontSize: frame.titleStyle?.fontSize,
              height: frame.titleStyle?.height,
            ),
          ),
          if (frame.subtitle != null)
            Text(
              frame.subtitle!,
              style: context.textStyle.heading2.copyWith(
                color: frame.titleStyle?.color ?? context.color.textAndIconsBaseInversePrimary,
              ),
            ),
          const SizedBox(height: 12),
          if (frame.description != null)
            Text(
              frame.descriptionOrFallback(l10n) ?? '',
              style: context.textStyleV3.bodyLargeRegular.copyWith(
                color: frame.descriptionStyle?.color ?? context.color.textAndIconsBaseInversePrimary,
                fontSize: frame.descriptionStyle?.fontSize,
                height: frame.descriptionStyle?.height,
              ),
            ),
          if (frame.additionalContent != null) ...frame.additionalContent!(context, onActionPressed),
        ],
      ),
    );
  }
}
