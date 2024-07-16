import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

import '../../domain/thumbnail/story_thumbnail_data.dart';

class FrameProgressIndicator extends AnimatedWidget {
  final VoidCallback? onClose;
  final int frameIndex;
  final int framesLength;
  final StoryThumbnailData thumbnailData;

  const FrameProgressIndicator({
    required this.frameIndex,
    required this.framesLength,
    required Animation<double> animation,
    required this.thumbnailData,
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

  List<Widget> get _framesIndicators => List.generate(
        framesLength,
        (index) {
          if (index == frameIndex) {
            return AnimatedBuilder(
              animation: _progress,
              builder: (_, __) => ClipRRect(
                borderRadius: BorderRadius.circular(RadiusBorder.xs),
                child: LinearProgressIndicator(value: _progress.value),
              ),
            );
          }
          if (index < frameIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(RadiusBorder.xs),
              child: const LinearProgressIndicator(value: 1),
            );
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(RadiusBorder.xs),
              child: const LinearProgressIndicator(value: 0),
            );
          }
        },
      )
          //TODO(scroollocker): refactor this with insert_between
          .map((e) => Expanded(child: e))
          .expand(
            (element) => [element, const SizedBox(width: Spacing.$2x)],
          )
          .toList()
        ..removeLast();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 72,
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
                      linearTrackColor: thumbnailData.linearTrackColor ?? _iconPrimaryOnColor.withOpacity(0.2),
                      linearMinHeight: 2,
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
