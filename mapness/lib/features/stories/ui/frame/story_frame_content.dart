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
                // A line-limited title shrinks to fit rather than wrapping,
                // so a title typeset as N fixed lines stays N lines on
                // narrow phones.
                child: texts.titleMaxLines != null
                    ? AutoSizeText(
                        texts.title,
                        style: storyTheme.titleStyle,
                        textAlign: texts.titleAlign,
                        maxLines: texts.titleMaxLines,
                        minFontSize: 16,
                      )
                    : Text(
                        texts.title,
                        style: storyTheme.titleStyle,
                        textAlign: texts.titleAlign,
                      ),
              ),
            ],
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
