part of 'poi_card_widget_page.dart';

class _PoiCardNoInfo extends HookConsumerWidget {
  final PoiCardState? poiCardState;
  final int objectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const _PoiCardNoInfo({required this.objectId, this.poiCardState, this.closestPoint, this.cameraConfig});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(
      onClose: (_) {
        closePoiCard(context, ref);
      },
    );
    final l10n = context.l10n;

    final poiActions = ref.read(poiCardActionsProvider.notifier);

    return ToggleSheet(
      safeAreaColor: context.colors.backgroundSurface2,
      backgroundColor: context.colors.backgroundSurface2,
      dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface2),
      header: PoiHeader(
        toggleSheetController: scrollController,
        title: '${closestPoint?.longitude.roundDecimal(places: 6)}, ${closestPoint?.latitude.roundDecimal(places: 6)}',
        subTitle: context.l10n.poi,
        poiCardState: poiCardState,
        onTapClose: () => closePoiCard(context, ref),
      ),
      outside: PoiCardMapControlsWrapper(objectIdForIndoorLevels: objectId),
      topHeader: PoiPhotosHeader(objectId: objectId),
      content: [
        const SizedBox(height: Spacing.$4x),
        PoiContentFeedbackCard(
          data: PoiContentFeedbackType.cityExpert,
          onTap: () {
            context.router.push(
              QuickFeedbackRoute(type: QuickFeedbackType.editCompany, params: FeedbackObjectIdParams(objectId)),
            );
          },
        ),
      ],
      footer: PoiCardFooter(
        share: () {
          return poiActions.share(objectId: objectId, markerCoords: closestPoint);
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
            RouteParamsPoint(latitude: closestPoint.latitude, longitude: closestPoint.longitude, objectId: objectId),
            ref,
          );
        },
        onAddPointToRoute: () => _onAddEmptyPointToRoute(context, l10n, ref, objectId, closestPoint),
        onRemovePointFromRoute: () => _onRemoveEmptyPointToRoute(context, l10n, ref, objectId, closestPoint),
        onTapFavorite: (item) =>
            _onFavoriteTap(context: context, ref: ref, data: poiCardState!.gisObjectIdMessage!, favouriteItem: item),
      ),
      scrollController: scrollController,
    );
  }
}
