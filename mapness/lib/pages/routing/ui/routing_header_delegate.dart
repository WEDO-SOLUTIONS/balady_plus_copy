import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_favourites.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/widgets/routing/ui/route_editor.dart';

class RoutingHeaderDelegate extends SliverPersistentHeaderDelegate {
  RoutingHeaderDelegate({
    required this.points,
    required this.updatePoints,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      RoutingHeader(
        points: points,
        updatePoints: updatePoints,
      );

  final List<RoutePoint> points;
  final void Function(List<RoutePoint>) updatePoints;

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 200;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class RoutingHeader extends ConsumerWidget {
  const RoutingHeader({
    required this.points,
    required this.updatePoints,
    super.key,
  });

  final List<RoutePoint> points;
  final void Function(List<RoutePoint>) updatePoints;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 6,
            ),
            const Center(child: SheetDragger()),
            const SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RouteEditor(
                points: points,
                onTap: (index) {
                  Metrics.logEventAdvanced(MetricsConstants.routesKeys.changeLocation,
                      group: MetricsConstants.routesTag,
                      action: MetricAction.tap.toString(),
                      props: {
                        'isMyLocation': index == 0 && points[index] is! RoutePointMyLocation,
                      });

                  ref.read(searchProvider(SearchScopeEnum.routes.value).notifier).clear();

                  RoutingSearchRoute(
                    placeholder: index == 0 ? context.l10n.from : context.l10n.to,
                    showMyLocation: index == 0 && points[index] is! RoutePointMyLocation,
                  ).push(context).then(
                    (value) {
                      if (value != null && value is RoutePoint) {
                        points[index] = value;
                        updatePoints(points);
                      }
                    },
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  Metrics.logEventAdvanced(
                    MetricsConstants.routesKeys.onReorder,
                    group: MetricsConstants.routesTag,
                    action: MetricAction.tap.toString(),
                  );

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
                Metrics.logEventAdvanced(
                  MetricsConstants.routesKeys.startRouteFromFavorite,
                  group: MetricsConstants.routesTag,
                  action: MetricAction.tap.toString(),
                  props: {
                    'id': point.entity?.id,
                    'destination': '${point.coordinates.latitude},${point.coordinates.longitude}'
                  },
                );

                final index = points.indexWhere((element) => !element.isNotEmpty);
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
