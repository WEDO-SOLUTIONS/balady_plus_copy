import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/stories/data/story_service.dart';
import 'package:mapness/_features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/_features/stories/presentation/frame/story_frames_player.dart';

class StoriesFullscreen extends ConsumerStatefulWidget {

  const StoriesFullscreen({
    required this.handleDeeplink,
    required this.initialStoryId,
    required this.onClose,
    super.key,
  });
  final VoidCallback onClose;
  final String initialStoryId;

  /// TODO(Demezy): rewrite to router
  final void Function(String) handleDeeplink;

  @override
  ConsumerState<StoriesFullscreen> createState() => _StoriesFullscreenState();
}

class _StoriesFullscreenState extends ConsumerState<StoriesFullscreen> {
  late final PageController _storyController;
  late int initialPage;

  void _onChangeStory(int pageIndex, int length) {
    if (pageIndex == 0 || pageIndex == length + 1) {
      onClose();
    }
    _precacheStories();
  }

  Future<void> _precacheStories() async {
    ref.read(storyServiceProvider).whenData((data) {
      final nearStories = data.skip(initialPage - 1).take(3);

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
    final stories = ref.read(storyServiceProvider).value ?? const [];
    final index = stories.indexWhere(
          (element) => element.storyId == widget.initialStoryId,
        ) +
        1;
    _storyController = PageController(initialPage: index);
    setState(() {
      initialPage = index;
    });
    ref.read(storyServiceProvider.notifier).pauseUpdate();
  }

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
    widget.handleDeeplink(action.deeplinkUrl);
    // context.replace(action.deeplinkUrl);
    onClose();
  }

  Future<void> onClose() async {
    ref.read(storyServiceProvider.notifier).resumeUpdate();
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
        final stories = storiesData;
        final direction = ref.read(uiDirectionProvider);

        return Directionality(
          textDirection: direction,
          child: CubePageView(
            onPageChanged: (index) => _onChangeStory(index, stories.length),
            controller: _storyController,
            startPage: initialPage,
            children: [
              blank,
              ...stories.map(
                (story) => StoryFramesPlayer(
                  onActionPressed: (action) => onActionPressed(action, context),
                  story: story,
                  onNextStory: _nextStory,
                  onPreviousStory: _previousStory,
                  onClose: onClose,
                ),
              ),
              blank,
            ],
          ),
        );
      },
    );
  }
}
