import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/city_by_location/city_by_location.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/features/routing/providers/public_transport_visibility.dart';
import 'package:mapness/features/routing/ui/routes_carousel.dart';
import 'package:mapness/pages/path_nav/path_nav_page.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/pages/routing/ui/routing_tab_bar.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/double_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/car_connection.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:permission_handler/permission_handler.dart';

class RoutingInfo extends ConsumerStatefulWidget {
  final List<RouteParamsPointWithLabel> pointsWithLabel;
  final List<RouteParamsPoint?> points;
  final bool isHomeOrWork;

  RoutingInfo({
    required this.pointsWithLabel,
    this.isHomeOrWork = false,
    super.key,
  }) : points = pointsWithLabel.map((e) => e.value).toList();

  @override
  ConsumerState<RoutingInfo> createState() => _RoutingInfoState();
}

class _RoutingInfoState extends ConsumerState<RoutingInfo> {
  final ValueNotifier<RouteSearchOptionsMessage> _navType = ValueNotifier(RouteSearchOptionsMessage.car);

  final ValueNotifier<bool> _isNavTypeLoading = ValueNotifier(true);
  bool _navigationStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.points.firstOrNull != null && widget.points.lastOrNull != null) {
        unawaited(_calculateNavigationType(null));
      } else {
        Position? location = ref.read(locationProvider);
        if (location == null) {
          // TODO(Ayat) rewriting to human form is a temporary fix
          final isGranded = await Permission.location.isGranted;

          if (!isGranded) {
            context.router.popForced();
            return;
          }
          // Due to the addition of checks on Huawei, it was not possible to get the provider's
          // location during the first installation, I made this method so as not to catch a crash
          location = await Geolocator.getCurrentPosition();
        }
        unawaited(_calculateNavigationType(location));
      }
      setCameraPadding();
      hideActiveLayer();
    });
  }

  void setCameraPadding() {
    final mediaQuery = ref.read(mediaQueryInfoProvider);
    final devicePixelRatio = mediaQuery?.devicePixelRatio ?? 0;
    final size = mediaQuery?.size;
    final height = size?.height ?? 0;
    final width = size?.width ?? 0;
    final physicalPixelsHeight = height * devicePixelRatio;
    final physicalPixelsWidth = width * devicePixelRatio;

    ref.read(cameraPositionProvider.notifier).setPadding(
          CameraSetPaddingMessage(
            leftPadding: (physicalPixelsWidth / 8).ceil(),
            topPadding: (physicalPixelsHeight / 5).ceil(),
            rightPadding: (physicalPixelsWidth / 5).ceil(),
            bottomPadding: (physicalPixelsHeight / 3).ceil(),
          ),
        );
  }

  void hideActiveLayer() {
    ref.read(layersControlsProvider.notifier).hideLayer(LayerType.metro);
  }

  void restoreActiveLayer() {
    // If navigation started, we don't need to restore the active layer and keep it hidden
    // Else if we go back from this screen, we need to restore the active layer
    if (!_navigationStarted) {
      ref.read(layersControlsProvider.notifier).restorePreviousLayer();
    }
  }

  @override
  void deactivate() {
    restoreActiveLayer();
    super.deactivate();
  }

  @override
  void dispose() {
    _navType.dispose();
    super.dispose();
  }

  Future<void> _calculateNavigationType(Position? location) async {
    final dgisController = ref.read(dgisControllerProvider).valueOrNull;
    final carConnected = await ref.read(carConnectionProvider.future);

    //TODO(scroollocker): !IMPORTANT! Change this logic when we have more than 2 points
    int finishPointIndex = 1;
    if (widget.points.length < 2 && widget.points[1] != null) {
      _isNavTypeLoading.value = false;
      return;
    }

    if (widget.points.length == 2 && widget.points[1] == null) {
      finishPointIndex = 0;
    }

    if (widget.points[finishPointIndex] == null) {
      _isNavTypeLoading.value = false;
      return;
    }

    final finishPoint = widget.points[finishPointIndex]!;
    final dgisObjectId = finishPoint.dgisObjectId;

    if (location == null || dgisController == null || dgisObjectId == null) {
      _isNavTypeLoading.value = false;
      return;
    }

    double distance = 0;
    double time = 0;

    try {
      final briefInfo = await dgisController.findBriefRouteInfos(
        options: RouteSearchOptionsMessage.pedestrian,
        finishPoint: finishPoint.routeSearchPointMessage,
      );

      if (briefInfo.isEmpty) {
        _isNavTypeLoading.value = false;
        return;
      }

      distance = briefInfo.first!.extraInfo.distance.toDouble().toKilometers();
      time = briefInfo.first!.duration.toMinutes();
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      distance = CommonFunctions.distance(
        location.latitude,
        location.longitude,
        finishPoint.geoPoint.latitude,
        finishPoint.geoPoint.longitude,
      );
    }

    if (!carConnected) {
      // if distance is less than 0.5 km and time <= 5 min then use pedestrian
      if (distance < 0.5 && time.floor() <= 5) {
        _navType.value = RouteSearchOptionsMessage.pedestrian;
      }
      // if distance is less than 0.7 km and time <= 7 min then use pedestrian just for in building navigation
      else if (distance < 0.7 && time.floor() <= 7) {
        // Check if finish point is in building, if we have building name then it's in building)
        final objectInfo = await dgisController.searchByObjectId(dgisObjectId);
        if (objectInfo.buildingInfo.buildingName != null) {
          _navType.value = RouteSearchOptionsMessage.pedestrian;
        }
      }
    }

    _isNavTypeLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final publicTransportVisibility = ref.watch(publicTransportVisibilityProvider(
      startPoint: widget.points[0],
      finishPoint: widget.points[1],
    ));
    ref.listen(carConnectionProvider, (_, next) {
      final connected = next.valueOrNull ?? false;
      if (connected) {
        _navType.value = RouteSearchOptionsMessage.car;
      }
    });
    return ValueListenableBuilder(
      valueListenable: _isNavTypeLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
            child: Loading.large(),
          ));
        }
        return ValueListenableBuilder(
          valueListenable: _navType,
          builder: (context, navigatingType, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacing.$4x.heightBox,
              RoutesCarousel(
                points: widget.pointsWithLabel,
                startNavigation: (route) => _startNavigation(route, navigatingType),
                navType: navigatingType,
                publicTransportVisibility: publicTransportVisibility,
              ),
              Spacing.$4x.heightBox,
              RouteTabBar(
                active: navigatingType,
                onChanged: _onChanged,
                points: widget.points,
                publicTransportVisibility: publicTransportVisibility,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _startNavigation(RouteInfo route, RouteSearchOptionsMessage navigatingType) async {
    _navigationStarted = true;
    final mapSetting = MapObjectManagerSettings.search();
    final markerSettings = MapObjectManagerSettings.selectedMarker();
    final location = ref.read(cityByLocationProvider.notifier);
    final originCity = await location.getCityByLatLng(
      lat: widget.pointsWithLabel.first.value?.latitude,
      lng: widget.pointsWithLabel.first.value?.longitude,
    );
    final destinationCity = await location.getCityByLatLng(
      lat: widget.pointsWithLabel.lastOrNull?.value?.latitude,
      lng: widget.pointsWithLabel.lastOrNull?.value?.longitude,
    );

    for (final settings in [mapSetting, markerSettings]) {
      await ref
          .read(
            mapObjectManagerProvider(
              named: settings.name,
              layerId: settings.layerId,
            ).notifier,
          )
          .removeAllMarkers();
    }

    ref.read(appAnalyticsProvider).transportModeSelected(type: navigatingType.name);

    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.routeSelectionGoButton,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );

    // log advert analytics event
    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.navigationRoutingStartedJorney);
    ref.read(advertMetricsProvider.notifier).sendEvent(
          AdvertMetricsKeys.journeyStartedUnique,
          isUniquePerSession: true,
        );

    ref.read(appAnalyticsProvider).navigationStarted(
          originLocation: widget.pointsWithLabel.length > 1 ? widget.pointsWithLabel.first.label : '',
          destinationLocation: widget.pointsWithLabel.lastOrNull?.label ?? '',
          originCity: originCity.name,
          destinationCity: destinationCity.name,
          estimateTime: route.duration,
          estimateDistance: route.distance,
        );

    unawaited(ref.read(urbiAnalyticsProvider).track(
      'startNavigation',
      properties: {
        'duration': route.duration,
        'distance': route.distance,
      },
    ));

    await context.router.pushAndPopUntil(
        PathNavRoute(
          navType: navigatingType,
          isHomeOrWork: widget.isHomeOrWork,
          initAction: PathNavPageInitAction.startNavigation,
        ),
        predicate: (route) => route.settings.name == BottomMenuRoute.name);
  }

  void _onChanged(RouteSearchOptionsMessage routeSearch) {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.routeSelectionChangeNavType,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
      props: {
        'navType': routeSearch.name,
        'points':
            '[${widget.points.map((e) => 'objectId: ${e?.objectId} coords: ${e?.latitude}, ${e?.longitude}').join(', ')}]',
      },
    );

    _navType.value = routeSearch;
  }
}
