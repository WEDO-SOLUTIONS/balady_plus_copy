import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/city_by_location/city_by_location.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
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
import 'package:mapness/shared/extensions/double_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
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
  final ValueChanged<RouteSearchOptionsMessage>? onNavTypeChanged;
  final ValueChanged<int>? onRouteIndexChanged;
  final RouteSearchOptionsMessage? navType;

  RoutingInfo({
    required this.pointsWithLabel,
    this.isHomeOrWork = false,
    this.onNavTypeChanged,
    this.onRouteIndexChanged,
    this.navType,
    super.key,
  }) : points = pointsWithLabel.map((e) => e.value).toList();

  @override
  ConsumerState<RoutingInfo> createState() => _RoutingInfoState();
}

class _RoutingInfoState extends ConsumerState<RoutingInfo> {
  late final ValueNotifier<RouteSearchOptionsMessage> _navType = ValueNotifier(_initialNavType);
  final ValueNotifier<bool> _isNavTypeLoading = ValueNotifier(true);

  bool _navigationStarted = false;
  RouteSearchOptionsMessage? _lockedNavType;

  RouteSearchOptionsMessage get _initialNavType => widget.navType ?? _defaultNavType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
      _updateIntermediateStopMarkers();
    });
  }

  Future<void> _initialize() async {
    _navType.addListener(_onNavTypeChanged);
    final navState = await ActiveNavigationHelper.getState(ref.read(dgisControllerProvider).value);

    if (navState.isActive) {
      _lockedNavType = navState.navType;
      _navType.value = navState.navType!;
      widget.onNavTypeChanged?.call(_navType.value);
      _isNavTypeLoading.value = false;
      setCameraPadding();
      hideActiveLayer();
      return;
    }

    widget.onNavTypeChanged?.call(_navType.value);
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

    ref
        .read(cameraPositionProvider.notifier)
        .setPadding(
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
      _updateIntermediateStopMarkers();
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
    var navType = _initialNavType;
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

  static final _intermediateStopIcons = [
    null, // index 0 is not used
    Assets.icons.svg.intermediateStopNumbers.a01,
    Assets.icons.svg.intermediateStopNumbers.a02,
    Assets.icons.svg.intermediateStopNumbers.a03,
    Assets.icons.svg.intermediateStopNumbers.a04,
    Assets.icons.svg.intermediateStopNumbers.a05,
    Assets.icons.svg.intermediateStopNumbers.a06,
    Assets.icons.svg.intermediateStopNumbers.a07,
    Assets.icons.svg.intermediateStopNumbers.a08,
    Assets.icons.svg.intermediateStopNumbers.a09,
    Assets.icons.svg.intermediateStopNumbers.a10,
  ];

  void _onNavTypeChanged() => widget.onNavTypeChanged?.call(_navType.value);

  Future<void> _updateIntermediateStopMarkers() async {
    final settings = MapObjectManagerSettings.intermediateStops();
    final manager = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
        generalization: settings.generalization,
      ).notifier,
    );

    await manager.removeAllMarkers();

    // Get intermediate points (all except first and last)
    if (widget.pointsWithLabel.length <= 2) {
      return;
    }

    final intermediatePoints = widget.pointsWithLabel.sublist(1, widget.pointsWithLabel.length - 1);
    if (intermediatePoints.isEmpty) {
      return;
    }

    final markers = <Marker>[];

    for (var i = 0; i < intermediatePoints.length; i++) {
      final point = intermediatePoints[i].value;
      if (point == null) {
        continue;
      }

      final stopIndex = i + 1;
      if (stopIndex >= _intermediateStopIcons.length) {
        continue;
      }

      final svgAsset = _intermediateStopIcons[stopIndex];
      if (svgAsset == null) {
        continue;
      }

      markers.add(
        Marker(
          id: 'intermediate_stop_$stopIndex',
          onTap: point.objectId != null ? () => _onIntermediateStopTap(point) : null,
          options: MarkerOptionsMessage(
            position: GeoPointWithElevationMessage(latitude: point.latitude, longitude: point.longitude, elevation: 0),
            icon: svgAsset.keyName.markerIcon(),
            animatedAppearance: true,
            zIndex: 50,
          ),
        ),
      );
    }

    if (markers.isNotEmpty) {
      await manager.addMarkers(markers);
    }
  }

  void _onIntermediateStopTap(RouteParamsPoint point) {
    if (point.objectId == null) {
      return;
    }

    ref
        .read(appRouterProvider)
        .replaceOrPush(
          route: PoiCardWidgetRoute(
            objectId: DgisObjectIdMessage(objectId: point.objectId!, entranceId: point.entranceId ?? 0),
            closestPoint: LatLng(latitude: point.latitude, longitude: point.longitude),
          ),
          toCompareRoutes: [ShareMyLocationRoute.page, PoiCardWidgetRoute.page, HajjPoiCardRoute.page],
        );
  }

  @override
  Widget build(BuildContext context) {
    // Keep intermediate stops marker manager alive
    final intermediateStopsSettings = MapObjectManagerSettings.intermediateStops();
    ref
      ..watch(
        mapObjectManagerProvider(
          named: intermediateStopsSettings.name,
          layerId: intermediateStopsSettings.layerId,
          generalization: intermediateStopsSettings.generalization,
        ).notifier,
      )
      ..watch(activePublicTransportRouteProvider)
      ..listen(carConnectionProvider, (_, next) {
        final connected = next.value ?? false;
        if (connected) {
          _navType.value = RouteSearchOptionsMessage.car;
        }
      })
      ..listen<RouteSearchOptionsMessage>(routesUpdateTabProvider, (previous, next) {
        if (previous != next) {
          _navType.value = next;
          ref
            ..invalidate(routesProvider)
            ..invalidate(publicTransportRoutesProvider)
            ..invalidate(publicTransportVisibilityProvider);
        }
      });

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
                showOnlyActiveRoute: false,
              ),
            );

            final publicTransportVisibility = ref.watch(
              publicTransportVisibilityProvider(
                startPoint: widget.points.first,
                finishPoint: widget.points.last,
                intermediatePoints: intermediatePoints,
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
                  onRouteIndexChanged: widget.onRouteIndexChanged,
                ),
                Spacing.$3x.heightBox,
                RouteTabBar(
                  active: navigatingType,
                  onChanged: _onChanged,
                  points: widget.points,
                  hasPublicTransport: publicTransportVisibility.value?.hasPublicTransportRoutes ?? false,
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
    if (_navigationStarted) {
      return;
    }
    _navigationStarted = true;
    if (!ref.context.mounted) {
      _navigationStarted = false;
      return;
    }

    try {
      // Stop current navigation if it's active before starting a new one
      // This prevents route duplication on the map
      if (_lockedNavType != null) {
        await ref.read(dgisControllerProvider).value?.stopNavigation();
      }

      await ref.read(dgisControllerProvider).value?.freeRoamController.stop();

      final mapSetting = MapObjectManagerSettings.search();
      final markerSettings = MapObjectManagerSettings.selectedMarker();
      final intermediateStopsSetting = MapObjectManagerSettings.intermediateStops();

      await Future.wait([
        for (final settings in [mapSetting, markerSettings, intermediateStopsSetting])
          ref
              .read(
                mapObjectManagerProvider(
                  named: settings.name,
                  layerId: settings.layerId,
                  generalization: settings.generalization,
                ).notifier,
              )
              .removeAllMarkers(),
      ]);

      ref.read(appAnalyticsProvider).transportModeSelected(type: navigatingType.name);

      // log advert analytics event
      ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.navigationRoutingStartedJorney);
      ref
          .read(advertMetricsProvider.notifier)
          .sendEvent(AdvertMetricsKeys.journeyStartedUnique, isUniquePerSession: true);

      unawaited(_sendNavigationStartedAnalytics(route, navigatingType));

      unawaited(
        ref
            .read(urbiAnalyticsProvider)
            .track('startNavigation', properties: {'duration': route.duration, 'distance': route.distance}),
      );

      await ref
          .read(currentRouteProvider.notifier)
          .setNavigationState(CurrentRouteState(points: widget.pointsWithLabel, navType: navigatingType, route: route));
      ref.read(currentNavigationDestinationProvider.notifier).state = widget.pointsWithLabel.lastOrNull?.value;

      await context.router.pushAndPopUntil(
        PathNavRoute(
          navType: navigatingType,
          isHomeOrWork: widget.isHomeOrWork,
          initAction: PathNavPageInitAction.startNavigation,
        ),
        predicate: (route) => route.settings.name == BottomMenuRoute.name,
      );
    } catch (_) {
      _navigationStarted = false;
      rethrow;
    }
  }

  /// Sends analytics with city names resolved via geocoding.
  /// Runs as fire-and-forget to avoid blocking navigation start.
  Future<void> _sendNavigationStartedAnalytics(RouteInfo route, RouteSearchOptionsMessage navigatingType) async {
    // Capture everything that depends on `ref` and `widget` BEFORE the async gap.
    // The widget can be disposed while geocoding runs in the background (navigation
    // pushes the map page and pops this screen). Reading `ref`/`widget` after the
    // await throws "Bad state: Using ref when a widget is unmounted", which silently
    // crashed this task and prevented the navigation_started event from reaching Insider.
    final analytics = ref.read(appAnalyticsProvider);
    final locationNotifier = ref.read(cityByLocationProvider.notifier);

    final originLabel = widget.pointsWithLabel.length > 1 ? widget.pointsWithLabel.first.label : '';
    final destinationLabel = widget.pointsWithLabel.lastOrNull?.label ?? '';

    final originLat = widget.pointsWithLabel.first.value?.latitude;
    final originLng = widget.pointsWithLabel.first.value?.longitude;
    final destinationLat = widget.pointsWithLabel.lastOrNull?.value?.latitude;
    final destinationLng = widget.pointsWithLabel.lastOrNull?.value?.longitude;

    try {
      final results = await Future.wait([
        locationNotifier.getCityByLatLng(lat: originLat, lng: originLng),
        locationNotifier.getCityByLatLng(lat: destinationLat, lng: destinationLng),
      ]);

      final originCity = results[0];
      final destinationCity = results[1];

      analytics.navigationStarted(
        originLocation: originLabel,
        destinationLocation: destinationLabel,
        originCity: originCity.name,
        destinationCity: destinationCity.name,
        estimateTime: route.duration,
        estimateDistance: route.distance,
      );
    } catch (_) {
      // Analytics failure should not affect navigation
    }
  }

  void _onChanged(RouteSearchOptionsMessage routeSearch) {
    ref.read(routesUpdateTabProvider.notifier).update = routeSearch;
    _navType.value = routeSearch;
  }
}
