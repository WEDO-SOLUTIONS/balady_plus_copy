part of 'poi_card_widget_page.dart';

class _PoiCardWrapper extends ConsumerStatefulWidget {
  final DgisObjectIdMessage objectId;
  final PoiCameraConfig? cameraConfig;
  final PoiCardDataFromGoogle? poiCardDataFromGoogle;
  final bool showHighlight;

  final LatLng? closestPoint;

  const _PoiCardWrapper({
    required this.objectId,
    required this.closestPoint,
    required this.showHighlight,
    this.cameraConfig,
    this.poiCardDataFromGoogle,
    super.key,
  });

  @override
  ConsumerState<_PoiCardWrapper> createState() => _WrapperState();
}

class _WrapperState extends ConsumerState<_PoiCardWrapper>
    with SingleTickerProviderStateMixin, AutoRouteAwareStateMixin<_PoiCardWrapper> {
  bool prevRouteNavi = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final routes = context.router.stack;
      prevRouteNavi = routes.length >= 2 && routes[routes.length - 2].name == PathNavRoute.name;

      // Hide Makkah place markers when regular POI is open
      if (kDebugMode) {
        logger.log('[MakkahPinDebug] Wrapper: initState setActive(true)');
      }
      ref.read(regularPoiActiveProvider.notifier).isActive = true;
    });

    Future.delayed(Duration.zero, () {
      if (!mounted) {
        return;
      }

      final isFoundinDay = ref.read(activeCityEventProvider)?.isFoundingDay ?? false;

      final isFoundingDayObject = ref
          .read(foundingDayUrbiProvider.notifier)
          .isFoundationObject(widget.objectId.objectId);

      if (isFoundinDay && isFoundingDayObject) {
        ConfettiAnimation.explodeInOverlay(context, this, config: getConfettiConfig(context));
      }
    });
  }

  ConfettiGeneratorConfig getConfettiConfig(BuildContext context) {
    final color = ref.read(activeCityEventProvider)?.fireworkGradientColors;
    final colors = ref.read(activeCityEventProvider)?.fireworkGradientColors2;
    return ConfettiGeneratorConfig.confetti(
      dissappearStartsAt: 0.33,
      dissappearCurve: Curves.easeInOutQuint,
      commonShapeAppearance: 1,
      animationDuration: const Duration(seconds: 4),
      mostCommonGradientColors: color,
      gradientColors: colors,
      mostCommonConfettiShape: (startPosition, velocity, scale, gradient, x, y, z) =>
          ShiningShape(startPosition, velocity, scale, gradient, x, y, z),
    );
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).unfocus();
  }

  @override
  void didPop() {
    _clearPoiSelectionState();
  }

  @override
  void didPush() {
    _scheduleProviderUpdate(() {
      ref.read(regularPoiActiveProvider.notifier).isActive = true;
    });
  }

  void _clearPoiSelectionState() {
    ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
    ref.read(highlightProvider.notifier).removeAll();
    ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme).notifier).restoreMarker();

    // Show Makkah place markers again when POI card is closed
    ref.read(regularPoiActiveProvider.notifier).isActive = false;
  }

  void _scheduleProviderUpdate(VoidCallback action) {
    Future<void>(() {
      if (!mounted) {
        return;
      }
      action();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModelProvider = poiCardProviderProvider(
      widget.objectId.objectId,
      context.read<ThemeController>().currentTheme,
      cameraConfig: widget.cameraConfig,
      closestPoint: widget.closestPoint,
      showHighlight: widget.showHighlight,
    );
    final state = ref.watch(viewModelProvider);
    ref
      ..listen(
        viewModelProvider,
        (prev, next) {
          next.whenOrNull(
            error: (error, stack) {
              if (error is TimeoutException) {
                ref.read(appRouterProvider).pop();
              }
            },
          );
        },
      )
      ..listen(poiCardClosingProvider, (_, shouldClose) {
        if (shouldClose) {
          _clearPoiSelectionState();
          context.router.removeWhere((route) => route.name == PoiCardWidgetRoute.name);
        }
      });

    final gisPoiCardState = state.value;
    final storeParking = ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme).notifier);
    final storeParkingData = ref
        .read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme))
        .value
        ?.convertToDirectoryObject(context);
    final isParkingPoi = widget.objectId.objectId == parkingObjectId;
    final data = isParkingPoi ? storeParkingData : gisPoiCardState?.gisObjectIdMessage;

    if (isParkingPoi) {
      storeParking.addPinParking(storeParkingData?.markerPosition, context.l10n.yourParkingSpot);
    }
    ref.watch(dgisEnvironmentProvider);
    final poiCardState =
        gisPoiCardState ??
        PoiCardState(
          showEntrances: false,
          isLoading: false,
          gisObjectIdMessage: data,
          organizations: null,
        );

    final isCityscapeObject = ref.read(cityscapeProvider.notifier).showCustomPin(widget.objectId.objectId);

    if (isCityscapeObject) {
      return _CityscapePoiCardContent(
        objectId: widget.objectId.objectId,
        closestPoint: widget.closestPoint,
        cameraConfig: widget.cameraConfig,
        poiCardState: poiCardState,
      );
    }

    final isFoundingDay = ref.read(activeCityEventProvider)?.isFoundingDay ?? false;
    final isFoundingDayObject = ref.read(foundingDayUrbiProvider.notifier).isFoundationObject(widget.objectId.objectId);

    final wrcEventPoint = ref.read(wRCProvider.notifier).getWRCEventPoint(widget.objectId.objectId);
    if (wrcEventPoint != null) {
      return _WrcCardContent(wrcEventPoint: wrcEventPoint, poiCardState: poiCardState);
    }
    if (isFoundingDay && isFoundingDayObject && data != null) {
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
        final isPlatformException =
            state.error is PlatformException &&
            ((state.error! as PlatformException).code == PoiError.platformExceptionCode ||
                (state.error! as PlatformException).message == 'NotFoundException');

        if (isPlatformException) {
          return PoiError(
            errorTitle: context.l10n.somethingWentWrong,
            errorContent: context.l10n.saudiPassSomethingWentWrongHint,
            buttonLabel: context.l10n.complete,
            onClose: () async {
              await ref.read(selectedMarkerProvider.notifier).removeAllMarkers();
              await ref.read(highlightProvider.notifier).removeHighlight(widget.objectId);
              ref.read(regularPoiActiveProvider.notifier).isActive = false;
              context.router.pop();
            },
            onRetry: () {
              context.router.pop();
            },
          );
        }
        return PoiError(
          errorTitle: context.l10n.somethingWentWrong,
          errorContent: context.l10n.saudiPassSomethingWentWrongHint,
          buttonLabel: context.l10n.complete,
          onRetry: () {
            ref.read(regularPoiActiveProvider.notifier).isActive = false;
            context.router.pop();
          },
        );
      }
    }();
    if (dataAndError != null) {
      return PoiLoadingOrErrorSheet(sheetHeight: 360, data: dataAndError);
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
  WidgetRef ref, {
  List<RouteParamsPointWithLabel>? intermediatePoints,
}) {
  openRoutingRoutes(context, objectId, title, finishPoint, ref, intermediatePoints: intermediatePoints);
}

