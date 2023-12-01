import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/pages/routing/ui/routing_header_delegate.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

class RoutingPointsPage extends StatelessWidget {
  const RoutingPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => RoutingPointsSheet(
        biggestHeight: constraints.biggest.height,
      ),
    );
  }
}

class RoutingPointsSheet extends ConsumerStatefulWidget {
  const RoutingPointsSheet({
    super.key,
    required this.biggestHeight,
  });

  final double biggestHeight;

  @override
  ConsumerState<RoutingPointsSheet> createState() => _RoutingPointsSheetState();
}

class _RoutingPointsSheetState extends ConsumerState<RoutingPointsSheet> {
  late DraggableScrollableController _controller;

  double get _minExtent => 136 / widget.biggestHeight;

  List<RoutePoint> points = [
    RoutePoint(
      type: RoutePointType.myLocation,
      object: null,
    ),
    RoutePoint(
      type: RoutePointType.object,
      object: null,
    )
  ];

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    Future.delayed(Duration.zero, () {
      _controller.animateTo(
        0.7,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentRouteProvider, (prev, next) {
      if (next == "/routing") {
        _controller.animateTo(
          0.7,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: _minExtent,
        minChildSize: _minExtent,
        maxChildSize: 0.9,
        snap: true,
        snapSizes: [_minExtent, 0.7, 0.9],
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
            ),
          ),
          child: Material(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
            ),
            color: const Color(0x0D1E2A36),
            child: CustomScrollView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  delegate: RoutingHeaderDelegate(
                    points: points,
                    updatePoints: (newPoitns) {
                      setState(() {
                        points = newPoitns;
                      });
                      if (points.every((element) => element.isNotEmpty)) {
                        RoutingRoutesRoute(
                          startLatitude: points[0].latitude,
                          startLongitude: points[0].longitude,
                          startLabel: points[0].title ?? "",
                          finishLatitude: points[1].latitude,
                          finishLongitude: points[1].longitude,
                          finishLabel: points[1].title ?? "",
                        ).go(context);
                      }
                    },
                    draggableScrollableController: _controller,
                  ),
                  pinned: true,
                ),
                SliverToBoxAdapter(
                  child: RoutingHistory(
                    updatePoint: (point) {
                      setState(() {
                        if (points[0].isNotEmpty) {
                          points[1] = point;
                        } else {
                          points[0] = point;
                        }
                      });
                      if (points.every((element) => element.isNotEmpty)) {
                        RoutingRoutesRoute(
                          startLatitude: points[0].latitude,
                          startLongitude: points[0].longitude,
                          startLabel: points[0].title ?? "",
                          finishLatitude: points[1].latitude,
                          finishLongitude: points[1].longitude,
                          finishLabel: points[1].title ?? "",
                        ).go(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
