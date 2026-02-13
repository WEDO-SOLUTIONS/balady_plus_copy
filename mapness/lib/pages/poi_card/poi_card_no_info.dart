part of 'poi_card_widget_page.dart';

class _PoiCardNoInfo extends HookConsumerWidget {
  final PoiCardState? poiCardState;
  final int objectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const _PoiCardNoInfo({
    required this.objectId,
    this.poiCardState,
    this.closestPoint,
    this.cameraConfig,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (_) {
      ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
      ref.read(regularPoiActiveProvider.notifier).setActive(false);
      context.router.popForced();
    });

    final poiActions = ref.read(poiCardActionsProvider.notifier);

    return ToggleSheet(
      safeAreaColor: context.colors.backgroundSurface2,
      backgroundColor: context.colors.backgroundSurface2,
      dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface2),
      header: PoiHeader(
        title: '${closestPoint?.longitude.roundDecimal(places: 6)}, ${closestPoint?.latitude.roundDecimal(places: 6)}',
        subTitle: context.l10n.poi,
        poiCardState: poiCardState,
        onTapClose: () {
          Metrics.logEventAdvanced(
            MetricsConstants.poiKeys.exitButton,
            group: MetricsConstants.poiTag,
            action: MetricAction.tap.toString(),
          );

          ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
          ref.read(regularPoiActiveProvider.notifier).setActive(false);
          context.router.popForced();
        },
      ),
      outside: PoiCardMapControlsWrapper(objectIdForIndoorLevels: objectId),
      topHeader: PoiPhotosHeader(objectId: objectId),
      content: [
        const SizedBox(height: Spacing.$4x),
        PoiContentFeedbackCard(
          data: PoiContentFeedbackType.cityExpert,
          onTap: () {
            context.router.push(QuickFeedbackRoute(
              type: QuickFeedbackType.editCompany,
              params: FeedbackObjectIdParams(objectId),
            ));
          },
        ),
      ],
      footer: PoiCardFooter(
        share: () {
          Metrics.logEventAdvanced(MetricsConstants.poiKeys.share,
              group: MetricsConstants.poiTag,
              action: MetricAction.tap.toString(),
              props: {'object_id': objectId, 'closest_point': '${closestPoint?.latitude},${closestPoint?.longitude}'});

          return poiActions.share(
            objectId: objectId,
            markerCoords: closestPoint,
          );
        },
        onTapCar: () {
          final closestPoint = this.closestPoint;
          if (closestPoint == null) {
            return;
          }

          _onDirectionsTap(
            context,
            objectId,
            '',
            RouteParamsPoint(
              latitude: closestPoint.latitude,
              longitude: closestPoint.longitude,
              objectId: objectId,
            ),
            ref,
          );
        },
        onTapFavorite: (item) =>
            _onFavoriteTap(context: context, ref: ref, data: poiCardState!.gisObjectIdMessage!, favouriteItem: item),
      ),
      scrollController: scrollController,
    );
  }
}
