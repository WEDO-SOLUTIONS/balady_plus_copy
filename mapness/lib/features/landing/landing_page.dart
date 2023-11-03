import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/happiness_map/hapiness_overlay.dart';
import 'package:mapness/features/landing/layers_sheet.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/legacy_features/poi_card/general_card_widget.dart';
import 'package:mapness/legacy_features/routing_page/routing_overlay.dart';

import '../map/map_page_new.dart';
import 'controls.dart' as controls;
import 'dashboard.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsState = ref.watch(mapControlsProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const MapPage(),
            if (controlsState.controlsVisible) const controls.MapControls(),
            if (controlsState.controlsVisible)
              LayoutBuilder(builder: (context, constraints) {
                return Dashboard(
                  biggestHeight: constraints.biggest.height,
                  biggestWidth: constraints.biggest.width,
                );
              }),
            switch (controlsState) {
              MapControlsStateLayers() => const LayersSheet(),
              MapControlsStateNavigation() => const RoutingOverlay(),
              MapControlsStateHappinessMap() => const HapinessOverlay(),
              MapControlsStatePoI(objectId: final objectId) =>
                GeneralMapCardWidget(objectId),
              _ => const SizedBox.shrink(),
            }
          ],
        ),
      ),
    );
  }
}
