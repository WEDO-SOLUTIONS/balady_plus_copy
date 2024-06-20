import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/features/stories/presentation/story_localizations.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

class StoryFrameContent extends StatelessWidget {
  const StoryFrameContent({
    required this.frame,
    super.key,
  });
  final StoryFrameData frame;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = StoryLocalizations.of(context)!.locale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          frame.titleOrFailback(l10n),
          style: context.textStyle.heading1.copyWith(
            color: frame.titleStyle?.color ?? context.color.textAndIconsBaseInversePrimary,
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
            frame.descriptionOrFailback(l10n) ?? '',
            style: context.textStyle.footNote.copyWith(
              color: frame.descriptionStyle?.color ?? context.color.textAndIconsBaseInversePrimary,
            ),
          ),
      ],
    );
  }
}
