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
import 'package:mapness/features/stories/ui/story_video_player.dart';

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
              itemBuilder: (context, index) => stories[index].videos.isNotEmpty
                  ? StoryVideoPlayer(
                      videoUrls: stories[index].videos.map((e) => e.url).toList(),
                      // videoUrls: [
                      //   "https://rr5---sn-npoeenek.googlevideo.com/videoplayback?expire=1747693236&ei=VForaNrbG5iA2roP3bDUmQ8&ip=2401%3A4900%3A7522%3A24d0%3A119%3Ab481%3Ad5c3%3A186&id=o-ALzT6J1EQWrItsNMHogpWq4sRbBUSlT297J3mUDlpo4Z&itag=18&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&pcm2=yes&bui=AecWEAaYcGnD4TgHe4RMwhFyxEjdyyYEcoafIuwpIgpvPSkdfYFDoI3UMr-IxdCYhO3hr6_iiSVShpYJ&vprv=1&svpuc=1&mime=video%2Fmp4&ns=PvuJFzpBPY75yPq8f_JIHM0Q&rqh=1&gir=yes&clen=4545658&ratebypass=yes&dur=60.330&lmt=1747614447839707&lmw=1&c=TVHTML5&sefc=1&txp=4430534&n=av9s9jJr8JHsSw&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cpcm2%2Cbui%2Cvprv%2Csvpuc%2Cmime%2Cns%2Crqh%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=AJfQdSswRQIhAJrRQLnxaJTye_K1hmz_CbdScqqXxhVZN_7rK7SPe6qhAiAYBYf7K5acGogPhDucyxFY6uMNhlEm355CXqIrqKor0Q%3D%3D&title=ШОКИРУЮЩИЙ%20МЕТОД%20тренировки%20мышц%20РУК%20шаолиньских%20монахов!&rm=sn-ci5gup-b50e7s,sn-ci5gup-cvhk7k,sn-cvhzs7z&rrc=79,79,104&fexp=24350590,24350737,24350827,24350961,24351173,24351177,24351495,24351528,24351594,24351638,24351658,24351661,24351662,24351759,24351789,24351864,24351866,24351907,24351983,24352018,24352020,24352023,24352031&req_id=4b888efc5464a3ee&cmsv=e&rms=nxu,au&redirect_counter=3&cms_redirect=yes&ipbypass=yes&met=1747671903,&mh=_8&mip=159.192.33.11&mm=30&mn=sn-npoeenek&ms=nxu&mt=1747671637&mv=m&mvi=5&pl=24&lsparams=ipbypass,met,mh,mip,mm,mn,ms,mv,mvi,pl,rms&lsig=ACuhMU0wRgIhAL0DFMJstVj8gOcBf0PpVk6eUlQaTreJ5k792My8rahgAiEA_sduLo-Y6hVHIAdPXwIDoiVwGrjOAWtwEZPaX5hWg6A%3D",
                      //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                      //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                      //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                      //   "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                      // ],
                      onNextStory: _nextStory,
                      onPreviousStory: _previousStory,
                    )
                  : StoryFramesPlayer(
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
