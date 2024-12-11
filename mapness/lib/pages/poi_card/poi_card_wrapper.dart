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
  @override
  Widget build(BuildContext context) {
    final viewModelProvider = poiCardProviderProvider(
      widget.objectId.objectId,
      cameraConfig: widget.cameraConfig,
      closestPoint: widget.closestPoint,
    );
    final state = ref.watch(viewModelProvider);

    final poiCardState = state.valueOrNull;
    final data = poiCardState?.gisObjectIdMessage;
    final objectId = data?.id?.objectId;

    if (widget.closestPoint != null) {
      final closestPoint = widget.closestPoint!;
      data?.markerPosition = GeoPointWithElevationMessage(
          latitude: closestPoint.latitude, longitude: closestPoint.longitude, elevation: 0);
    }

    /// loading progress indicator
    if (state.isLoading) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: PoiLoadingSheet(
          objectId: widget.objectId,
        ),
      );
    }

    /// error handling or invalid data
    if (state.hasError || objectId == null || data == null) {
      if (state.error is PlatformException &&

          /// sometimes error code is in message and sometimes in code, idk, probably changed in releases
          ((state.error! as PlatformException).code == 'NotFoundException' ||
              (state.error! as PlatformException).message == 'NotFoundException')) {
        return Column(
          children: [
            const Spacer(flex: 3),
            ErrorSheetV2(
              errorTitle: context.l10n.poiObjectNotFoundTitle,
              errorContent: context.l10n.poiObjectNotFoundContent,
              buttonLabel: context.l10n.poiObjectNotFoundButtonLabel,
              assetImage: 'assets/images_svg/happy_face.svg',
              package: PackageConfig.packageName,
              onRetry: () => context.router.popForced(),
            )
          ],
        );
      }
      return ErrorSheetWidget(
        onClose: (controller) {
          ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
          ref.read(highlightProvider.notifier).removeHighlight(widget.objectId);
          context.router.popForced();
        },
        onRetry: () {
          if (!state.isRefreshing) {
            ref.invalidate(viewModelProvider);
          }
        },
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
