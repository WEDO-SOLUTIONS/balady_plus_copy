import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/pages/routing/ui/routing_header_delegate.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
import 'package:mapness/pages/routing/ui/routing_map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

class RoutingPointsPage extends StatelessWidget {
  /// open page with collapsed bottom sheet
  final bool collapseInitially;

  const RoutingPointsPage({
    required this.collapseInitially,
    super.key,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => RoutingPointsSheet(
          biggestHeight: constraints.biggest.height,
          collapseInitially: collapseInitially,
        ),
      );
}

class RoutingPointsSheet extends ConsumerStatefulWidget {
  final double biggestHeight;
  final bool collapseInitially;

  const RoutingPointsSheet({
    required this.biggestHeight,
    required this.collapseInitially,
    super.key,
  });

  @override
  ConsumerState<RoutingPointsSheet> createState() => _RoutingPointsSheetState();
}

class _RoutingPointsSheetState extends ConsumerState<RoutingPointsSheet> {
  List<RoutePoint> points = [
    RoutePointMyLocation(),
    RoutePointDirectoryObject(null),
  ];

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          RoutingMapControls(
              bottomExtent: 136),
          DgisBottomSheet(
            showBarrier: false,
            availableExpansions: const {
              Expansion.collapsed,
              Expansion.expanded,
              Expansion.middle,
            },
            initialExpansion: widget.collapseInitially
                ? Expansion.collapsed
                : Expansion.middle,
            middleHeight: 0.7 * widget.biggestHeight,
            collapsedHeight: 136,
            scrollableBody: (context, scrollController) => Container(
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
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
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
                              startLabel: points[0].title(context.l10n) ?? '',
                              finishLatitude: points[1].latitude,
                              finishLongitude: points[1].longitude,
                              finishLabel: points[1].title(context.l10n) ?? '',
                            ).go(context);
                          }
                        },
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
                              startLabel: points[0].title(context.l10n) ?? '',
                              finishLatitude: points[1].latitude,
                              finishLongitude: points[1].longitude,
                              finishLabel: points[1].title(context.l10n) ?? '',
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
        ],
      ),
    );
  }
}
