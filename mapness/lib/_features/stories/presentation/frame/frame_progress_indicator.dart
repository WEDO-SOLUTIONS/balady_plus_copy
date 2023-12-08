import 'package:flutter/material.dart';
import 'package:mapness/_features/stories/presentation/frame/close_story_button.dart';

class FrameProgressIndicator extends StatelessWidget {
  final VoidCallback? onClose;
  final int frameIndex;
  final int framesLength;
  final double progress;

  const FrameProgressIndicator({
    super.key,
    this.onClose,
    required this.frameIndex,
    required this.framesLength,
    required this.progress,
  })  : assert(frameIndex >= 0, 'frameIndex must be greater than 0'),
        assert(framesLength >= 0, 'framesLength must be greater than 0'),
        assert(progress >= 0, 'progress must be greater than 0'),
        assert(progress <= 1, 'progress must be less than 1'),
        assert(frameIndex <= framesLength,
            'frameIndex must be less than framesLength');

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CloseStoryButton(onPressed: onClose),
            const SizedBox(width: 11),
            Expanded(
              child: ProgressIndicatorTheme(
                data: const ProgressIndicatorThemeData(
                  linearTrackColor: Color(0xFFD9D9D9),
                  linearMinHeight: 2,
                  color: Colors.white,
                ),
                child: Row(
                  children: List.generate(
                    framesLength,
                    (index) {
                      if (index == frameIndex) {
                        return LinearProgressIndicator(value: progress);
                      }
                      if (index < frameIndex) {
                        return const LinearProgressIndicator(value: 1);
                      } else {
                        return const LinearProgressIndicator(value: 0);
                      }
                    },
                  )
                      .map((e) => Expanded(child: e))
                      .expand(
                        (element) => [element, const SizedBox(width: 8)],
                      )
                      .toList()
                    ..removeLast(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
