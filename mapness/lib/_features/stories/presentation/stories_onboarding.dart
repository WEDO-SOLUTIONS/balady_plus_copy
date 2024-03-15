import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/stories/data/local_stories_service.dart';
import 'package:mapness/_features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/_features/stories/domain/story_action.dart';
import 'package:mapness/_features/stories/domain/story_types.dart';
import 'package:mapness/_features/stories/presentation/frame/story_frame_controller.dart';
import 'package:mapness/_features/stories/presentation/frame/story_frames_player.dart';

class StoriesOnboarding extends ConsumerStatefulWidget {
  const StoriesOnboarding({
    required this.initialStoryId,
    required this.onClose,
    this.type = StoryTypes.route,
    super.key,
  });
  final VoidCallback onClose;
  final String initialStoryId;
  final StoryTypes type;

  @override
  ConsumerState<StoriesOnboarding> createState() => _StoriesOnboardingState();
}

class _StoriesOnboardingState extends ConsumerState<StoriesOnboarding> {
  late final PageController _storyController;
  late int initialPage;
  late final StoryFrameController _frameController;

  void _onChangeStory(int pageIndex, int length) {
    if (pageIndex == 0 || pageIndex == length + 1) {
      widget.onClose();
    }
  }

  @override
  void initState() {
    super.initState();
    initialPage = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final stories =
        ref.read(localStoriesServiceProvider(widget.type.file)).value ??
            const [];
    final index = stories.indexWhere(
          (element) => element.storyId == widget.initialStoryId,
        ) +
        1;
    _storyController = PageController(initialPage: index);
    _frameController = StoryFrameController();
    setState(() {
      initialPage = index;
    });

    _storyController.addListener(
      () {
        final index = _storyController.page?.round() ?? 0;
        if (index == 0 || index == stories.length + 1) {
          widget.onClose();
        }
      },
    );
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
    switch (action.action) {
      case StoryAction.next:
        _frameController.nextPage?.call();

      case null:
      case StoryAction.close:
      case StoryAction.deeplink:
      case StoryAction.route:
        onClose();
        break;
    }
  }

  Future<void> onClose() async {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    const blank = SizedBox.shrink();
    final storiesAsync =
        ref.watch(localStoriesServiceProvider(widget.type.file));

    return storiesAsync.when(
      error: (_, __) => blank,
      loading: () => blank,
      data: (storiesData) {
        final stories = storiesData;

        return CubePageView(
          onPageChanged: (index) => _onChangeStory(index, stories.length),
          controller: _storyController,
          startPage: initialPage,
          children: [
            ...stories.map(
              (story) => StoryFramesPlayer(
                controller: _frameController,
                onActionPressed: (action) => onActionPressed(action, context),
                story: story,
                onNextStory: _previousStory,
                onPreviousStory: _nextStory,
                onClose: onClose,
                onMarkReed: (_, __) {},
              ),
            ),
            blank,
          ],
        );
      },
    );
  }
}
