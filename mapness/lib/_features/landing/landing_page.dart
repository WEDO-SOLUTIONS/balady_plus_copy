import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/landing/layers_sheet.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/map/providers/dgis_controller.dart';
import 'package:mapness/_features/routing_page/routing_overlay.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

import '../map/map_page_new.dart';
import 'controls.dart' as controls;
import 'dashboard.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  StreamSubscription<TapEvent>? _streamSubscription;

  @override
  void deactivate() {
    _streamSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final controlsState = ref.watch(mapControlsProvider);
    final currentRoute = ref.watch(currentRouteProvider);

    final controlsVisible =
        controlsState.controlsVisible && currentRoute == '/landing';
    ref.watch(favouriteMarkersProvider);
    _streamSubscription?.cancel();
    _streamSubscription = ref
        .watch(dgisControllerProvider)
        ?.objectTapEvents
        .listen(_objectTapListener);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const MapPage(),
            const controls.MapControls(),
            if (controlsVisible)
              LayoutBuilder(builder: (context, constraints) {
                return Dashboard(
                  biggestHeight: constraints.biggest.height,
                  biggestWidth: constraints.biggest.width,
                );
              }),
            switch (controlsState) {
              MapControlsStateLayers() => const LayersSheet(),
              MapControlsStateNavigation() => const RoutingOverlay(),
              _ => const SizedBox.shrink(),
            },
          ],
        ),
      ),
    );
  }

  void _objectTapListener(TapEvent event) {
    if (event is ObjectTapEvent) {
      if (context.mounted) {
        final currentRoute = ref.read(currentRouteProvider);

        if (currentRoute == "/poi-map") {
          context.pop();
          PoiMapRoute(dgisObjectId: event.dgisObjectId.objectId).push(context);
        } else {
          PoiMapRoute(dgisObjectId: event.dgisObjectId.objectId).push(context);
        }
      }
    }
  }
}
