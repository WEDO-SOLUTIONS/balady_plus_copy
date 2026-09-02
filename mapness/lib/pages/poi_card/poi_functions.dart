part of 'poi_card_widget_page.dart';

Future<void> closePoiCard(BuildContext context, WidgetRef ref) async {
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

Future<void> toggleFavoriteDirectoryObject({
  required BuildContext context,
  required WidgetRef ref,
  required DirectoryObjectMessage data,
}) async {
  /// Экран сам показывает текущее членство (чекбоксы) и Дом/Работу;
  /// сохранение списков идёт единым bulkAssignPlaceToLists по кнопке Save.
  await context.router.push(PickFavoriteListRoute(data: data));
}
