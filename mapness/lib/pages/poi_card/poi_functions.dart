part of 'poi_card_widget_page.dart';

Future<void> closePoiCard(BuildContext context, WidgetRef ref) async {
  Metrics.logEventAdvanced(
    MetricsConstants.poiKeys.exitButton,
    group: MetricsConstants.poiTag,
    action: MetricAction.tap.toString(),
  );

  // Show Makkah place markers again when POI card is closed
  ref.read(regularPoiActiveProvider.notifier).setActive(false);

  ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
  ref.read(highlightProvider.notifier).removeAll();

  final navState = await ActiveNavigationHelper.getState(ref.read(dgisControllerProvider).value);

  if (navState.isActive && context.mounted) {
    await context.router.pushAndPopUntil(
      PathNavRoute(navType: navState.navType!, initAction: PathNavPageInitAction.restoreFromState),
      predicate: (route) => route.settings.name == BottomMenuRoute.name,
    );
    return;
  }

  if (context.mounted) {
    context.router.pop();
  }
}

void openRoutingRoutes(
  BuildContext context,
  int objectId,
  String title,
  RouteParamsPoint finishPoint,
  WidgetRef ref, {
  List<RouteParamsPointWithLabel>? intermediatePoints,
}) {
  final mapSetting = MapObjectManagerSettings.search();
  ref
      .read(mapObjectManagerProvider(named: mapSetting.name, layerId: mapSetting.layerId).notifier)
      .setMapObjectManagerIsVisible(isVisible: false);

  context.router.push(
    RoutingRoutesRoute(
      points: [
        RouteParamsPointWithLabel(value: null, label: context.l10n.myLocation),
        ...?intermediatePoints,
        RouteParamsPointWithLabel(value: finishPoint, label: title),
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
  final favState = ref.read(favouriteCacheProvider).value;
  final favRepo = ref.read(favouriteCacheProvider.notifier);

  /// if already in favourites - remove
  if (favouriteItem != null) {
    favRepo.deleteItem(favouriteItem);
    return;
  }

  FavouriteItem? favItem = favouriteItem;
  if (favItem == null && data.markerPosition != null && data.id != null) {
    favItem = data.mapToFavourite();
  }

  if (favItem == null) {
    return;
  }

  /// do not show dialog if home and work are set
  if (favState?.home != null && favState?.work != null) {
    favRepo.addItem(data.mapToFavourite());
  } else {
    /// Build the rich POI here, where [data] (addr/type/marker) is still in
    /// hand, so `favorite_add` reports poi_addr/poi_type/poi_distance.
    final loc = ref.read(locationProvider);
    final favoritePoi = data.toDataFinderPoi(myLat: loc?.latitude, myLon: loc?.longitude);

    /// show dialog to choose home, work or regular
    context.router.push(PoiFavoriteDialogRoute(favItem: favItem, favoritePoi: favoritePoi));
  }
}
