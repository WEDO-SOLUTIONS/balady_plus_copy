import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/providers/map/traffic_state.dart';
import 'package:mapness/shared/ui/map_controls/traffic_control.dart';

class TrafficControl extends ConsumerWidget {
  const TrafficControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trafficState = ref.watch(trafficStateProvider);
    final isEnabled = trafficState.status == TrafficControlStatus.enabled;

    return TrafficControlWidget(
      opacity: trafficState.status == TrafficControlStatus.hidden ? 0 : 1,
      isEnabled: isEnabled,
      // BALADY-3615: route through LayersControls.toggleTraffic instead of
      // flipping trafficStateProvider directly. The direct flip bypassed the
      // overlay mutex and selectedType bookkeeping, so traffic enabled from
      // the landing button coexisted with any overlay enabled from the
      // layers sheet (both tiles highlighted, both layers rendered).
      // toggleTraffic also logs the same metric this button used to log.
      onTap: () => ref.read(layersControlsProvider.notifier).toggleTraffic(),
    );
  }
}
