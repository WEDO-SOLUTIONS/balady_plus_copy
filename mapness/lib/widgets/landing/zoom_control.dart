import 'package:balady_uikit/balady_uikit.dart' hide MapButton;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/shared/providers/map/zoom_state.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class ZoomControl extends ConsumerWidget {
  const ZoomControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomState = ref.watch(zoomStateProvider);
    final zoomNotifier = ref.watch(zoomStateProvider.notifier);

    return Column(
      children: [
        MapButton(
          disabled: !zoomState.zoomInEnabled,
          onTapUp: (_) {
            ref.read(urbiAnalyticsProvider).track(
                  'mapInteraction',
                );
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);
            if (zoomState.zoomInEnabled) {
              zoomNotifier.onTapUp(ZoomControlType.zoomIn);
            }
          },
          onTapDown: (_) {
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);
            ref.read(urbiAnalyticsProvider).track(
                  'mapInteraction',
                );
            if (zoomState.zoomInEnabled) {
              zoomNotifier.onTapDown(ZoomControlType.zoomIn);
            }
          },
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: const AppIcons(iconData: SystemIcons.zoomPlus),
        ),
        MapButton(
          onTapUp: (_) {
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);
            ref.read(urbiAnalyticsProvider).track(
                  'mapInteraction',
                );
            if (zoomState.zoomOutEnabled) {
              zoomNotifier.onTapUp(ZoomControlType.zoomOut);
            }
          },
          onTapDown: (_) {
            ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);
            ref.read(urbiAnalyticsProvider).track(
                  'mapInteraction',
                );
            if (zoomState.zoomOutEnabled) {
              zoomNotifier.onTapDown(ZoomControlType.zoomOut);
            }
          },
          disabled: !zoomState.zoomOutEnabled,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: const AppIcons(iconData: SystemIcons.zoomMinus),
        ),
      ],
    );
  }
}
