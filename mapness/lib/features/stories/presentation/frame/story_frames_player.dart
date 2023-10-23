import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stories/data/story_service.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/story_data.dart';
import 'package:mapness/features/stories/presentation/frame/story_frame_widget.dart';

class StoryFramesPlayer extends ConsumerStatefulWidget {
  final StoryData story;

  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;
  final VoidCallback onClose;

  final void Function(StoryFrameAction action)? onActionPressed;

  const StoryFramesPlayer({
    this.onActionPressed,
    super.key,
    required this.story,
    required this.onNextStory,
    required this.onPreviousStory,
    required this.onClose,
  });

  @override
  ConsumerState<StoryFramesPlayer> createState() => _StoryFramesPlayerState();
}

class _StoryFramesPlayerState extends ConsumerState<StoryFramesPlayer> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex =
        widget.story.frames.indexWhere((element) => !element.isWatched);
    if (currentIndex == -1) currentIndex = 0;
  }

  void _nextPage(String storyId, int pageIndex, int maxIndex) {
    setState(() {
      currentIndex++;
      if (currentIndex >= maxIndex) {
        widget.onNextStory();
        currentIndex = 0;
      }
    });
    final service = ref.read(storyServiceProvider.notifier);
    service.markStoryReeded(storyId, pageIndex);
    if (pageIndex == maxIndex - 1) {
      widget.onNextStory();
    }
  }

  void _previousPage(String storyId, int pageIndex) {
    setState(() {
      currentIndex--;
      if (currentIndex < 0) currentIndex = 0;
    });
    if (pageIndex == 0) {
      widget.onPreviousStory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final frames = story.frames;
    final currentFrame = frames[currentIndex];

    return StoryFrameWidget(
      onActionPressed: widget.onActionPressed,
      key: Key(story.storyId + currentIndex.toString()),
      frame: currentFrame,
      onClose: widget.onClose,
      onNext: () => _nextPage(story.storyId, currentIndex, frames.length),
      onPrevious: () => _previousPage(story.storyId, currentIndex),
      duration: currentFrame.duration,
      frameIndex: currentIndex,
      frameLength: frames.length,
    );
  }
}
