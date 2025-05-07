part of 'poi_card_widget_page.dart';

class _PoiCardWrapper extends ConsumerStatefulWidget {
  final DgisObjectIdMessage objectId;
  final PoiCameraConfig? cameraConfig;

  final LatLng? closestPoint;

  const _PoiCardWrapper({
    required this.objectId,
    required this.closestPoint,
    this.cameraConfig,
    super.key,
  });

  @override
  ConsumerState<_PoiCardWrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<_PoiCardWrapper> {
  bool prevRouteNavi = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routes = context.router.stack;
      prevRouteNavi = routes.length >= 2 && routes[routes.length - 2].name == PathNavRoute.name;
    });
  }

  @override
  void dispose() {
    if (prevRouteNavi) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModelProvider = poiCardProviderProvider(
      widget.objectId.objectId,
      cameraConfig: widget.cameraConfig,
      closestPoint: widget.closestPoint,
    );
    final state = ref.watch(viewModelProvider);
    ref.listen(poiCardClosingProvider, (_, shouldClose) {
      if (shouldClose) {
        context.router.removeWhere((route) => route.name == PoiCardWidgetRoute.name);
      }
    });

    final poiCardState = state.valueOrNull;
    final storeParking = ref.read(parkingManageProvider.notifier);
    final storeParkingData = ref.read(parkingManageProvider).valueOrNull?.convertToDirectoryObject(context);
    final isParkingPoi = widget.objectId.objectId == parkingObjectId;
    final data = isParkingPoi ? storeParkingData : poiCardState?.gisObjectIdMessage;

    if (isParkingPoi) {
      storeParking.addPinParking(storeParkingData?.markerPosition, context.l10n.yourParkingSpot);
    }

    final objectId = data?.id?.objectId;

    /// loading progress indicator
    if (state.isLoading && widget.objectId.objectId != parkingObjectId) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: PoiLoadingSheet(
          objectId: widget.objectId,
        ),
      );
    }

    /// error handling or invalid data
    if ((state.hasError && widget.objectId.objectId != parkingObjectId) || objectId == null) {
      if (state.error is PlatformException &&

          /// sometimes error code is in message and sometimes in code, idk, probably changed in releases
          ((state.error! as PlatformException).code == 'NotFoundException' ||
              (state.error! as PlatformException).message == 'NotFoundException')) {
        return Column(
          children: [
            const Spacer(flex: 3),
            ErrorSheetV2(
              errorTitle: context.l10n.somethingWentWrong,
              errorContent: context.l10n.saudiPassSomethingWentWrongHint,
              buttonLabel: context.l10n.complete,
              assetImage: Assets.imagesSvg.illustrationError.keyName,
              onRetry: () => context.router.popForced(),
            )
          ],
        );
      }
      return ErrorSheetWidget(
        onClose: (controller) async {
          await ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
          await ref.read(highlightProvider.notifier).removeHighlight(widget.objectId);
          context.router.popForced();
        },
        onRetry: () {
          if (!state.isRefreshing) {
            ref.invalidate(viewModelProvider);
          }
        },
      );
    }

    if (data == null) {
      return _PoiCardNoInfo(
        objectId: objectId,
        poiCardState: poiCardState,
        closestPoint: widget.closestPoint,
        cameraConfig: widget.cameraConfig,
      );
    }

    return _PoiCardContent(
      objectId: objectId,
      data: data,
      poiCardState: poiCardState,
      closestPoint: widget.closestPoint,
      cameraConfig: widget.cameraConfig,
    );
  }
}

void _openRoutingRoutes(
  BuildContext context,
  int objectId,
  String title,
  RouteParamsPoint finishPoint,
) {
  Metrics.logEventAdvanced(MetricsConstants.poiKeys.makeRoute,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
      props: {'object_id': objectId, 'finish_point': '${finishPoint.latitude},${finishPoint.longitude}'});

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

Future<void> _onFavoriteTap({
  required BuildContext context,
  required WidgetRef ref,
  required DirectoryObjectMessage data,
  FavouriteItem? favouriteItem,
}) async {
  await ref.read(authMethodsProvider.notifier).authOrOpen(
    context,
    callback: () {
      Metrics.logEventAdvanced(
        MetricsConstants.poiKeys.addToFavorite,
        group: MetricsConstants.poiTag,
        action: MetricAction.tap.toString(),
        props: {
          'objectId': data.id?.objectId,
        },
      );

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
    },
  );
}
