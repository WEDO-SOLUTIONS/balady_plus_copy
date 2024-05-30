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
    final objectMessage_ = objectMessage;
    if (objectMessage_ == null) {
      return const SizedBox.shrink();
    }
    return Flexible(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: BriefRouteButton(
          routeType: RouteSearchOptionsMessage.car,
          onTap: () {
            Metrics.logEventAdvanced(MetricsConstants.poiKeys.makeRoute,
                group: MetricsConstants.poiTag,
                action: MetricAction.tap.toString(),
                props: {
                  'object_id': objectMessage?.id?.objectId,
                  'finish_point': '${finishPoint?.coordinates.latitude},${finishPoint?.coordinates.longitude}'
                });

            getRoute(
              objectMessage_,
              context.l10n.myLocation,
            ).push(context);
          },
          finishPoint: finishPoint,
        ),
      ),
    );
  }

  RoutingRoutesRoute getRoute(
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
