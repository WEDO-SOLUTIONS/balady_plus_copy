import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/public_transport_visibility.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/features/share_eta/entities/route_params_point_mapper.dart';
import 'package:mapness/features/share_eta/entities/route_type_mapper.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart' as eta;
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/providers/eta_route_info_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/routing/ui/routes_carousel.dart' as widgets;
import 'package:mapness/widgets/routing/ui_kit/path_card/tools/path_card_size.dart';

class RoutesCarousel extends StatelessWidget {
  const RoutesCarousel({
    required this.startNavigation,
    required this.points,
    required this.navType,
    required this.publicTransportVisibility,
    required this.routes,
    this.onRouteIndexChanged,
    super.key,
  });

  final RouteSearchOptionsMessage navType;

  final List<RouteParamsPointWithLabel?> points;
  final Function(RouteInfo) startNavigation;
  final AsyncValue<PublicTransportVisibilityResult> publicTransportVisibility;
  final AsyncValue<List<RouteInfo>> routes;
  final ValueChanged<int>? onRouteIndexChanged;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => _RoutesCarousel(
      points: points,
      startNavigation: startNavigation,
      biggestWidth: constraints.biggest.width,
      navType: navType,
      publicTransportVisibility: publicTransportVisibility,
      routes: routes,
      onRouteIndexChanged: onRouteIndexChanged,
    ),
  );
}

class _RoutesCarousel extends ConsumerStatefulWidget {
  const _RoutesCarousel({
    required this.navType,
    required this.points,
    required this.startNavigation,
    required this.biggestWidth,
    required this.publicTransportVisibility,
    required this.routes,
    required this.onRouteIndexChanged,
  });

  final RouteSearchOptionsMessage navType;
  final double biggestWidth;
  final Function(RouteInfo) startNavigation;
  final List<RouteParamsPointWithLabel?> points;
  final AsyncValue<PublicTransportVisibilityResult> publicTransportVisibility;
  final AsyncValue<List<RouteInfo>> routes;
  final ValueChanged<int>? onRouteIndexChanged;

  @override
  ConsumerState<_RoutesCarousel> createState() => _RoutesCarouselState();
}

class _RoutesCarouselState extends ConsumerState<_RoutesCarousel> {
  late PageController _pageController;
  int _activeRoute = 0;
  StreamSubscription<ActiveRouteChangedEvent>? _activeRouteSubscription;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.navType.cardWidthWithPadding / widget.biggestWidth);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onRouteIndexChanged?.call(_activeRoute);
    });
    _activeRouteSubscription = ref
        .read(dgisControllerProvider)
        .value
        ?.activeRouteChangedEvents
        .listen(_onActiveRouteSelectedOnMap);
  }

  void _onActiveRouteSelectedOnMap(ActiveRouteChangedEvent event) {
    final activeRouteIndex = event.index;
    if (_activeRoute != activeRouteIndex) {
      _activeRoute = activeRouteIndex;
      widget.onRouteIndexChanged?.call(activeRouteIndex);
      _pageController.animateToPage(activeRouteIndex, duration: Durations.medium1, curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    _activeRouteSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widgets.RoutesCarousel(
    navType: widget.navType,
    pageController: _pageController,
    routes: widget.routes,
    onActiveChanged: _onActiveChanged,
    refresh: _refresh,
    points: widget.points,
    startNavigation: _startNavigation,
    publicTransportVisibility: widget.publicTransportVisibility,
  );

  void _onActiveChanged(int index) {
    _activeRoute = index;
    widget.onRouteIndexChanged?.call(index);

    ref.read(dgisControllerProvider).value?.setActiveRouteIndex(index);
    ref.read(dgisControllerProvider).value?.setPublicTransportActiveRoute(index);
  }

  void _refresh() {
    ref
      ..invalidate(routesProvider)
      ..invalidate(publicTransportRoutesProvider)
      ..invalidate(publicTransportVisibilityProvider);
  }

  void _startNavigation(RouteInfo info) {
    final _routeType = widget.navType.toRouteType();

    final startPoint = widget.points.first;
    final finishPoint = widget.points.last;

    final location = ref.read(locationProvider);
    if (location == null && startPoint?.etaPoint == null) {
      return;
    }

    final finishLocation =
        finishPoint?.value ?? RouteParamsPoint(latitude: location!.latitude, longitude: location.longitude);

    // Set finish point for ETA stream
    EtaStreamStorage()
      ..setLatitude(finishLocation.latitude)
      ..setLongitude(finishLocation.longitude);

    final startPointExists = startPoint?.etaPoint.lat != null && startPoint?.etaPoint.lon != null;
    final startPointEta = startPointExists
        ? startPoint!.etaPoint
        : EtaRoutePoint(lat: location?.latitude, lon: location?.longitude, label: startPoint?.label);
    final finishPointExists = finishPoint?.etaPoint.lat != null && finishPoint?.etaPoint.lon != null;
    final finishPointEta = finishPointExists
        ? finishPoint!.etaPoint
        : EtaRoutePoint(lat: finishLocation.latitude, lon: finishLocation.longitude, label: finishPoint?.label);

    ref
        .read(etaRouteInfoProvider.notifier)
        .setRoute(
          eta.EtaRoute(
            startPoint: startPointEta,
            endPoint: finishPointEta,
            type: _routeType,
            routeIndex: _activeRoute,
            createdAt: DateTime.now().toUtc().toIso8601String(),
          ),
        );
    widget.startNavigation(info);
  }
}
