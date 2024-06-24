import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/features/stories/data/story_service.dart';
import 'package:mapness/features/stories/presentation/stories_row.dart';
import 'package:mapness/features/stories/presentation/story_refresh_button.dart';
import 'package:mapness/features/stories/stories.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class StoriesWidget extends ConsumerStatefulWidget {
  const StoriesWidget({super.key});

  @override
  ConsumerState<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends ConsumerState<StoriesWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheFirstFrame();
  }

  void _precacheFirstFrame() {
    ref.read(storyServiceProvider).whenData((data) {
      for (final story in data) {
        final firstFrame = story.frames.first;
        precacheImage(NetworkImage(firstFrame.imageUrl), context);
      }
    });
  }

  void openStory(BuildContext context, String id) {
    Metrics.logEventAdvanced(MetricsConstants.exploreKeys.storyBanner,
        group: MetricsConstants.exploreTag, action: MetricAction.tap.name, props: {'id': id});
    Stories.showStoryById(context, id);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(networkStatusProvider, (previous, next) {
      if (previous == false && next != previous) {
        ref.read(storyServiceProvider.notifier).refresh();
      }
    });

    final thumbnails = ref.watch(storyServiceProvider);

    return Directionality(
      textDirection: Directionality.of(context),
      child: thumbnails.maybeWhen(
        data: (data) => StoriesRow(
          onThumbnailPressed: (id) => openStory(context, id),
          stories: data,
        ),
        orElse: () => const SizedBox.shrink(),
        error: (_, __) => StoryRefreshButton(
          onPressed: () {
            Metrics.logEventAdvanced(
              MetricsConstants.exploreKeys.storiesRefresh,
              group: MetricsConstants.exploreTag,
              action: MetricAction.tap.name,
            );

            ref.read(storyServiceProvider.notifier).refresh();
          },
        ),
        skipLoadingOnReload: true,
      ),
    );
  }
}
