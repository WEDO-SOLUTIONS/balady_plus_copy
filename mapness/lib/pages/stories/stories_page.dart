import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stories/models/stories_type_data.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/providers/story_service.dart';
import 'package:mapness/features/stories/ui/stories_fullscreen.dart';
import 'package:mapness/features/stories/ui/story_args_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

@RoutePage()
class StoriesPage extends ConsumerStatefulWidget {
  const StoriesPage({
    required this.type,
    this.onClose,
    this.initialStoryId,
    super.key,
  });

  final StoryTypes type;
  final VoidCallback? onClose;
  final String? initialStoryId;

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends ConsumerState<StoriesPage> {
  @override
  void initState() {
    super.initState();
    _reportOpenMetricaEvent();
  }

  void _onClose([int? index]) {
    widget.onClose?.call();
    ref.read(storyServiceProvider.notifier).resumeUpdate();

    if (context.router.canPop()) {
      context.router.pop();
    }
  }

  @override
  void dispose() {
    _reportCloseMetricsEvent();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyData = StoryTypedData.fromType(widget.type);
    return StoryArgsProvider(
      type: widget.type,
      onClose: _onClose,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: StoriesFullscreen(
            initialStoryId: widget.initialStoryId ?? storyData.stories.first.storyId,
          ),
        ),
      ),
    );
  }

  void _reportCloseMetricsEvent() {
    if (widget.type == StoryTypes.network) {
      Metrics.logEventAdvanced(
        MetricsConstants.exploreKeys.storiesClose,
        action: MetricAction.tap.name,
        group: MetricsConstants.exploreTag,
      );
    }
  }

  void _reportOpenMetricaEvent() {
    if (widget.type == StoryTypes.network) {
      Metrics.logEventAdvanced(
        MetricsConstants.exploreKeys.storyBanner,
        action: MetricAction.tap.name,
        group: MetricsConstants.exploreTag,
      );
      return;
    }
    if (widget.type == StoryTypes.route) {
      Metrics.logEventAdvanced(
        MetricsConstants.routesKeys.searchHistoryItem,
        action: MetricAction.tap.name,
        group: MetricsConstants.routesTag,
      );
    }
  }
}
