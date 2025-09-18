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
        if (texts.subTitle != null)
          Padding(
            padding: storyTheme.titlePadding,
            child: Center(
              child: Text.rich(
                TextSpan(
                  style: storyTheme.titleStyle.copyWith(fontSize: 16),
                  children: [
                    TextSpan(text: texts.title),
                    TextSpan(text: texts.subTitle, style: const TextStyle(fontSize: 15)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          Padding(
            padding: storyTheme.titlePadding,
            child: Text(
              texts.title,
              style: storyTheme.titleStyle,
              textAlign: texts.titleAlign,
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
