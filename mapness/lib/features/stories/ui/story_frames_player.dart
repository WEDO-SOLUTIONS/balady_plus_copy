import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/balady_analytics/events/story_events.dart';
import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_controller.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/providers/story_service.dart';
import 'package:mapness/features/stories/ui/frame/story_frame_widget.dart';
import 'package:mapness/features/stories/ui/story_args_provider.dart';

class StoryFramesPlayer extends ConsumerStatefulWidget {
  final StoryFrameController? controller;

  final StoryData story;

  final VoidCallback onNextStory;
  final VoidCallback onPreviousStory;

  /// Called when the last frame of [story] becomes visible — the story was
  /// watched through (analytics: `story_viewed.completed`).
  final VoidCallback? onLastFrameShown;

  const StoryFramesPlayer({
    required this.onNextStory,
    required this.onPreviousStory,
    required this.story,
    super.key,
    this.controller,
    this.onLastFrameShown,
  });

  @override
  ConsumerState<StoryFramesPlayer> createState() => _StoryFramesPlayerState();
}

class _StoryFramesPlayerState extends ConsumerState<StoryFramesPlayer> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(storyServiceProvider.notifier).markStoryAsRead(widget.story.storyId, currentIndex);
    _notifyIfLastFrameShown();
  }

  void _notifyIfLastFrameShown() {
    if (currentIndex == widget.story.frames.length - 1) {
      widget.onLastFrameShown?.call();
    }
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
    _notifyIfLastFrameShown();
  }

  void _previousPage(String storyId, int pageIndex) {
    if (pageIndex == 0) {
      if (StoryArgsProvider.of(context).type == StoryTypes.onboarding) {
        return;
      }
      widget.onPreviousStory();
      return;
    }
    if (currentIndex - 1 < 0) {
      return;
    }
    setState(() {
      currentIndex = currentIndex - 1;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final frame in widget.story.frames) {
      if (!context.mounted) {
        return;
      }
      final imageUrl = frame.imageUrlForLocale(Directionality.of(context));
      if (imageUrl != null) {
        if (frame.isAssetImage == true) {
          precacheImage(AssetImage(imageUrl), context);
          continue;
        }
        // Preload images for better performance
        CachedNetworkImageProvider(imageUrl).resolve(ImageConfiguration.empty);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    final frames = story.frames;
    final currentFrame = frames[currentIndex];

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: StoryFrameWidget(
        controller: widget.controller,
        key: Key(story.storyId + currentIndex.toString()),
        frame: currentFrame,
        type: StoryArgsProvider.of(context).type,
        onNext: () => _nextPage(story.storyId, currentIndex, frames.length),
        onPrevious: () => _previousPage(story.storyId, currentIndex),
        duration: currentFrame.duration,
        frameIndex: currentIndex,
        frameLength: frames.length,
        onActionPressed: (frame) {
          final action = frame.action!;
          if (action is NavigationFrameAction) {
            if (action.location.contains('/quickFeedback')) {
              ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiStories);
            }
          }
          // `NextStoryAction` only advances frames — not a CTA.
          switch (action) {
            case NavigationFrameAction(location: final location):
              StoryEvents.storyCtaTapped(storyId: story.storyId, target: location);
            case NetworkLinkFrameAction(url: final url):
              StoryEvents.storyCtaTapped(storyId: story.storyId, target: url);
            case NextStoryAction():
              break;
          }
        },
      ),
    );
  }
}
