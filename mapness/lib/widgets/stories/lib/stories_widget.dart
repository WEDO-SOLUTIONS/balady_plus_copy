import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/providers/stories_open_state.dart';
import 'package:mapness/features/stories/providers/story_service.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/widgets/stories/lib/stories_row.dart';

class StoriesWidget extends ConsumerStatefulWidget {
  final Widget? titleWidget;

  const StoriesWidget({
    this.titleWidget,
    super.key,
  });

  @override
  ConsumerState<StoriesWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends ConsumerState<StoriesWidget> with AutomaticKeepAliveClientMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheFirstFrame();
  }

  void _precacheFirstFrame() {
    ref.read(storyServiceProvider).whenData((data) {
      for (final story in data) {
        if (story.frames.isEmpty) {
          continue;
        }
        if (!context.mounted) {
          return;
        }
        final firstFrame = story.frames.first;
        final imageUrl = firstFrame.imageUrlForLocale(Directionality.of(context));
        if (imageUrl != null) {
          precacheImage(NetworkImage(imageUrl), context);
        }
      }
    });
  }

  void _openStory(BuildContext context, String id) {
    Metrics.logEventAdvanced(
      MetricsConstants.exploreKeys.storyBanner,
      group: MetricsConstants.exploreTag,
      action: MetricAction.tap.name,
      props: {'id': id},
    );

    ref.read(storiesOpenStateProvider.notifier).open();
    ref.read(appRouterProvider).push(
          StoriesRoute(
            type: StoryTypes.network,
            initialStoryId: id,
            onClose: ref.read(storiesOpenStateProvider.notifier).close,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
    final titleWidget = widget.titleWidget;

    return Directionality(
      textDirection: Directionality.of(context),
      child: Column(
        children: [
          if (titleWidget != null) titleWidget,
          thumbnails.maybeWhen(
            data: (data) => StoriesRow(
              onThumbnailPressed: (id) => _openStory(context, id),
              stories: data,
            ),
            orElse: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            skipLoadingOnReload: true,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
