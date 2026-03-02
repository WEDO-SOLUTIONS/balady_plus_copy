part of 'poi_card_widget_page.dart';

Future<void> closePoiCard(BuildContext context, WidgetRef ref) async {
  Metrics.logEventAdvanced(
    MetricsConstants.poiKeys.exitButton,
    group: MetricsConstants.poiTag,
    action: MetricAction.tap.toString(),
  );

  await ref.read(selectedMarkerProvider.notifier).removeAllMarkers();
  await ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme).notifier).restoreMarker();

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
    /// show dialog to choose home, work or regular
    context.router.push(PoiFavoriteDialogRoute(favItem: favItem));
  }
}
