import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/landing/controls.dart' as controls;
import 'package:mapness/_features/landing/dashboard.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/esri_layers.dart';
import 'package:mapness/app/routes/events.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/features/quick_filters/providers/quick_filters_data.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/router_extension.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

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
  final ValueNotifier<bool> _onScroll = ValueNotifier(false);
  late final DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    super.initState();

    _draggableScrollableController = DraggableScrollableController();
    setupTapListener();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculatePadding();
    });

    switch (widget.focusMaker) {
      case LangingFocusMaker.iwish:
        () async {
          if (ref.read(layersControlsProvider).selectedType != LayerType.joy) {
            ref.read(layersControlsProvider.notifier).handleTap(LayerType.joy);
          }
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
          ref.read(searchByRubricsQueryProvider.notifier).selectFilter(QuickFilterType.mosques);
        });
      // ignore: no_default_cases
      default:
        break;
    }
  }

  Future<void> setupTapListener() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _streamSubscription = dgisController.objectTapEvents.listen(_objectTapListener);
  }

  void _calculatePadding() {
    ref.read(cameraPaddingProvider.notifier).resetPadding();
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    _onScroll.dispose();
    super.dispose();
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
      ..watch(currentRouteProvider.select((value) => null))
      ..watch(layersControlsProvider)
      ..watch(locationProvider.select((_) => null))
      ..watch(favouriteMarkersProvider.select((value) => null))
      ..listen(currentRouteProvider, (_, next) {
        const landingPage = '/landing';
        Future.delayed(const Duration(milliseconds: 250), () {
          _calculatePadding();
        });

        if (next?.currentPath == landingPage) {
          _onScroll
            ..value = true
            ..value = false;
        }
      })

      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      // ref.watch(iwishMarkersProvider.select((value) => null));
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: _onScroll,
                builder: (context, _, __) => controls.MapControls(
                  draggableScrollableController: _draggableScrollableController,
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => Dashboard(
                  scrollableController: _draggableScrollableController,
                  biggestHeight: constraints.biggest.height,
                  biggestWidth: constraints.biggest.width,
                  onScroll: (value) {
                    _onScroll.value = value;
                  },

                  ///TODO: change while Dashboard refactoring
                  initWithMinSize:
                      widget.focusMaker == LangingFocusMaker.iwish || widget.focusMaker == LangingFocusMaker.mosques,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _objectTapListener(TapEvent event) {
    final currentRoute = ref.watch(currentRouteProvider);

    const landingPagePath = '/landing';
    const routingRoutePath = '/routingRoutes';

    ///TODO: need to refactor after Dashboard refactoring to designSystem
    ///Ignore hide dashboard tap from other pages
    if (_draggableScrollableController.size > 0.13 && currentRoute?.currentPath == landingPagePath) {
      _hideDashboard(event);
    } else {
      final goRouter = ref.read(goRouterProvider);
      if (goRouter.isCurrentRoute(RoutingMapRoute.path)) {
        return;
      } else if (goRouter.isCurrentRoute(EsriLayersRoute.path)) {
        ///Close Esri Layers page
        if (context.mounted) {
          context.pop();
          return;
        }
      }
      if (event is ObjectTapEvent) {
        Metrics.logEventAdvanced(MetricsConstants.poiKeys.map,
            group: MetricsConstants.poiTag,
            action: MetricAction.tap.toString(),
            props: {
              'objectId': event.dgisObjectId.objectId,
            });

        if (context.mounted) {
          if (currentRoute?.currentPath == routingRoutePath) {
            context.pop();
          }
          PoiMapRoute.open(
            ref.read(goRouterProvider),
            event.dgisObjectId.objectId,
            latLng: event.latLng,
          );
        }
      } else if (event is RoadEventTapEvent) {
        Metrics.logEventAdvanced(
          MetricsConstants.poiKeys.roadEvent,
          group: MetricsConstants.poiTag,
          action: MetricAction.tap.toString(),
          props: {'event': event.id.objectId, 'title': event.title},
        );

        EventsRoute.open(context, event);
      } else if (event is MyLocationTapEvent) {
        if (context.mounted) {
          Metrics.logEventAdvanced(
            MetricsConstants.poiKeys.myLocation,
            group: MetricsConstants.poiTag,
            action: MetricAction.tap.toString(),
          );

          final userLocation = ref.read(locationProvider);
          PoiMapRoute.open(
            ref.read(goRouterProvider),
            -1,
            latLng: userLocation != null
                ? LatLng(latitude: userLocation.latitude, longitude: userLocation.longitude)
                : event.latLng,
            zoom: 17,
            bearing: 0,
            tilt: 0,
          );
        }
      }
    }
  }

  void _hideDashboard(TapEvent event) {
    _draggableScrollableController.animateTo(
      0.09,
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
    );

    ref.read(mapControlsProvider.notifier).update(MapControlsStateIdle());
  }
}