void _onAddObjectPointToRoute(
  BuildContext context,
  AppLocalizations l10n,
  WidgetRef ref,
  DirectoryObjectMessage object,
) {
  ref.read(currentRouteProvider.notifier).addPointToRoute(object.toRouteParamsPointWithLabel());

  _onUpdateRouteState(context, l10n, object.id!.objectId, object.title, object.toRouteParamsPoint(), ref);
}

void _onAddEmptyPointToRoute(
  BuildContext context,
  AppLocalizations l10n,
  WidgetRef ref,
  int objectId,
  LatLng? closestPoint,
) {
  if (closestPoint == null) {
    return;
  }

  final point = RouteParamsPoint(
    latitude: closestPoint.latitude,
    longitude: closestPoint.longitude,
    objectId: objectId,
  );
  ref.read(currentRouteProvider.notifier).addPointToRoute(RouteParamsPointWithLabel(value: point, label: ''));

  _onUpdateRouteState(context, l10n, objectId, '', point, ref);
}

void _onRemoveObjectPointToRoute(
  BuildContext context,
  AppLocalizations l10n,
  WidgetRef ref,
  DirectoryObjectMessage object,
) {
  final objectId = object.id!.objectId;
  ref.read(currentRouteProvider.notifier).removePointFromRoute(objectId);

  _onUpdateRouteState(context, l10n, objectId, object.title, object.toRouteParamsPoint(), ref);
}

void _onRemoveEmptyPointToRoute(
  BuildContext context,
  AppLocalizations l10n,
  WidgetRef ref,
  int objectId,
  LatLng? closestPoint,
) {
  if (closestPoint == null) {
    return;
  }

  final point = RouteParamsPoint(
    latitude: closestPoint.latitude,
    longitude: closestPoint.longitude,
    objectId: objectId,
  );
  ref.read(currentRouteProvider.notifier).removePointFromRoute(objectId);

  _onUpdateRouteState(context, l10n, objectId, '', point, ref);
}

void _onUpdateRouteState(
  BuildContext context,
  AppLocalizations l10n,
  int objectId,
  String title,
  RouteParamsPoint finishPoint,
  WidgetRef ref,
) {
  final currentRouteState = ref.read(currentRouteProvider);
  if (currentRouteState == null) {
    throw Exception('The route must already exist to add point to it');
  }

  final finishPoint = currentRouteState.finishPoint;
  if (finishPoint == null) {
    return;
  }

  _onDirectionsTap(
    context,
    objectId,
    finishPoint.label,
    finishPoint.value!,
    ref,
    intermediatePoints: currentRouteState.intermediatePointsWithLabels?.points,
  );
}

Future<void> _onFavoriteTap({
  required BuildContext context,
  required WidgetRef ref,
  required DirectoryObjectMessage data,
  FavouriteItem? favouriteItem,
}) async {
  await ref
      .read(authMethodsProvider.notifier)
      .authOrOpen(
        context,
        callback: () {
          toggleFavoriteDirectoryObject(context: context, ref: ref, data: data, favouriteItem: favouriteItem);
        },
      );
}
