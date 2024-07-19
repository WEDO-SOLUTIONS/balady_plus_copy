part of 'story_frame_widget.dart';

class StoryFrameContent extends StatelessWidget {
  final StoryFrameData frame;

  const StoryFrameContent({
    required this.frame,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final locales = StoryTexts.fromId(l10n, frame.storyId);
    final storyTheme = frame.themeFromId(
      colorTheme: context.colorsV2,
      textTheme: context.textStyleV3,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: storyTheme.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            locales.title,
            style: storyTheme.titleStyle,
          ),
          if (locales.subTitle != null)
            Text(
              locales.subTitle!,
              style: storyTheme.titleStyle,
            ),
          const SizedBox(height: 12),
          if (locales.description != null)
            Text(
              locales.description!,
              style: storyTheme.descriptionStyle,
            ),
          if (frame.additionalContent != null) ...frame.additionalContent!(context),
        ],
      ),
    );
  }
}
