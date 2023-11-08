import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
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
    if (pageIndex == 0 || pageIndex == length + 1) {
      widget.onClose();
    }
    _precacheStories();
  }

  Future<void> _precacheStories() async {
    final storiesAsync = ref.watch(storyServiceProvider);

    storiesAsync.whenData((data) {
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
          // TODO(@Demezy): уточнить формат диплинков
          // context.pushNamed(action.action);
        }
        break;
      case FrameActionType.openMap:
        final objectId = int.tryParse(action.action);
        if (objectId != null) {
          ref.watch(mapControlsProvider.notifier).update(
                MapControlsStatePoI(
                  DgisObjectIdMessage(objectId: objectId, entranceId: 0),
                ),
              );
        }
        break;
      case FrameActionType.callPhone:
        launchUrl(Uri.parse('tel:${action.action}'));
        break;
      case FrameActionType.openUrl:
        launchUrl(Uri.parse(action.action));
        break;
    }
    onClose();
  }

  Future<void> onClose() async {
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

        return CubePageView(
          onPageChanged: (index) => _onChangeStory(index, stories.length),
          controller: _storyController,
          startPage: initialPage,
          children: [
            blank,
            ...stories.map(
              (story) => StoryFramesPlayer(
                onActionPressed: (action) => onActionPressed(action, context),
                story: story,
                onNextStory: _previousStory,
                onPreviousStory: _nextStory,
                onClose: onClose,
              ),
            ),
            blank,
          ],
        );
      },
    );
  }
}
