import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stories/data/story_service.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/story_data.dart';
import 'package:mapness/features/stories/presentation/frame/story_frame_controller.dart';
import 'package:mapness/features/stories/presentation/frame/story_frame_widget.dart';

class StoryFramesPlayer extends ConsumerStatefulWidget {
  final StoryFrameController? controller;

  final StoryData story;

  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;
  final VoidCallback onClose;

  final void Function(StoryFrameAction action)? onActionPressed;
  final void Function(String id, int page)? onMarkReed;

  const StoryFramesPlayer({
    required this.onClose,
    required this.onNextStory,
    required this.onPreviousStory,
    required this.story,
    super.key,
    this.controller,
    this.onActionPressed,
    this.onMarkReed,
  });

  @override
  ConsumerState<StoryFramesPlayer> createState() => _StoryFramesPlayerState();
}

class _StoryFramesPlayerState extends ConsumerState<StoryFramesPlayer> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = max(
      0,
      widget.story.frames.indexWhere((element) => !element.isWatched),
    );
    ref.read(storyServiceProvider.notifier).markStoryAsRead(widget.story.storyId, currentIndex);
  }

  void _nextPage(String storyId, int pageIndex, int maxIndex) {
    if (pageIndex == maxIndex - 1) {
      widget.onNextStory();
      ref.read(storyServiceProvider.notifier).markStoryAsRead(widget.story.storyId, currentIndex);
      return;
    }

    setState(() {
      currentIndex++;
    });
  }

  void _previousPage(String storyId, int pageIndex) {
    if (pageIndex == 0) {
      widget.onPreviousStory();
      return;
    }
    setState(() {
      currentIndex = max(currentIndex - 1, 0);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final frames = widget.story.frames;
    for (var i = currentIndex; i < frames.length; i++) {
      if (frames[i].isAssetImage == true) {
        continue;
      }
      // Preload images for better performance
      CachedNetworkImageProvider(frames[i].imageUrl).resolve(ImageConfiguration.empty);
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
      thumbnailData: story.thumbnail,
    );
  }
}
