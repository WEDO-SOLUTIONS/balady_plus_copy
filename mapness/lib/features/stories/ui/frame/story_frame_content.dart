part of 'story_frame_widget.dart';

class StoryFrameContent extends StatelessWidget {
  final StoryFrameData frame;
  final StoryFrameThemeData storyTheme;

  const StoryFrameContent({
    required this.frame,
    required this.storyTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = frame.textFromId(
      l10n: context.l10n,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: storyTheme.titlePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  texts.title,
                  style: storyTheme.titleStyle,
                  textAlign: texts.titleAlign,
                ),
              ),
            ],
          ),
        ),
        if (texts.subTitle != null)
          Padding(
            padding: storyTheme.titlePadding,
            child: Text(
              texts.subTitle!,
              style: storyTheme.titleStyle,
            ),
          ),
        if (texts.description != null) ...[
          Spacing.$3x.heightBox,
          Padding(
            padding: storyTheme.descriptionPadding,
            child: Text(
              texts.description!,
              style: storyTheme.descriptionStyle,
            ),
          ),
        ],
      ],
    );
  }
}
