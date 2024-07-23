part of 'story_frame_widget.dart';

const _indicatorHeight = 2.0;

/// A widget that displays a progress indicator for frames in a story.
class FrameProgressIndicator extends AnimatedWidget {
  final int frameIndex;
  final int framesLength;
  final StoryTrackThemeData trackTheme;

  /// Creates a [FrameProgressIndicator].
  ///
  /// The [frameIndex] represents the current frame index.
  /// The [framesLength] represents the total number of frames.
  /// The [animation] is used to animate the progress indicator.
  const FrameProgressIndicator({
    required this.frameIndex,
    required this.framesLength,
    required this.trackTheme,
    required Animation<double> animation,
    super.key,
  })  : assert(frameIndex >= 0, 'frameIndex must be greater than 0'),
        assert(framesLength >= 0, 'framesLength must be greater than 0'),
        assert(
          frameIndex <= framesLength,
          'frameIndex must be less than framesLength',
        ),
        super(listenable: animation);

  Animation<double> get _progress => listenable as Animation<double>;

  List<Widget> get _framesIndicators => List<Widget>.generate(
        framesLength,
        (index) {
          Widget clipRRect({required double progress}) => ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: LinearProgressIndicator(value: progress),
              );

          Widget child = clipRRect(progress: 0);

          if (index == frameIndex) {
            child = AnimatedBuilder(
              animation: _progress,
              builder: (_, __) => clipRRect(progress: _progress.value),
            );
          }
          if (index < frameIndex) {
            child = clipRRect(progress: 1);
          }

          return Expanded(child: child);
        },
      )
          .insertBetween(
            const SizedBox(width: Spacing.$2x),
          )
          .toList();

  @override
  Widget build(BuildContext context) => ProgressIndicatorTheme(
        data: ProgressIndicatorThemeData(
          linearTrackColor: trackTheme.backgroundColor,
          linearMinHeight: _indicatorHeight,
          color: trackTheme.color,
        ),
        child: Row(
          children: _framesIndicators,
        ),
      );
}
