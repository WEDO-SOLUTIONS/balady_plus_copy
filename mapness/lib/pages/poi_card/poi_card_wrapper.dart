part of 'poi_card_widget_page.dart';

class _PoiCardWrapper extends ConsumerStatefulWidget {
  final DgisObjectIdMessage objectId;
  final PoiCameraConfig? cameraConfig;
  final PoiCardDataFromGoogle? poiCardDataFromGoogle;

  final LatLng? closestPoint;

  const _PoiCardWrapper({
    required this.objectId,
    required this.closestPoint,
    this.cameraConfig,
    this.poiCardDataFromGoogle,
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routes = context.router.stack;
      prevRouteNavi = routes.length >= 2 && routes[routes.length - 2].name == PathNavRoute.name;

      // Hide Makkah place markers when regular POI is open
      // ignore: avoid_print
      print('[MakkahPinDebug] Wrapper: initState setActive(true)');
      ref.read(regularPoiActiveProvider.notifier).setActive(true);
    });
  }

  @override
  void dispose() {
    // Capture the container before disposal to ensure we can update the provider
    final container = ProviderScope.containerOf(context, listen: false);

    // Show Makkah place markers again when regular POI is closed
    // Use Future.microtask to ensure it runs after disposal completes
    // ignore: avoid_print
    print('[MakkahPinDebug] Wrapper: dispose called');
    Future.microtask(() {
      // ignore: avoid_print
      print('[MakkahPinDebug] Wrapper: microtask setActive(false)');
      container.read(regularPoiActiveProvider.notifier).setActive(false);
    });

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final viewModelProvider = poiCardProviderProvider(
      widget.objectId.objectId,
      cameraConfig: widget.cameraConfig,
      closestPoint: widget.closestPoint,
    );
    final state = ref.watch(viewModelProvider);
    ref
      ..watch(poiOffersProvider.select((_) => null))
      ..listen(poiCardClosingProvider, (_, shouldClose) {
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

    final isCityscapeObject = ref.read(cityscapeProvider.notifier).showCustomPin(widget.objectId.objectId);

    if (isCityscapeObject) {
      return _CityscapePoiCardContent(
        objectId: widget.objectId.objectId,
        closestPoint: widget.closestPoint,
        cameraConfig: widget.cameraConfig,
        poiCardState: poiCardState,
      );
    }

    final isFoundingDayObject = ref.read(foundingDayUrbiProvider.notifier).isFoundationObject(widget.objectId.objectId);

    if (isFoundingDayObject && data != null) {
      return _FoundingDayPoiCardContent(
        objectId: widget.objectId.objectId,
        closestPoint: widget.closestPoint,
        cameraConfig: widget.cameraConfig,
        poiCardState: poiCardState,
        data: data,
      );
    }

    // We need to leave this block of code to specify the point where the route will be built. (BSA-2415)
    //
    // Example: The user put a point on the map in a field (or desert). If we don't change markerPosition to closestPoint,
    // we'll go to the center of this object, not to the point the user put.
    // The "Desert" object has an id and a conditional center of this object. And wherever the user puts a mark,
    // if we do not specify this point, the route will lead the user to the conditional center
    if (widget.closestPoint != null) {
      final closestPoint = widget.closestPoint!;
      data?.markerPosition = GeoPointWithElevationMessage(
        latitude: closestPoint.latitude,
        longitude: closestPoint.longitude,
        elevation: 0,
      );
    }

    final objectId = data?.id?.objectId;

    final dataAndError = () {
      if (state.isLoading && widget.objectId.objectId != parkingObjectId) {
        return const PoiLoading();
      }
      if ((state.hasError && widget.objectId.objectId != parkingObjectId) || objectId == null) {
        // sometimes error code is in message and sometimes in code, idk, probably changed in releases
        final isPlatformException = state.error is PlatformException &&
            ((state.error! as PlatformException).code == PoiError.platformExceptionCode ||
                (state.error! as PlatformException).message == 'NotFoundException');

        if (isPlatformException) {
          return PoiError(
            errorTitle: context.l10n.somethingWentWrong,
            errorContent: context.l10n.saudiPassSomethingWentWrongHint,
            buttonLabel: context.l10n.complete,
            onClose: () async {
              await ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
              await ref.read(highlightProvider.notifier).removeHighlight(widget.objectId);
              ref.read(regularPoiActiveProvider.notifier).setActive(false);
              context.router.popForced();
            },
            onRetry: () {
              if (!state.isRefreshing) {
                ref.invalidate(viewModelProvider);
              }
            },
          );
        }
        return PoiError(
          errorTitle: context.l10n.somethingWentWrong,
          errorContent: context.l10n.saudiPassSomethingWentWrongHint,
          buttonLabel: context.l10n.complete,
          onRetry: () {
            ref.read(regularPoiActiveProvider.notifier).setActive(false);
            context.router.popForced();
          },
        );
      }
    }();
    if (dataAndError != null) {
      return PoiLoadingOrErrorSheet(sheetHeight: 360, contentHeight: 300, data: dataAndError);
    }

    if (data == null) {
      return _PoiCardNoInfo(
        objectId: objectId!,
        poiCardState: poiCardState,
        closestPoint: widget.closestPoint,
        cameraConfig: widget.cameraConfig,
      );
    }

    return _PoiCardContent(
      objectId: objectId!,
      data: data,
      poiCardState: poiCardState,
      closestPoint: widget.closestPoint,
      cameraConfig: widget.cameraConfig,
      poiCardDataFromGoogle: widget.poiCardDataFromGoogle,
    );
  }
}

void _onDirectionsTap(
  BuildContext context,
  int objectId,
  String title,
  RouteParamsPoint finishPoint,
  WidgetRef ref,
) {
  Metrics.logEventAdvanced(MetricsConstants.poiKeys.makeRoute,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
      props: {'object_id': objectId, 'finish_point': '${finishPoint.latitude},${finishPoint.longitude}'});

  openRoutingRoutes(context, objectId, title, finishPoint, ref);
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
        props: {'objectId': data.id?.objectId},
      );

      toggleFavoriteDirectoryObject(context: context, ref: ref, data: data, favouriteItem: favouriteItem);
    },
  );
}
