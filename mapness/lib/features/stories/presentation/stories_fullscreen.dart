import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stories/data/local_stories_service.dart';
import 'package:mapness/features/stories/data/story_service.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/story_data.dart';
import 'package:mapness/features/stories/domain/story_types.dart';
import 'package:mapness/features/stories/presentation/frame/story_frames_player.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'frame/story_frame_controller.dart';

class StoriesFullscreen extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  final String initialStoryId;
  final StoryTypes? localStoryType;
  final void Function(String)? handleDeeplink;

  const StoriesFullscreen({
    required this.initialStoryId,
    required this.onClose,
    this.handleDeeplink,
    this.localStoryType,
    super.key,
  });

  @override
  ConsumerState<StoriesFullscreen> createState() => _StoriesFullscreenState();
}

class _StoriesFullscreenState extends ConsumerState<StoriesFullscreen>
    with WidgetsBindingObserver {
  late int _currentPage;
  late int _maxPages;

  late final StoryFrameController _storyFrameController;
  late final IndexController _indexController;

  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

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

    ref.read(storyServiceProvider.notifier).pauseUpdate();
    _storyFrameController = StoryFrameController();
    _indexController = IndexController();

    _indexController.addListener(() {
      if (!mounted) {
        return;
      }
      if (_indexController.event == IndexController.nextEvent) {
        _setCurrentPage(_currentPage + 1);
      } else if (_indexController.event == IndexController.previousEvent) {
        _setCurrentPage(_currentPage - 1);
      }
    });
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

  void _setCurrentPage(int page) {
    if (!mounted) {
      return;
    }
    if (page <= -1 || page >= _maxPages) {
      onClose();
    }

    _currentPage = page;
    _currentPageNotifier.value = _currentPage;
  }

  void _onChangeStory(int page, int length) {
    _setCurrentPage(page);
  }

  Future<List<StoryData>> _initStories() async {
    final stories = (widget.localStoryType?.file != null
        ? await ref.read(
            localStoriesServiceProvider(widget.localStoryType!.file).future)
        : await ref.read(storyServiceProvider.future));
    final index = stories.indexWhere(
      (element) => element.storyId == widget.initialStoryId,
    );

    _maxPages = stories.length;

    _setCurrentPage(index != -1 ? index : 0);
    return stories;
  }

  void _nextStory() {
    if (_currentPage + 1 >= _maxPages) {
      onClose();
      return;
    }
    _indexController.next(animation: false);
  }

  void _previousStory() {
    if (_currentPage - 1 < 0) {
      onClose();
      return;
    }
    _indexController.previous(animation: false);
  }

  void onActionPressed(StoryFrameAction action, BuildContext context) {
    if (widget.handleDeeplink != null) {
      widget.handleDeeplink?.call(action.deeplinkUrl);
      onClose();
    }
  }

  Future<void> onClose() async {
    ref.read(storyServiceProvider.notifier).resumeUpdate();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    const blank = SizedBox.shrink();

    return FutureBuilder<List<StoryData>>(
      future: _initStories(),

      // ignore: prefer_expression_function_bodies
      builder: (context, snapshot) {
        final stories = snapshot.data ?? const [];
        return !snapshot.hasData
            ? blank
            : Material(
                color: context.color.surfaceBaseInversePrimary,
                child: Directionality(
                  textDirection: Directionality.of(context),
                  child: ValueListenableBuilder(
                      valueListenable: _currentPageNotifier,
                      builder: (context, page, _) => TransformerPageView(
                            onPageChanged: (index) => index == null
                                ? null
                                : _onChangeStory(index, stories.length),
                            index: page,
                            controller: _indexController,
                            transformer: DepthPageTransformer(
                                isRtl: Directionality.of(context) ==
                                    TextDirection.rtl),
                            itemCount: stories.length,
                            itemBuilder: (context, index) => StoryFramesPlayer(
                              controller: _storyFrameController,
                              onActionPressed: (action) =>
                                  onActionPressed(action, context),
                              story: stories[index],
                              onNextStory: _nextStory,
                              onPreviousStory: _previousStory,
                              onClose: onClose,
                            ),
                          )),
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
