import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/stories/data/story_service.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/presentation/frame/story_frames_player.dart';
import 'package:url_launcher/url_launcher.dart';

class StoriesFullscreen extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  final String initialStoryId;

  const StoriesFullscreen({
    required this.initialStoryId,
    required this.onClose,
    super.key,
  });

  @override
  ConsumerState<StoriesFullscreen> createState() => _StoriesFullscreenState();
}

class _StoriesFullscreenState extends ConsumerState<StoriesFullscreen> {
  late final PageController _storyController;
  late int initialPage;

  void _onChangeStory(int pageIndex, int length) {
    // precache next and previous stories

    if (pageIndex == 0) {
      widget.onClose();
    }
    _precacheStories();
  }

  Future<void> _precacheStories() async {
    final storiesAsync = ref.watch(storyServiceProvider);

    storiesAsync.whenData((data) {
      final nearStories = data.stories.skip(initialPage - 1).take(3);
      for (final story in nearStories) {
        final unseenFrames =
            story.frames.where((element) => element.isWatched == false).take(2);
        for (final element in unseenFrames) {
          precacheImage(NetworkImage(element.imageUrl), context);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialPage = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(storyServiceProvider.notifier);
    final stories = ref.read(storyServiceProvider).value?.stories ?? const [];
    final index = stories.length -
        stories.indexWhere(
          (element) => element.storyId == widget.initialStoryId,
        );
    _storyController = PageController(initialPage: index);
    setState(() {
      initialPage = index;
    });
  }

  // @override
  // void dispose() {
  //   _storyController.dispose();
  //   super.dispose();
  // }

  void _nextStory() {
    _storyController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousStory() {
    _storyController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onActionPressed(StoryFrameAction action, BuildContext context) {
    switch (action.type) {
      case FrameActionType.openDeepLink:
        if (context.mounted) {
          context.pushNamed(action.action);
        }
        break;
      case FrameActionType.openMap:
        // Handle it
        break;
      case FrameActionType.callPhone:
        launchUrl(Uri.parse('tel:${action.action}'));
        break;
      case FrameActionType.openUrl:
        launchUrl(Uri.parse(action.action));
        break;
    }
  }

  Future<void> onClose() async {
    await ref.read(storyServiceProvider.notifier).sendViewedStories();

    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    const blank = SizedBox.shrink();
    final storiesAsync = ref.watch(storyServiceProvider);

    return storiesAsync.when(
      error: (_, __) => blank,
      loading: () => blank,
      data: (storiesData) {
        final stories = storiesData.stories;

        return CubePageView(
          onPageChanged: (index) => _onChangeStory(index, stories.length),
          controller: _storyController,
          startPage: initialPage,
          children: [
            blank,
            ...stories.reversed.map(
              (story) => StoryFramesPlayer(
                onActionPressed: (action) => onActionPressed(action, context),
                story: story,
                onNextStory: _previousStory,
                onPreviousStory: _nextStory,
                onClose: onClose,
              ),
            ),
            // blank,
          ],
        );
      },
    );
  }
}
