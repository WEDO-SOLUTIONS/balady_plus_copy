import 'package:flutter/material.dart';
import 'package:mapness/features/stories/data/frame/frame_progress_data.dart';
import 'package:mapness/features/stories/data/frame/story_frame_action.dart';
import 'package:mapness/features/stories/data/frame/story_frame_data.dart';
import 'package:mapness/features/stories/presentation/frame/frame_action_button.dart';
import 'package:mapness/features/stories/presentation/frame/frame_progress_indicator.dart';
import 'package:mapness/features/stories/presentation/frame/story_frame_content.dart';

class StoryFrameWidget extends StatelessWidget {
  final StoryFrameData frame;
  final FrameProgressData progressData;

  final VoidCallback onTapDownNext;
  final VoidCallback onTapDownPrevious;
  final VoidCallback onTapUpNext;
  final VoidCallback onTapUpPrevious;

  final VoidCallback onClose;

  final void Function(StoryFrameAction action)? onActionPressed;

  const StoryFrameWidget({
    required this.frame,
    required this.onClose,
    required this.onTapDownNext,
    required this.onTapDownPrevious,
    required this.onTapUpNext,
    required this.onTapUpPrevious,
    required this.progressData,
    super.key,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.network(frame.imageUrl)),
        SafeArea(
          child: Stack(
            children: [
              /// story content
              Padding(
                padding: const EdgeInsets.only(top: 81),
                child: StoryFrameContent(frame: frame),
              ),

              /// left right click handlers
              Row(
                children: [
                  Expanded(
                    flex: 30,
                    child: GestureDetector(
                      onTapDown: (_) => onTapDownPrevious,
                      onTapUp: (_) => onTapUpPrevious,
                    ),
                  ),
                  Expanded(
                    flex: 70,
                    child: GestureDetector(
                      onTapDown: (_) => onTapDownNext,
                      onTapUp: (_) => onTapUpNext,
                      // onTap: nextStory,
                    ),
                  ),
                ],
              ),

              /// progress indicator and exit button
              FrameProgressIndicator(
                data: progressData,
                onClose: onClose,
              ),

              /// action button
              if (frame.action != null && onActionPressed != null)
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: FrameActionButton(
                    title: frame.action!.title,
                    onPressed: () => onActionPressed!(frame.action!),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
