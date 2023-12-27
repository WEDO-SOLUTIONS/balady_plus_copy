import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/layers_sheet.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

import 'controls.dart' as controls;
import 'dashboard.dart';

enum LangingFocusMaker { iwish, mosques }

class LandingPage extends ConsumerStatefulWidget {
  final LangingFocusMaker? focusMaker;

  const LandingPage({this.focusMaker, Key? key}) : super(key: key);

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  StreamSubscription<TapEvent>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription?.cancel();
    _streamSubscription = ref
        .watch(dgisControllerProvider)
        .value
        ?.objectTapEvents
        .listen(_objectTapListener);

    switch (widget.focusMaker) {
      case LangingFocusMaker.iwish:
        () async {
          final layersControls = ref.read(layersControlsProvider.notifier);
          layersControls.handleTap(LayerType.joy);
          try {
            // await layersControls.focusIwish();
            await ref.read(cameraPositionProvider.notifier).animateTo(
                  CameraPositionMessage(
                    point: GeoPointMessage(
                      latitude: 24.7113,
                      longitude: 46.6744,
                    ),
                    zoom: 11,
                    tilt: 0,
                    bearing: 0,
                  ),
                );
            // dgisController
          } catch (e) {
            // todo: make it better
            if (kDebugMode) {
              print(e);
            }
          }
        }();
        break;
      case LangingFocusMaker.mosques:
        Future.delayed(Duration.zero, () {
          ref.read(searchByRubricsQueryProvider.notifier).update((
            QuickFilter(
              rubrics: [13374],
              title: "المساجد",
              uiIcon: "assets/icons/svg/quick_filters/ic_quick_mosques.svg",
              mapIcon: "assets/icons/svg/quick_filters/mosques_pin.svg",
            ),
            1
          ));
        });
        break;
      default:
        break;
    }
  }

  @override
  void deactivate() {
    _streamSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final isLayersVisible = ref.watch(layersControlsProvider);
    ref.watch(favouriteMarkersProvider.select((value) => null));

    /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
    ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);
    // ref.watch(iwishMarkersProvider.select((value) => null));

    ref.watch(
      mapObjectManagerProvider(named: poiMapLayer),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              const controls.MapControls(),
              LayoutBuilder(builder: (context, constraints) {
                return Dashboard(
                  biggestHeight: constraints.biggest.height,
                  biggestWidth: constraints.biggest.width,
                );
              }),
              if (isLayersVisible.layersVisible) const LayersSheet()
            ],
          ),
        ),
      ),
    );
  }

  void _objectTapListener(TapEvent event) {
    if (event is ObjectTapEvent) {
      if (context.mounted) {
        final currentRoute = ref.read(currentRouteProvider);

        if (currentRoute == "/poi-map") {
          PoiMapRoute(dgisObjectId: event.dgisObjectId.objectId)
              .pushReplacement(context);
        } else {
          PoiMapRoute(dgisObjectId: event.dgisObjectId.objectId).push(context);
        }
      }
    }
  }
}
