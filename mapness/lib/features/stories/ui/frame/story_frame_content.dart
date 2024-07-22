part of 'story_frame_widget.dart';

class StoryFrameContent extends StatelessWidget {
  final StoryFrameData frame;

  const StoryFrameContent({
    required this.frame,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final storyTheme = frame.themeFromId(
      colorTheme: context.colorsV2,
      textTheme: context.textStyleV3,
    );
    final texts = frame.textFromId(
      l10n: context.l10n,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: storyTheme.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texts.title,
            style: storyTheme.titleStyle,
          ),
          if (texts.subTitle != null)
            Text(
              texts.subTitle!,
              style: storyTheme.titleStyle,
            ),
          const SizedBox(height: 12),
          if (texts.description != null)
            Text(
              texts.description!,
              style: storyTheme.descriptionStyle,
            ),
          if (frame.additionalContent != null) ...frame.additionalContent!(context),
        ],
      ),
    );
  }
}
