import 'package:flutter/material.dart';
import 'package:mapness/features/stories/data/frame/frame_progress_data.dart';
import 'package:mapness/features/stories/presentation/frame/close_story_button.dart';

class FrameProgressIndicator extends StatelessWidget {
  final FrameProgressData data;
  final VoidCallback? onClose;

  const FrameProgressIndicator({
    super.key,
    required this.data,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  data.length,
                  (index) {
                    if (index == data.currentIndex) return LinearProgressIndicator(value: data.progress);
                    if (index < data.currentIndex) {
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
    );
  }
}
