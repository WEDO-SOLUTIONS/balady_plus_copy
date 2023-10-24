import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/happiness_map/happines_map_bottom_sheet.dart';
import 'package:mapness/features/landing/layers_sheet.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/legacy/routing_page/routing_overlay.dart';

import '../map/map_page_new.dart';
import 'controls.dart' as controls;
import 'dashboard.dart';

class LandingPage extends ConsumerWidget {
  LandingPage({Key? key}) : super(key: key);

  final GlobalKey<LayersSheetState> _layersSheetKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsState = ref.watch(mapControlsProvider);

    return Scaffold(
      body: Stack(
        children: [
          const MapPage(),
          if (controlsState != MapControlsState.navigation) const Dashboard(),
          if (controlsState != MapControlsState.navigation)
            controls.MapControls(
              layersState: _layersSheetKey,
            ),
          if (controlsState != MapControlsState.navigation)
            LayersSheet(
              key: _layersSheetKey,
            ),
          if (controlsState == MapControlsState.navigation)
            const RoutingOverlay(),
          if (controlsState == MapControlsState.happinessMap)
            HappinessBottomSheet(
              onClose: () => ref
                  .read(mapControlsProvider.notifier)
                  .update(MapControlsState.idle),
            ),
        ],
      ),
    );
  }
}
