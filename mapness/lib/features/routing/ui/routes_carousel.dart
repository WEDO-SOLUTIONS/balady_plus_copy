import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/routing/ui/routes_carousel.dart' as widgets;

class RoutesCarousel extends StatelessWidget {
  final RouteSearchOptionsMessage navType;

  const RoutesCarousel({
    super.key,
    required this.startNavigation,
    required this.points,
    required this.navType,
  });

  final List<RouteParamsPoint?> points;
  final Function() startNavigation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _RoutesCarousel(
        points: points,
        startNavigation: startNavigation,
        biggestWidth: constraints.biggest.width,
        navType: navType,
      ),
    );
  }
}

class _RoutesCarousel extends ConsumerStatefulWidget {
  final RouteSearchOptionsMessage navType;
  final double biggestWidth;
  final Function() startNavigation;
  final List<RouteParamsPoint?> points;

  const _RoutesCarousel({
    required this.navType,
    required this.points,
    required this.startNavigation,
    required this.biggestWidth,
  });

  @override
  ConsumerState<_RoutesCarousel> createState() => _RoutesCarouselState();
}

class _RoutesCarouselState extends ConsumerState<_RoutesCarousel> {
  late PageController _pageController;
  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: (widget.biggestWidth - 64) / widget.biggestWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final routes = ref.watch(
      routesProvider(
        startPoint: widget.points[0],
        finishPoint: widget.points[1],
        navType: widget.navType,
      ),
    );
    ref.listen(
      activeRouteProvider,
      (prev, next) {
        setState(() {
          _animating = true;
        });
        _pageController
            .animateToPage(
          next,
          duration: const Duration(milliseconds: 250),
          curve: Curves.linear,
        )
            .then(
          (value) {
            _animating = false;
          },
        );
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) => widgets.RoutesCarousel(
        pageController: _pageController,
        routes: routes,
        onActiveChanged: (index) {
          if (_animating) return;

          ref
              .read(dgisControllerProvider)
              ?.setPublicTransportActiveRoute(index);
        },
        startNavigation: widget.startNavigation,
      ),
    );
  }
}
