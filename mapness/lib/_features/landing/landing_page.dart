import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/landing/controls.dart' as controls;
import 'package:mapness/_features/landing/dashboard.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/events.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';

enum LangingFocusMaker { iwish, mosques }

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({this.focusMaker, super.key});
  final LangingFocusMaker? focusMaker;

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  StreamSubscription<TapEvent>? _streamSubscription;
  bool needToShow = true;

  @override
  void initState() {
    super.initState();

    setupTapListener();

    switch (widget.focusMaker) {
      case LangingFocusMaker.iwish:
        () async {
          ref.read(layersControlsProvider.notifier).handleTap(LayerType.joy);
          try {
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
            // ignore: avoid_catches_without_on_clauses
          } catch (e) {
            // todo: make it better
            if (kDebugMode) {
              print(e);
            }
          }
        }();
      case LangingFocusMaker.mosques:
        Future.delayed(Duration.zero, () {
          ref.read(searchByRubricsQueryProvider.notifier).update(
            (
              QuickFilter(
                rubrics: [13374],
                title: 'المساجد',
                uiIcon: 'assets/icons/svg/quick_filters/ic_quick_mosques.svg',
                mapIcon: 'assets/icons/svg/quick_filters/mosques_pin.svg',
              ),
              1
            ),
          );
        });
      // ignore: no_default_cases
      default:
        break;
    }
  }

  Future<void> setupTapListener() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _streamSubscription =
        dgisController.objectTapEvents.listen(_objectTapListener);
  }

  @override
  void deactivate() {
    _streamSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final esri = MapObjectManagerSettings.esri();
    final mappness = MapObjectManagerSettings.mappness();
    ref
      ..watch(layersControlsProvider)
      ..watch(locationProvider.select((_) => null))
      ..watch(favouriteMarkersProvider.select((value) => null))

      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId)
          .notifier)
      // ref.watch(iwishMarkersProvider.select((value) => null));
      ..watch(mapObjectManagerProvider(
              named: mappness.name, layerId: mappness.layerId)
          .notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              const controls.MapControls(),
              LayoutBuilder(
                builder: (context, constraints) => Dashboard(
                  biggestHeight: constraints.biggest.height,
                  biggestWidth: constraints.biggest.width,

                  ///TODO: change while Dashboard refactoring
                  initWithMinSize: widget.focusMaker == LangingFocusMaker.iwish,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _objectTapListener(TapEvent event) {
    if (event is ObjectTapEvent) {
      ref.read(urbiMetricsProvider.notifier).logEvent(
        'Landing/objectTap',
        {'objectId': event.dgisObjectId.objectId},
      );
      if (context.mounted) {
        PoiMapRoute.open(
          ref.read(goRouterProvider),
          event.dgisObjectId.objectId,
          latLng: event.latLng,
          zoom: 19,
        );
      }
    } else if (event is RoadEventTapEvent) {
      EventsRoute.open(context, event);
    } else if (event is MyLocationTapEvent) {
      if (context.mounted) {
        PoiMapRoute.open(
          ref.read(goRouterProvider),
          -1,
          latLng: event.latLng,
          zoom: 17,
          bearing: 0,
          tilt: 0,
        );
      }
    }
  }
}
