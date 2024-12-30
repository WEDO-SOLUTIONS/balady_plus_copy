import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_favourites.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

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
      FlexibleSpaceBar.createSettings(
        maxExtent: maxExtent,
        minExtent: minExtent,
        currentExtent: maxExtent,
        child: RoutingHeader(
          points: points,
          updatePoints: updatePoints,
        ),
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

class RoutingHeader extends ConsumerWidget {
  const RoutingHeader({
    required this.points,
    required this.updatePoints,
    super.key,
  });

  final List<RoutePoint> points;
  final void Function(List<RoutePoint>) updatePoints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ABRouteModel> items = [];
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final isMyLocation = point is RoutePointMyLocation;

      final title = point.title(context.l10n) ??
          switch (i) {
            0 => context.l10n.from,
            1 => context.l10n.to,
            _ => context.l10n.to,
          };

      items.add(ABRouteModel(
        title: title,
        isMyLocation: isMyLocation,
      ));
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          ABRoute(
            items: items,
            onTap: (i) => _onTap(i, context, ref),
            onReorder: _onReorder,
          ),
          Spacing.$4x.heightBox,
          RoutingFavourites(
            showBookmark: true,
            onFavouriteTap: _onFavouritesTap,
          ),
          Spacing.$4x.heightBox,
        ],
      ),
    );
  }

  Future<void> _onFavouritesTap(FavouriteItem point) async {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.startRouteFromFavorite,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
      props: {'id': point.entity?.id, 'destination': '${point.coordinates.latitude},${point.coordinates.longitude}'},
    );

    final index = points.indexWhere((element) => element is RoutePointFavouriteItem || element is RoutePointDirectoryObject);
    points[index] = RoutePointFavouriteItem(point);
    updatePoints(points);
  }

  void _onReorder(int oldIndex, int newIndex) {
    Metrics.logEventAdvanced(
      MetricsConstants.routesKeys.onReorder,
      group: MetricsConstants.routesTag,
      action: MetricAction.tap.toString(),
    );
    var newIndex_ = newIndex;
    if (oldIndex < newIndex_) {
      newIndex_ -= 1;
    }
    points.swap(oldIndex, newIndex_);
    updatePoints(points);
  }

  void _onTap(int index, BuildContext context, WidgetRef ref) async {
    Metrics.logEventAdvanced(MetricsConstants.routesKeys.changeLocation,
        group: MetricsConstants.routesTag,
        action: MetricAction.tap.toString(),
        props: {
          'isMyLocation': index == 0 && points[index] is! RoutePointMyLocation,
        });

    ref.read(searchProvider(SearchScopeEnum.routes.value).notifier).clear();

    final value = await context.router.push(
      RoutingSearchSheetRoute(
        placeholder: index == 0 ? context.l10n.from : context.l10n.to,
        showMyLocation: index == 0 && points[index] is! RoutePointMyLocation,
      ),
    );

    if (value != null && value is RoutePoint) {
      // We don't want to make route MyLocation - MyLocation and if we already have myLocation, we just
      // swap previous points
      if (points.whereType<RoutePointMyLocation>().length == 1 && value is RoutePointMyLocation) {
        points.swap(0, 1);
      } else {
        points[index] = value;
      }

      updatePoints(points);
    }
  }
}
