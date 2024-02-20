import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/pages/routing/ui/routing_favourites.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/routing/ui/route_editor.dart';

class RoutingHeaderDelegate extends SliverPersistentHeaderDelegate {
  RoutingHeaderDelegate({
    required this.points,
    required this.updatePoints,
  });

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      RoutingHeader(
        points: points,
        updatePoints: updatePoints,
      );

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
    required this.points,
    required this.updatePoints,
    super.key,
  });

  final List<RoutePoint> points;
  final void Function(List<RoutePoint>) updatePoints;

  @override
  Widget build(BuildContext context) => Container(
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
                decoration: BoxDecoration(
                  color: context.color.surface_base_primary,
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
                onTap: (index) => RoutingSearchRoute(
                  placeholder: index == 0 ? context.l10n.from : context.l10n.to,
                  showMyLocation:
                      index == 0 && points[index] is! RoutePointMyLocation,
                ).push(context).then(
                  (value) {
                    if (value != null && value is RoutePoint) {
                      points[index] = value;
                      updatePoints(points);
                    }
                  },
                ),
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
            RoutingFavourites(
              showBookmark: true,
              onFavouriteTap: (point) async {
                final index =
                    points.indexWhere((element) => !element.isNotEmpty);
                points[index] = RoutePointFavouriteItem(point);
                updatePoints(points);
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      );
}
