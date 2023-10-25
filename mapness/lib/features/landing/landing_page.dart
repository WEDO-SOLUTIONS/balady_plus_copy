import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/happiness_map/happines_map_bottom_sheet.dart';
import 'package:mapness/features/landing/layers_sheet.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/legacy_features/routing_page/routing_overlay.dart';

import '../map/map_page_new.dart';
import 'controls.dart' as controls;
import 'dashboard.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsState = ref.watch(mapControlsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const MapPage(),
          if (controlsState.controlsVisible)
            LayoutBuilder(builder: (context, constraints) {
              return Dashboard(
                biggestHeight: constraints.biggest.height,
              );
            }),
          if (controlsState.controlsVisible) const controls.MapControls(),
          switch (controlsState) {
            MapControlsStateLayers() => const LayersSheet(),
            MapControlsStateNavigation() => const RoutingOverlay(),
            MapControlsStateHappinessMap() => HappinessBottomSheet(
                onClose: () => ref
                    .read(mapControlsProvider.notifier)
                    .update(MapControlsStateIdle()),
              ),
            _ => const SizedBox.shrink(),
          }
        ],
      ),
    );
  }
}
