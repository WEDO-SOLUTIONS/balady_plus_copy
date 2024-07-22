import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/app/routes/stories.dart';
import 'package:mapness/features/stories/providers/story_service.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/buttons/refresh_button.dart';
import 'package:mapness/widgets/stories/lib/stories_row.dart';

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
        if (firstFrame.imageUrl != null) {
          precacheImage(NetworkImage(firstFrame.imageUrl!), context);
        }
      }
    });
  }

  void openStory(BuildContext context, String id) {
    Metrics.logEventAdvanced(MetricsConstants.exploreKeys.storyBanner,
        group: MetricsConstants.exploreTag, action: MetricAction.tap.name, props: {'id': id});
    StoriesRoute.openById(context, storyId: id);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(networkStatusProvider, (wasAvailable, available) {
      // [wasAvailable] is nullable value. So we have to handle this value
      // If the network was available we use this value. Else we set default value `true`
      // By default we think that the user has network connection
      final _wasAvailable = wasAvailable ?? true;

      // If the network was not available bit now it is available => [becomeAvailable] = true
      final becomeAvailable = !_wasAvailable && available;
      if (becomeAvailable) {
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
        error: (_, __) => RefreshButton(
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
