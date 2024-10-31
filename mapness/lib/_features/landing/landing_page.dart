import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/landing/dashboard.dart';
import 'package:mapness/_features/landing/landing_state_mapper.dart';
import 'package:mapness/_features/landing/map_dashboard_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/city_contains/service_not_available.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/media_query.dart';

@RoutePage()
class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> with WidgetsBindingObserver {
  late final StatefulBottomSheetController<ThreeStateBottomSheet> _bottomSheetController =
      StatefulBottomSheetController(
    initialState: ThreeStateBottomSheet.open,
    behavior: AspectRatioSnappingBehavior(aspectRatios: [0, if (Platform.isIOS) .3 else .38, .931]),
    stateMapper: const LandingStateMapper(),
  );

  MediaQueryData? _mediaQuery;
  StreamSubscription<TapEvent>? _streamSubscription;
  Completer<void>? _checkPermissionCompleter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mediaQuery = ref.read(mediaQueryInfoProvider);
    });

    _bottomSheetController.addListener(_calculatePadding);

    _setupTapListener();
  }

  Future<void> _setupTapListener() async {
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
            bottomPadding: _bottomSheetController.sheetHeight.toInt(),
          ),
        );
  }

  @override
  void dispose() {
    _bottomSheetController.removeListener(_calculatePadding);

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      /// TODO('Ayat') This logic is necessary so that there is no cyclic call that occurs due to the
      /// operation of the android life cycle with permissions https://github.com/Baseflow/flutter-permission-handler/issues/1301
      /// I will ask you to make an implementation like in 2GIS
      if (_checkPermissionCompleter == null) {
        final completer = Completer<void>();
        _checkPermissionCompleter = completer;
        ref.read(locationProvider.notifier).checkLocationPermission().then((_) {
          completer.complete();
        }).catchError((Object e, StackTrace s) {
          completer.completeError(e, s);
        }).whenComplete(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          _checkPermissionCompleter = null;
        });
      }

      ref.read(freeRoamStarterProvider.notifier).reset();
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
      ..watch(layersControlsProvider)
      ..watch(favouriteMarkersProvider.select((value) => null))
      ..listen(serviceNotAvailableProvider, (prev, isAvailible) {
        final isPrevIsAvailible = prev?.valueOrNull ?? true;
        final isAvailibleValue = isAvailible.valueOrNull;

        // Show only if service is not available
        if (isPrevIsAvailible == true && isAvailibleValue == false) {
          context.router.push(const ServiceNotAvailableSheetRoute());
        }
      })

      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              ListenableBuilder(
                listenable: _bottomSheetController,
                builder: (_, __) {
                  if (_bottomSheetController.state == ThreeStateBottomSheet.hidden) {
                    return const SizedBox.shrink();
                  }

                  return GestureDetector(
                    onTapDown: (_) {
                      if (_bottomSheetController.state != ThreeStateBottomSheet.hidden) {
                        _bottomSheetController.setState(ThreeStateBottomSheet.hidden);
                      }
                    },
                    onTapUp: (_) {
                      if (_bottomSheetController.state != ThreeStateBottomSheet.hidden) {
                        _bottomSheetController.setState(ThreeStateBottomSheet.hidden);
                      }
                    },
                    onTap: () {
                      if (_bottomSheetController.state != ThreeStateBottomSheet.hidden) {
                        _bottomSheetController.setState(ThreeStateBottomSheet.hidden);
                      }
                    },
                  );
                },
              ),
              MapDashboardControls(_bottomSheetController, key: const ValueKey('MapDashboardControls')),
              Dashboard(bottomSheetController: _bottomSheetController),
            ],
          ),
        ),
      ),
    );
  }

  void _objectTapListener(TapEvent event) {
    if (context.router.isPathActive(RoutingMapSelectRoute.name)) {
      return;
    } else if (context.router.isPathActive(RoutingRoutesRoute.name)) {
      return;
    } else if (context.router.isPathActive(SearchRoute.name)) {
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
        context.router.push(
          PoiCardWidgetRoute(
            objectId: DgisObjectIdMessage(
              objectId: event.dgisObjectId.objectId,
              entranceId: 0,
            ),
            closestPoint: event.latLng,
          ),
        );
      }
    } else if (event is RoadEventTapEvent) {
      Metrics.logEventAdvanced(
        MetricsConstants.poiKeys.roadEvent,
        group: MetricsConstants.poiTag,
        action: MetricAction.tap.toString(),
        props: {'event': event.id.objectId, 'title': event.title},
      );

      context.router.push(RoadClosureRoute(
        id: event.id,
        title: event.title,
        description: event.description,
        startTime: event.startTime,
        finishTime: event.finishTime,
        latitude: event.latLng.latitude,
        longitude: event.latLng.longitude,
      ));
    } else if (event is MyLocationTapEvent) {
      if (context.mounted) {
        Metrics.logEventAdvanced(
          MetricsConstants.poiKeys.myLocation,
          group: MetricsConstants.poiTag,
          action: MetricAction.tap.toString(),
        );

        final userLocation = ref.read(locationProvider);
        context.router.push(
          ShareMyLocationRoute(
            cameraConfig: PoiCameraConfig(zoom: 17, bearing: 0, tilt: 0),
            closestPoint: userLocation != null
                ? LatLng(latitude: userLocation.latitude, longitude: userLocation.longitude)
                : event.latLng,
          ),
        );
      }
    }
  }
}
