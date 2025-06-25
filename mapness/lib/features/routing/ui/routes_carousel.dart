import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
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
    super.key,
  });

  final RouteSearchOptionsMessage navType;

  final List<RouteParamsPointWithLabel?> points;
  final Function(RouteInfo) startNavigation;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => _RoutesCarousel(
          points: points,
          startNavigation: startNavigation,
          biggestWidth: constraints.biggest.width,
          navType: navType,
        ),
      );
}

class _RoutesCarousel extends ConsumerStatefulWidget {
  const _RoutesCarousel({
    required this.navType,
    required this.points,
    required this.startNavigation,
    required this.biggestWidth,
  });

  final RouteSearchOptionsMessage navType;
  final double biggestWidth;
  final Function(RouteInfo) startNavigation;
  final List<RouteParamsPointWithLabel?> points;

  @override
  ConsumerState<_RoutesCarousel> createState() => _RoutesCarouselState();
}

class _RoutesCarouselState extends ConsumerState<_RoutesCarousel> {
  late PageController _pageController;
  final bool _animating = false;
  int _activeRoute = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: PathCardSize.fixedCardWidthWithPadding / widget.biggestWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routes = ref.watch(
      routesProvider(
        startPoint: widget.points[0]?.value,
        finishPoint: widget.points[1]?.value,
        navType: widget.navType,
      ),
    );

    final publicTransportRoutes = ref.watch(
      publicTransportRoutesProvider(
        startPoint: widget.points[0]?.value,
        finishPoint: widget.points[1]?.value,
        navType: widget.navType,
      ),
    );

    return widgets.RoutesCarousel(
        navType: widget.navType,
        pageController: _pageController,
        routes: routes,
        publicTransportRoutes: publicTransportRoutes,
        onActiveChanged: (index) {
          if (_animating) {
            return;
          }

          _activeRoute = index;

          ref.read(dgisControllerProvider).value?.setPublicTransportActiveRoute(index);
        },
        refresh: () {
          ref
            ..invalidate(routesProvider)
            ..invalidate(publicTransportRoutesProvider);
        },
        startNavigation: (info) {
          final _routeType = widget.navType.toRouteType();

          final location = ref.read(locationProvider);
          if (location == null && widget.points[0]?.etaPoint == null) {
            return;
          }

          final finishLocation =
              widget.points[1]?.value ?? RouteParamsPoint(latitude: location!.latitude, longitude: location.longitude);

          // Set finish point for ETA stream
          EtaStreamStorage()
            ..setLatitude(finishLocation.latitude)
            ..setLongitude(finishLocation.longitude);

          final startPointEta = (widget.points[0]?.etaPoint.lat != null && widget.points[0]?.etaPoint.lon != null)
              ? widget.points[0]!.etaPoint
              : EtaRoutePoint(
                  lat: location!.latitude,
                  lon: location.longitude,
                  label: widget.points[0]?.label,
                );

          final finishPointEta = (widget.points[1]?.etaPoint.lat != null && widget.points[1]?.etaPoint.lon != null)
              ? widget.points[1]!.etaPoint
              : EtaRoutePoint(
                  lat: finishLocation.latitude,
                  lon: finishLocation.longitude,
                  label: widget.points[1]?.label,
                );

          ref.read(etaRouteInfoProvider.notifier).setRoute(
                eta.EtaRoute(
                  startPoint: startPointEta,
                  endPoint: finishPointEta,
                  type: _routeType,
                  routeIndex: _activeRoute,
                  createdAt: DateTime.now().toUtc().toIso8601String(),
                ),
              );
          widget.startNavigation(info);
        });
  }
}
