import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/stories/data/story_service.dart';
import 'package:mapness/_features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/_features/stories/presentation/frame/story_frames_player.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'frame/story_frame_controller.dart';

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

class _StoriesFullscreenState extends ConsumerState<StoriesFullscreen>
    with WidgetsBindingObserver {
  late int initialPage;

  late final StoryFrameController _storyFrameController;
  late final IndexController _indexController;

  void _onChangeStory(_, int length) {
    if (initialPage == -1 || initialPage + 1 == length) {
      onClose();
    }
    _precacheStories();
  }

  Future<void> _precacheStories() async {
    ref.read(storyServiceProvider).whenData((data) {
      final nearStories = data.skip(initialPage);

      for (final story in nearStories) {
        final unseenFrames = story.frames.take(2);

        for (final element in unseenFrames) {
          precacheImage(NetworkImage(element.imageUrl), context);
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _storyFrameController.play?.call();
    } else {
      _storyFrameController.pause?.call();
    }
  }

  @override
  void initState() {
    super.initState();
    _storyFrameController = StoryFrameController();
    final stories = ref.read(storyServiceProvider).value ?? const [];
    final index = stories.indexWhere(
      (element) => element.storyId == widget.initialStoryId,
    );
    _indexController = IndexController();

    initialPage = index;

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _storyFrameController.dispose();
    _indexController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.read(storyServiceProvider.notifier).pauseUpdate();
  }

  void _nextStory() {
    _indexController.next();
    setState(() {
      initialPage++;
    });
  }

  void _previousStory() {
    _indexController.previous();
    setState(() {
      initialPage--;
    });
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

        return Material(
          color: context.color.surfaceBaseInversePrimary,
          child: Directionality(
            textDirection: direction,
            child: TransformerPageView(
              onPageChanged: (index) =>
                  index == null ? null : _onChangeStory(index, stories.length),
              index: initialPage,
              controller: _indexController,
              transformer:
                  DepthPageTransformer(isRtl: direction == TextDirection.rtl),
              itemCount: stories.length,
              itemBuilder: (context, index) => StoryFramesPlayer(
                controller: _storyFrameController,
                onActionPressed: (action) => onActionPressed(action, context),
                story: stories[index],
                onNextStory: _nextStory,
                onPreviousStory: _previousStory,
                onClose: onClose,
              ),
            ),
          ),
        );
      },
    );
  }
}

class DepthPageTransformer extends PageTransformer {
  final bool isRtl;

  DepthPageTransformer({this.isRtl = false}) : super(reverse: false);

  @override
  Widget transform(Widget child, TransformInfo info) {
    final position = info.position!;

    if (position >= 0) {
      return Opacity(
        opacity: 1.0,
        child: Transform.translate(
          offset: Offset.zero,
          child: Transform.scale(
            scale: 1.0,
            child: child,
          ),
        ),
      );
    } else if (position >= -1) {
      const minScale = 0.75;
      // Scale the page down (between minScale and 1)
      final scaleFactor = minScale + (1 - minScale) * (1 + position);

      final offsetX = isRtl ? info.width! * position : info.width! * -position;

      return Opacity(
        opacity: 1.0 + position,
        child: Transform.translate(
          offset: Offset(offsetX, 0.0),
          child: Transform.scale(
            scale: scaleFactor,
            child: child,
          ),
        ),
      );
    }

    return child;
  }
}
