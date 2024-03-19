import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/stories/data/story_service.dart';
import 'package:mapness/_features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/_features/stories/domain/story_data.dart';
import 'package:mapness/_features/stories/presentation/frame/story_frame_controller.dart';
import 'package:mapness/_features/stories/presentation/frame/story_frame_widget.dart';

class StoryFramesPlayer extends ConsumerStatefulWidget {

  const StoryFramesPlayer({
    required this.story, required this.onNextStory, required this.onPreviousStory, required this.onClose, this.onActionPressed,
    super.key,
    this.controller,
    this.onMarkReed,
  });
  final StoryFrameController? controller;

  final StoryData story;

  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;
  final VoidCallback onClose;

  final void Function(StoryFrameAction action)? onActionPressed;

  final void Function(String id, int page)? onMarkReed;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precache next 2 images
    final frames = widget.story.frames;
    for (var i = currentIndex; i < min(frames.length, 2); i++) {
      if (frames[i].isAssetImage == true) continue;
      precacheImage(NetworkImage(frames[i].imageUrl), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final frames = story.frames;
    final currentFrame = frames[currentIndex];

    return StoryFrameWidget(
      controller: widget.controller,
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
