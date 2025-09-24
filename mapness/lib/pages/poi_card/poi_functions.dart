part of 'poi_card_widget_page.dart';

void openRoutingRoutes(
  BuildContext context,
  int objectId,
  String title,
  RouteParamsPoint finishPoint,
  WidgetRef ref,
) {
  final mapSetting = MapObjectManagerSettings.search();
  ref
      .read(
        mapObjectManagerProvider(
          named: mapSetting.name,
          layerId: mapSetting.layerId,
        ).notifier,
      )
      .setMapObjectManagerIsVisible(isVisible: false);

  context.router.push(
    RoutingRoutesRoute(
      points: [
        RouteParamsPointWithLabel(
          value: null,
          label: context.l10n.myLocation,
        ),
        RouteParamsPointWithLabel(
          value: finishPoint,
          label: title,
        ),
      ],
    ),
  );
}

void toggleFavoriteDirectoryObject({
  required BuildContext context,
  required WidgetRef ref,
  required DirectoryObjectMessage data,
  required FavouriteItem? favouriteItem,
}) {
  final favState = ref.read(favouriteCacheProvider).valueOrNull;
  final favRepo = ref.read(favouriteCacheProvider.notifier);

  /// if already in favourites - remove
  if (favouriteItem != null) {
    favRepo.deleteItem(favouriteItem);
    return;
  }

  FavouriteItem? favItem = favouriteItem;
  if (favItem == null && data.markerPosition != null && data.id != null) {
    favItem = FavouriteItem(
      coordinates: Coordinates(
        latitude: data.markerPosition!.latitude,
        longitude: data.markerPosition!.longitude,
      ),
      id: 'overriden',
      subtitle: data.subtitle,
      title: data.title,
      entity: FavouriteItemEntity(
        sourceType: EntitySourceType.urbi,
        id: data.id!.objectId.toString(),
      ),
    );
  }

  if (favItem == null) {
    return;
  }

  /// do not show dialog if home and work are set
  if (favState?.home != null && favState?.work != null) {
    favRepo.addItem(data.mapToFavourite());
  } else {
    /// show dialog to choose home, work or regular
    context.router.push(PoiFavoriteDialogRoute(favItem: favItem));
  }
}
