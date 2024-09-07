import 'dart:async';
import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/landing/dashboard.dart';
import 'package:mapness/_features/landing/landing_state_mapper.dart';
import 'package:mapness/_features/landing/map_dashboard_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/events.dart';
import 'package:mapness/app/routes/kiblah.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/router_extension.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> with WidgetsBindingObserver {
  late StatefulBottomSheetController<ThreeStateBottomSheet> _scrollController;
  MediaQueryData? _mediaQuery;
  StreamSubscription<TapEvent>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mediaQuery = ref.read(mediaQueryInfoProvider);
    });

    _scrollController = StatefulBottomSheetController(
      durationMultiplier: 1.0,
      initialState: ThreeStateBottomSheet.open,
      behavior: AspectRatioSnappingBehavior(aspectRatios: [0, if (Platform.isIOS) .3 else .38, .931]),
      stateMapper: const LandingStateMapper(),
    );
    _scrollController.addListener(_calculatePadding);

    setupTapListener();
  }

  Future<void> setupTapListener() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _streamSubscription = dgisController.objectTapEvents.listen(_objectTapListener);

    _calculatePadding();
  }

  void _calculatePadding() {
    ref.watch(cameraPaddingProvider.notifier).resetPadding(
          defaultPadding: CameraSetPaddingMessage(
            leftPadding: _mediaQuery?.padding.left.toInt() ?? 0,
            rightPadding: _mediaQuery?.padding.right.toInt() ?? 0,
            topPadding: _mediaQuery?.padding.top.toInt() ?? 0,
            bottomPadding: _scrollController.sheetHeight.toInt(),
          ),
        );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_calculatePadding);

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(locationProvider.notifier).checkLocationPermission();
    }

    super.didChangeAppLifecycleState(state);
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
      ..watch(websocketTypeProvider)
      ..watch(etaTimerIndicatorProvider)
      ..watch(shareEtaProvider)
      ..watch(etaGeoSubscriberProvider)
      ..watch(etaServiceProvider)
      ..watch(currentRouteProvider.select((value) => null))
      ..watch(layersControlsProvider)
      ..watch(locationProvider.select((_) => null))
      ..watch(favouriteMarkersProvider.select((value) => null))
      ..listen(currentRouteProvider, (_, next) {
        if (next?.currentPath == KiblahRoute.path) {
          _scrollController.setState(ThreeStateBottomSheet.hidden);
        }
      })

      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier);

    return PopScope(
      onPopInvoked: (_LandingPageState) {

      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                ListenableBuilder(
                  listenable: _scrollController,
                  builder: (_, __) {
                    if (_scrollController.state == ThreeStateBottomSheet.hidden) {
                      return const SizedBox.shrink();
                    }

                    return GestureDetector(
                      onTapDown: (_) {
                        if (_scrollController.state != ThreeStateBottomSheet.hidden) {
                          _scrollController.setState(ThreeStateBottomSheet.hidden);
                        }
                      },
                      onTapUp: (_) {
                        if (_scrollController.state != ThreeStateBottomSheet.hidden) {
                          _scrollController.setState(ThreeStateBottomSheet.hidden);
                        }
                      },
                      onTap: () {
                        if (_scrollController.state != ThreeStateBottomSheet.hidden) {
                          _scrollController.setState(ThreeStateBottomSheet.hidden);
                        }
                      },
                    );
                  },
                ),
                MapDashboardControls(_scrollController, key: const ValueKey('MapDashboardControls')),
                Dashboard(scrollableController: _scrollController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _objectTapListener(TapEvent event) {
    final currentRoute = ref.watch(currentRouteProvider);

    const routingRoutePath = RoutingRoutesRoute.path;

    ///TODO: need to refactor after Dashboard refactoring to designSystem
    final goRouter = ref.read(goRouterProvider);

    if (goRouter.isCurrentRoute(RoutingMapRoute.path)) {
      return;
    } else if (goRouter.isCurrentRoute(RoutingRoutesRoute.path)) {
      return;
    } else if (goRouter.isCurrentRoute(SearchRoute.path)) {
      return;
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
