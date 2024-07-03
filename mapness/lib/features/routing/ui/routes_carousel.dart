import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
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

  final List<RouteParamsPoint?> points;
  final Function() startNavigation;

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
  final Function() startNavigation;
  final List<RouteParamsPoint?> points;

  @override
  ConsumerState<_RoutesCarousel> createState() => _RoutesCarouselState();
}

class _RoutesCarouselState extends ConsumerState<_RoutesCarousel> {
  late PageController _pageController;
  bool _animating = false;

  static const _bottomSheetHeight = 320;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: PathCardSize.fixedCardWidthWithPadding / widget.biggestWidth,
    );
    ref.read(cameraPaddingProvider.notifier).setPadding(
          CameraSetPaddingMessage(
            leftPadding: 0,
            topPadding: (MediaQuery.of(context).padding.top * MediaQuery.of(context).devicePixelRatio).toInt(),
            rightPadding: 0,
            bottomPadding: (_bottomSheetHeight * MediaQuery.of(context).devicePixelRatio).toInt(),
          ),
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

    return widgets.RoutesCarousel(
      navType: widget.navType,
      pageController: _pageController,
      routes: routes,
      onActiveChanged: (index) {
        if (_animating) {
          return;
        }

        ref.read(dgisControllerProvider).value?.setPublicTransportActiveRoute(index);
      },
      refresh: () {
        ref.invalidate(routesProvider);
      },
      startNavigation: widget.startNavigation,
    );
  }
}
