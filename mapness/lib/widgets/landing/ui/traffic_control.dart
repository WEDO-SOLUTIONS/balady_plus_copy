import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart';

class TrafficControl extends ConsumerWidget {
  static const _tag = MetricsConstants.exploreTag;

  const TrafficControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trafficState = ref.watch(trafficStateProvider);
    final trafficNotifier = ref.read(trafficStateProvider.notifier);
    final isEnabled = trafficState.status == TrafficControlStatus.enabled;

    return uikit.TrafficControl(
      // TODO(Ayat) figure out why the traffic display began to appear incorrectly when updating SDK to 12.3.0
      // opacity: trafficState.status == TrafficControlStatus.hidden ? 0 : 1,
      opacity: 1,
      isEnabled: isEnabled,
      onTap: () {
        Metrics.logEventAdvanced(
          MetricsConstants.exploreKeys.trafficLightButton,
          group: _tag,
          action: MetricAction.tap.name,
        );
        trafficNotifier.onTrafficTap();
      },
    );
  }
}
