import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/stories/models/stories_type_data.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/providers/story_service.dart';
import 'package:mapness/features/stories/ui/stories_fullscreen.dart';
import 'package:mapness/features/stories/ui/story_args_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:provider/provider.dart';

@RoutePage()
class StoriesPage extends ConsumerStatefulWidget {
  const StoriesPage({
    required this.type,
    this.onClose,
    this.initialStoryId,
    this.showSoundIcon = true,
    this.useNavigatorPop = false,
    super.key,
  });

  final StoryTypes type;
  final VoidCallback? onClose;
  final String? initialStoryId;

  /// Whether to show the sound/mute icon in video player.
  final bool showSoundIcon;

  /// Whether to use Navigator.pop() instead of auto_route for closing.
  /// Set to true when page is opened via MaterialPageRoute (e.g., ThemeSplashPage).
  final bool useNavigatorPop;

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
    ref.read(storyServiceProvider.notifier).resumeUpdate();

    // Call onClose callback for side effects (e.g., marking splash as shown)
    // Wrap in try-catch to ensure navigation still happens if callback fails
    try {
      widget.onClose?.call();
    } catch (_) {
      // Ignore callback errors
    }

    // Use Navigator.pop() for pages opened via MaterialPageRoute (e.g., ThemeSplashPage)
    // Use rootNavigatorKey to ensure we pop from the correct navigator
    if (widget.useNavigatorPop) {
      rootNavigatorKey.currentState?.pop();
      return;
    }

    if (context.router.canPop()) {
      context.router.back();
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
          value: context.read<ThemeController>().systemOverlayStyle,
          child: StoriesFullscreen(
            initialStoryId: widget.initialStoryId ?? storyData.stories.first.storyId,
            showSoundIcon: widget.showSoundIcon,
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
