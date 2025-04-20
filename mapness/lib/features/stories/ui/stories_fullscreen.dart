import 'dart:async';

import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/stories/models/story_data.dart';
import 'package:mapness/features/stories/models/story_frame_controller.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/providers/local_stories_service.dart';
import 'package:mapness/features/stories/providers/story_service.dart';
import 'package:mapness/features/stories/ui/story_args_provider.dart';
import 'package:mapness/features/stories/ui/story_frames_player.dart';

class StoriesFullscreen extends ConsumerStatefulWidget {
  final String initialStoryId;

  const StoriesFullscreen({
    required this.initialStoryId,
    super.key,
  });

  @override
  ConsumerState<StoriesFullscreen> createState() => _StoriesFullscreenState();
}

class _StoriesFullscreenState extends ConsumerState<StoriesFullscreen> {
  late int _currentPage;
  late int _maxPages;

  late final StoryFrameController _storyFrameController;
  late final IndexController _indexController;

  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);
  late final Future<List<StoryData>> _storiesData;

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
        return;
      }
      if (_indexController.event == IndexController.previousEvent) {
        _setCurrentPage(_currentPage - 1);
      }
    });
  }

  @override
  void dispose() {
    _storyFrameController.dispose();
    _indexController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(storyServiceProvider.notifier).pauseUpdate();
    final type = StoryArgsProvider.of(context).type;
    _storiesData = _initStories(type);
  }

  void _setCurrentPage(int page) {
    if (!mounted) {
      return;
    }
    if (page <= -1 || page >= _maxPages) {
      ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.onboardingStoriesCompleted);
      _onClose();
      if (page < 0) {
        ref.read(appAnalyticsProvider).onboardingFlowSkipped();
      }
    }

    if (page >= _maxPages) {
      ref.read(appAnalyticsProvider).onboardingFlowCompleted();
    }

    _currentPage = page;
    _currentPageNotifier.value = _currentPage;
  }

  Future<List<StoryData>> _loadStories(StoryTypes type) async {
    if (type == StoryTypes.network) {
      return ref.read(storyServiceProvider.future);
    }
    if (type.file == null) {
      return [];
    }
    return ref.read(localStoriesServiceProvider(type.file!).future);
  }

  Future<List<StoryData>> _initStories(StoryTypes type) async {
    final List<StoryData> stories = await _loadStories(type);

    final index = stories.indexWhere(
      (element) => element.storyId == widget.initialStoryId,
    );

    _maxPages = stories.length;

    _setCurrentPage(index != -1 ? index : 0);
    return stories;
  }

  void _nextStory() {
    if (_currentPage + 1 >= _maxPages) {
      ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.onboardingStoriesCompleted);
      ref.read(appAnalyticsProvider).onboardingFlowCompleted();
      _onClose();
      return;
    }
    _indexController.next(animation: false);
  }

  void _previousStory() {
    if (_currentPage - 1 < 0) {
      _onClose();
      return;
    }
    _indexController.previous(animation: false);
  }

  void _onClose() {
    StoryArgsProvider.of(context).onClose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<StoryData>>(
        future: _storiesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
              color: context.color.surfaceBaseInversePrimary,
              child: Center(
                child: Loading.medium(),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final stories = snapshot.data ?? const [];
          return ValueListenableBuilder(
            valueListenable: _currentPageNotifier,
            builder: (_, page, __) => TransformerPageView(
              onPageChanged: (index) => index == null ? null : _setCurrentPage(index),
              index: page,
              controller: _indexController,
              itemCount: stories.length,
              itemBuilder: (_, index) => StoryFramesPlayer(
                controller: _storyFrameController,
                story: stories[index],
                onNextStory: _nextStory,
                onPreviousStory: _previousStory,
              ),
            ),
          );
        },
      );
}
