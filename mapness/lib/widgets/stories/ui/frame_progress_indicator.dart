import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

import 'package:mapness/widgets/stories/lib/models/story_thumbnail_data.dart';
import 'package:urbi_utils/urbi_utils.dart';

const _height = 72.0;
const _indicatorHeight = 2.0;

/// A widget that displays a progress indicator for frames in a story.
class FrameProgressIndicator extends AnimatedWidget {
  final VoidCallback? onClose;
  final int frameIndex;
  final int framesLength;
  final StoryThumbnailData thumbnailData;

  /// Creates a [FrameProgressIndicator].
  ///
  /// The [frameIndex] represents the current frame index.
  /// The [framesLength] represents the total number of frames.
  /// The [thumbnailData] contains data for the story thumbnail.
  /// The [animation] is used to animate the progress indicator.
  /// The [onClose] callback is called when the close button is tapped.
  const FrameProgressIndicator({
    required this.frameIndex,
    required this.framesLength,
    required this.thumbnailData,
    required Animation<double> animation,
    super.key,
    this.onClose,
  })  : assert(frameIndex >= 0, 'frameIndex must be greater than 0'),
        assert(framesLength >= 0, 'framesLength must be greater than 0'),
        assert(
          frameIndex <= framesLength,
          'frameIndex must be less than framesLength',
        ),
        super(listenable: animation);

  Animation<double> get _progress => listenable as Animation<double>;

  //TODO: Replace from ui-kit - icon/primaryOnColor
  static const _iconPrimaryOnColor = Colors.white;

  List<Widget> get _framesIndicators => List<Widget>.generate(
        framesLength,
        (index) {
          Widget clipRrect({required double progress}) => ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: LinearProgressIndicator(value: progress),
              );

          Widget child = clipRrect(progress: 0);

          if (index == frameIndex) {
            child = AnimatedBuilder(
              animation: _progress,
              builder: (_, __) => clipRrect(progress: _progress.value),
            );
          }
          if (index < frameIndex) {
            child = clipRrect(progress: 1);
          }

          return Expanded(child: child);
        },
      )
          .insertBetween(
            const SizedBox(width: Spacing.$2x),
          )
          .toList();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: _height,
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ProgressIndicatorTheme(
                    data: ProgressIndicatorThemeData(
                      linearTrackColor: thumbnailData.backgroundColor ?? _iconPrimaryOnColor.withOpacity(0.2),
                      linearMinHeight: _indicatorHeight,
                      color: thumbnailData.animationColor ?? _iconPrimaryOnColor,
                    ),
                    child: Row(
                      children: _framesIndicators,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.$4x),
                AppButton.close(
                  onTap: onClose,
                  buttonColorScheme: ButtonColorScheme.onColor,
                  padding: EdgeInsets.zero,
                  color: thumbnailData.closeButtonColor ?? _iconPrimaryOnColor.withOpacity(.08),
                  innerPadding: const EdgeInsets.all(Spacing.$2x),
                ),
              ],
            ),
          ),
        ),
      );
}
