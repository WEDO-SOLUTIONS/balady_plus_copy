import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
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
import 'package:mapness/features/path_nav/providers/active_public_transport_route.dart';
import 'package:mapness/features/routing/lib/active_navigation_helper.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/features/routing/providers/public_transport_visibility.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/routing/providers/routes_update_tab.dart';
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

const _defaultNavType = RouteSearchOptionsMessage.car;

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
  final ValueNotifier<RouteSearchOptionsMessage> _navType = ValueNotifier(_defaultNavType);
  final ValueNotifier<bool> _isNavTypeLoading = ValueNotifier(true);

  bool _navigationStarted = false;
  RouteSearchOptionsMessage? _lockedNavType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    final navState = await ActiveNavigationHelper.getState(
      ref.read(dgisControllerProvider).value,
    );

    if (navState.isActive) {
      _lockedNavType = navState.navType;
      _navType.value = navState.navType!;
      _isNavTypeLoading.value = false;
      setCameraPadding();
      hideActiveLayer();
      return;
    }

    await _initializeNavType();
    setCameraPadding();
    hideActiveLayer();
  }

  Future<void> _initializeNavType() async {
    if (widget.points.firstOrNull != null && widget.points.lastOrNull != null) {
      unawaited(_calculateNavigationType(null));
      return;
    }

    Position? location = ref.read(locationProvider);
    if (location == null) {
      final isGranted = await Permission.location.isGranted;
      if (!isGranted) {
        context.router.pop();
        return;
      }
      location = await Geolocator.getCurrentPosition();
    }
    unawaited(_calculateNavigationType(location));
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
  void didUpdateWidget(covariant RoutingInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if points have changed we need to recalculate nav type
    if (!const DeepCollectionEquality().equals(oldWidget.points, widget.points)) {
      _initializeNavType();
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
    var navType = _defaultNavType;
    final dgisController = ref.read(dgisControllerProvider).value;
    final carConnected = await ref.read(carConnectionProvider.future);

    final pointCount = widget.points.length;
    if (pointCount < 2) {
      _isNavTypeLoading.value = false;
      _navType.value = navType;
      return;
    }

    // As far as I can assume, null point value in list means user location point.
    // If so we take the last point if the first one is location and
    // we take the first point if the last one is location
    // or skip further calculation otherwise
    final RouteParamsPoint? finishPoint;
    if (widget.points.first == null) {
      finishPoint = widget.points.last;
    } else if (widget.points.last == null) {
      finishPoint = widget.points.first;
    } else {
      finishPoint = null;
    }

    if (location == null || dgisController == null || finishPoint == null) {
      _isNavTypeLoading.value = false;
      _navType.value = navType;
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
        _navType.value = navType;
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
      final dgisObjectId = finishPoint.dgisObjectId;
      if (distance < 0.5 && time.floor() <= 5) {
        navType = RouteSearchOptionsMessage.pedestrian;
      }
      // if distance is less than 0.7 km and time <= 7 min then use pedestrian just for in building navigation
      else if (dgisObjectId != null && distance < 0.7 && time.floor() <= 7) {
        // Check if finish point is in building, if we have building name then it's in building)
        final objectInfo = await dgisController.searchByObjectId(dgisObjectId);
        if (objectInfo.buildingInfo.buildingName != null) {
          navType = RouteSearchOptionsMessage.pedestrian;
        }
      }
    }

    _navType.value = navType;
    _isNavTypeLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..watch(activePublicTransportRouteProvider)
      ..listen(carConnectionProvider, (_, next) {
        final connected = next.value ?? false;
        if (connected) {
          _navType.value = RouteSearchOptionsMessage.car;
        }
      })
      ..listen<RouteSearchOptionsMessage>(
        routesUpdateTabProvider,
        (previous, next) {
          if (previous != next) {
            _navType.value = next;
            ref
              ..invalidate(routesProvider)
              ..invalidate(publicTransportRoutesProvider)
              ..invalidate(publicTransportVisibilityProvider);
          }
        },
      );

    return ValueListenableBuilder(
      valueListenable: _isNavTypeLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: Loading(size: LoaderSize.large));
        }

        return ValueListenableBuilder(
          valueListenable: _navType,
          builder: (context, navigatingType, _) {
            final intermediatePoints = widget.points.getIntermediatePoints();

            final routes = ref.watch(
              routesProvider(
                startPoint: widget.points.first,
                finishPoint: widget.points.last,
                navType: navigatingType,
                intermediatePoints: intermediatePoints,
              ),
            );

            final publicTransportVisibility = ref.watch(
              publicTransportVisibilityProvider(
                startPoint: widget.points[0],
                finishPoint: widget.points[1],
              ),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacing.$4x.heightBox,
                RoutesCarousel(
                  points: widget.pointsWithLabel,
                  startNavigation: (route) => _startNavigation(route, navigatingType),
                  navType: navigatingType,
                  publicTransportVisibility: publicTransportVisibility,
                  routes: routes,
                ),
                Spacing.$4x.heightBox,
                RouteTabBar(
                  active: navigatingType,
                  onChanged: _onChanged,
                  points: widget.points,
                  publicTransportVisibility: publicTransportVisibility,
                  routes: routes,
                  lockedNavType: _lockedNavType,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _startNavigation(RouteInfo route, RouteSearchOptionsMessage navigatingType) async {
    _navigationStarted = true;
    if (!ref.context.mounted) {
      return;
    }

    // Stop current navigation if it's active before starting a new one
    // This prevents route duplication on the map
    if (_lockedNavType != null) {
      await ref.read(dgisControllerProvider).value?.stopNavigation();
    }

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

    await ref.read(currentRouteProvider.notifier).setNavigationState(
          CurrentRouteState(
            points: widget.pointsWithLabel,
            navType: navigatingType,
            route: route,
          ),
        );
    ref.read(currentNavigationDestinationProvider.notifier).state = widget.pointsWithLabel.lastOrNull?.value;

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

    ref.read(routesUpdateTabProvider.notifier).update = routeSearch;
    _navType.value = routeSearch;
  }
}
