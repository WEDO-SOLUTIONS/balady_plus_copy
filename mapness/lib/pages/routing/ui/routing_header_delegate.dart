import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/landing/widgets/favorites.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/widgets/routing/ui/route_editor.dart';

class RoutingHeaderDelegate extends SliverPersistentHeaderDelegate {
  RoutingHeaderDelegate({
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return RoutingHeader(
      draggableScrollableController: draggableScrollableController,
    );
  }

  @override
  double get maxExtent => 196;

  @override
  double get minExtent => 196;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class RoutingHeader extends StatefulWidget {
  const RoutingHeader({
    super.key,
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  State<RoutingHeader> createState() => _RoutingHeaderState();
}

class _RoutingHeaderState extends State<RoutingHeader> {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 6,
          ),
          Center(
            child: Container(
              height: 4,
              width: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFDDE4EE),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RouteEditor(
              points: points,
              onTap: (index) {
                widget.draggableScrollableController.animateTo(
                  0.5,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
                RoutingSearchRoute(
                  placeholder: index == 0 ? "From" : "To",
                  showMyLocation:
                      index == 0 && points[index].type == RoutePointType.object,
                ).push(context).then((value) {
                  if (value != null && value is RoutePoint) {
                    setState(() {
                      points[index] = value;
                    });
                  }
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
                });
              },
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  points.swap(oldIndex, newIndex);
                });
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Favorites(
            background: Color(0x0D1E2A36),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
