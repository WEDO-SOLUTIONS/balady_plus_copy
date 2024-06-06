part of '../poi_card_footer.dart';

class _CarItem extends ConsumerWidget {
  final DirectoryObjectMessage? objectMessage;
  final RouteSearchPoint? finishPoint;
  final int flex;

  const _CarItem({
    required this.objectMessage,
    required this.finishPoint,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (objectMessage == null) {
      return const SizedBox.shrink();
    }
    return Flexible(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: BriefRouteButton(
          routeType: RouteSearchOptionsMessage.car,
          onTap: () => _openRoutingRoutes(context, ref),
          finishPoint: finishPoint,
        ),
      ),
    );
  }

  void _openRoutingRoutes(BuildContext context, WidgetRef ref) {
    final objectMessage = this.objectMessage;
    if (objectMessage == null) {
      return;
    }
    Metrics.logEventAdvanced(MetricsConstants.poiKeys.makeRoute,
        group: MetricsConstants.poiTag,
        action: MetricAction.tap.toString(),
        props: {
          'object_id': objectMessage.id?.objectId,
          'finish_point': '${finishPoint?.coordinates.latitude},${finishPoint?.coordinates.longitude}'
        });
    final goRouter = ref.read(goRouterProvider);
    final matches = goRouter.routerDelegate.currentConfiguration.matches;
    final hasRoutingRoutes = matches.any((element) => element.matchedLocation == RoutingRoutesRoute.path);
    if (hasRoutingRoutes) {
      context.popRouteUntilFirst();
      final dgisObjectId = objectMessage.id?.objectId;
      if (dgisObjectId != null) {
        PoiMapRoute.open(goRouter, dgisObjectId);
      }
    }
    final route = _getRoutingRoutesRoute(objectMessage, context.l10n.myLocation);
    unawaited(route.push(context));
  }

  RoutingRoutesRoute _getRoutingRoutesRoute(
    DirectoryObjectMessage objectMessage,
    String startLabel,
  ) =>
      RoutingRoutesRoute(
        finishLabel: objectMessage.title,
        finishLatitude: objectMessage.markerPosition!.latitude,
        finishLongitude: objectMessage.markerPosition!.longitude,
        finishObjectId: objectMessage.id?.objectId,
        finishEntranceId: objectMessage.id?.entranceId,
        finishLevelId: objectMessage.levelId,
        startLabel: startLabel,
        startLatitude: null,
        startLongitude: null,
        startObjectId: null,
        startEntranceId: null,
        startLevelId: null,
      );
}
