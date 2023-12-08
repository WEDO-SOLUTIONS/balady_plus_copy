import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/quick_filters/ui/quick_filters.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/routing/ui/route_editor.dart';

class RoutingHeaderDelegate extends SliverPersistentHeaderDelegate {
  RoutingHeaderDelegate({
    required this.points,
    required this.updatePoints,
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return RoutingHeader(
      points: points,
      updatePoints: updatePoints,
      draggableScrollableController: draggableScrollableController,
    );
  }

  final List<RoutePoint> points;
  final void Function(List<RoutePoint>) updatePoints;

  @override
  double get maxExtent => 196;

  @override
  double get minExtent => 196;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class RoutingHeader extends StatelessWidget {
  const RoutingHeader({
    super.key,
    required this.points,
    required this.updatePoints,
    required this.draggableScrollableController,
  });

  final List<RoutePoint> points;
  final void Function(List<RoutePoint>) updatePoints;
  final DraggableScrollableController draggableScrollableController;

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
                draggableScrollableController.animateTo(
                  0.5,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                );
                RoutingSearchRoute(
                  placeholder: index == 0 ? context.l10n.from : context.l10n.to,
                  showMyLocation:
                      index == 0 && points[index].type == RoutePointType.object,
                ).push(context).then((value) {
                  if (value != null && value is RoutePoint) {
                    points[index] = value;
                    updatePoints(points);
                  }
                });
              },
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                points.swap(oldIndex, newIndex);
                updatePoints(points);
              },
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          QuickFilters(
            onFavouritesBookmarkTap: () {},
            onFilterTap: (_, __) {},
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
