part of 'poi_card_widget_page.dart';

const _titleHorizontalPadding = 84.0;
const _headerHegihtWithoutTitle = 170.0;
const _minBottomPadding = 16.0;

class _PoiCardContent extends ConsumerStatefulWidget {
  final DirectoryObjectMessage data;
  final PoiCardState? poiCardState;
  final int objectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const _PoiCardContent({
    required this.data,
    required this.objectId,
    required this.poiCardState,
    this.closestPoint,
    this.cameraConfig,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContentState();
}

class _ContentState extends ConsumerState<_PoiCardContent> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ValueNotifier<PoiTabsType> _tabType;
  late final DirectoryObjectMessage data = widget.data;
  late final int objectId = widget.objectId;
  late final PoiCardState? poiCardState = widget.poiCardState;

  late final StatefulBottomSheetController<PoiCardBottomSheetState> _bottomSheetController = () {
    final height = MediaQuery.sizeOf(context).height;
    final openSheetHeight = height - photosMaxHeight - Spacing.$8x;
    final halfOpenHeight = _calculateInitialHeight();
    return StatefulBottomSheetController(
      behavior: AspectRatioSnappingBehavior(
        aspectRatios: {0.0, halfOpenHeight / height, openSheetHeight / height, 1.0},
      ),
      stateMapper: const PoiCardStateMapper(),
      initialState: PoiCardBottomSheetState.halfOpen,
    );
  }();

  /// TODO(ilyasov): This is a temporart solution.
  /// Need to be rafactored after [StatefulBottomSheet] supports multisnapping behavior
  double _calculateInitialHeight() {
    final span = TextSpan(
      text: data.title,
      style: context.textStyleV3.h2SemiBold,
    );
    final width = MediaQuery.sizeOf(context).width - _titleHorizontalPadding;
    final textDirection = Directionality.of(context);

    final painter = TextPainter(
      text: span,
      maxLines: 2,
      textDirection: textDirection,
    )..layout(
        maxWidth: width,
      );

    final bottomPadding = max(_minBottomPadding, MediaQuery.paddingOf(context).bottom);

    return _headerHegihtWithoutTitle + painter.height + bottomPadding;
  }

  @override
  void didUpdateWidget(covariant _PoiCardContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    _tabController.animateTo(0);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    _tabType = ValueNotifier(PoiTabsType.info);
    _tabController.addListener(
      () {
        if (_tabController.indexIsChanging) {
          _bottomSheetController.position.animateTo(0, duration: Durations.medium1, curve: Curves.easeInExpo);
          switch (_tabController.index) {
            case 0:
              _tabType.value = PoiTabsType.info;
            case 1:
              _tabType.value = PoiTabsType.photos;
              _bottomSheetController.setState(PoiCardBottomSheetState.expanded);
            case 2:
              _tabType.value = PoiTabsType.inBuilding;
              _bottomSheetController.setState(PoiCardBottomSheetState.expanded);
          }
        }
      },
    );

    Future.delayed(const Duration(milliseconds: 250), () {
      ref.read(cameraPaddingProvider.notifier).resetPadding();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// has value
    ref.listen(
      poiPhotoProvider(widget.objectId),
      (previous, next) {
        if (next.hasValue == true && next.value?.items.isNotEmpty == true) {
          return;
        }
      },
    );

    final name = data.buildingInfo.buildingName;
    if (name != null) {
      data.title = name;
    }

    final poiActions = ref.read(poiCardActionsProvider.notifier);
    return Directionality(
      textDirection: Directionality.of(context),
      child: SafeArea(
        child: StatefulBottomSheet(
          scrollController: _bottomSheetController,
          safeAreaColor: context.colorsV2.backgroundScreen,
          backgroundColor: context.colorsV2.backgroundSurface4,
          backgroundColorDelegate: PoiCardStateMapper.backgroundColorDelegate,
          outside: PoiCardMapControlsWrapper(
              bottomSheetController: _bottomSheetController,
              // we should not use objectIdForIndoorLevels if POI has levelId
              objectIdForIndoorLevels: poiCardState?.gisObjectIdMessage?.levelId != null ? null : objectId),
          topHeader: PoiPhotosHeader(objectId: objectId),
          footer: PoiCardFooter(
            data: data,
            share: () {
              Metrics.logEventAdvanced(MetricsConstants.poiKeys.share,
                  group: MetricsConstants.poiTag,
                  action: MetricAction.tap.toString(),
                  props: {
                    'object_id': data.id?.objectId,
                    'closest_point': '${widget.closestPoint?.latitude},${widget.closestPoint?.longitude}'
                  });

              poiActions.share(
                objectId: objectId,
                markerCoords: widget.closestPoint,
              );
            },
            callPhone: () {
              Metrics.logEventAdvanced(MetricsConstants.poiKeys.call,
                  group: MetricsConstants.poiTag,
                  action: MetricAction.tap.toString(),
                  props: {
                    'objectId': objectId,
                  });

              final phoneNumber = data.getContactsInfoModels().firstWhereOrNull(
                    (element) => element.type == ContactsInfoType.phone,
                  );
              if (phoneNumber?.value != null) {
                poiActions.callPhone(phoneNumber!.value!);
              }
            },
            onEntranceTap: () => poiActions.toggleEntrances(
              data,
              () => _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen),
              widget.closestPoint,
            ),
            onTapCar: () {
              final mapSetting = MapObjectManagerSettings.search();
              ref
                  .read(
                    mapObjectManagerProvider(
                      named: mapSetting.name,
                      layerId: mapSetting.layerId,
                    ).notifier,
                  )
                  .setMapObjectManagerIsVisible(isVisible: false);

              _openRoutingRoutes(
                context,
                data,
                RouteSearchPoint(
                  coordinates: data.markerPosition!.toGeoPointMessage(),
                  dgisObjectId: data.id!,
                ),
              );
            },
            onTapFavorite: (item) => _onFavoriteTap(context: context, ref: ref, data: data, favouriteItem: item),
          ),
          header: PoiHeader(
            poiCardState: poiCardState,
            tabController: _tabController,
            data: data,
            onTapClose: () {
              Metrics.logEventAdvanced(
                MetricsConstants.poiKeys.exitButton,
                group: MetricsConstants.poiTag,
                action: MetricAction.tap.toString(),
              );

              ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
              ref.read(highlightProvider.notifier).removeHighlight(data.id!);
              context.router.popForced();
            },
          ),
          sliverBeforeContent: ValueListenableBuilder(
            valueListenable: _tabType,
            builder: (context, tabType, _) => SliverAnimatedSwitcher(
              duration: Durations.medium2,
              child: switch (tabType) {
                PoiTabsType.info => SliverToBoxAdapter(
                    child: InfoWidget(
                      objectInfo: poiCardState?.gisObjectIdMessage,
                      qrTradeLicense: poiCardState?.qrTradeLicense,
                      onEntrancesTap: () => poiActions.toggleEntrances(
                        data,
                        () => _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen),
                        widget.closestPoint,
                      ),
                    ),
                  ),
                PoiTabsType.photos => PoiPhotoCardSliver(objectId: data.id?.objectId ?? 0),
                PoiTabsType.inBuilding => PoiInBuildingSliver(
                    state: poiCardState,
                    objectId: data.id!,
                    bottomTabsHeight: PoiCardFooter.height + 2 * PoiCardFooter.padding,
                  ),
              },
            ),
          ),
        ),
      ),
    );
  }

  void _openRoutingRoutes(
    BuildContext context,
    DirectoryObjectMessage objectMessage,
    RouteSearchPoint finishPoint,
  ) {
    Metrics.logEventAdvanced(MetricsConstants.poiKeys.makeRoute,
        group: MetricsConstants.poiTag,
        action: MetricAction.tap.toString(),
        props: {
          'object_id': objectMessage.id?.objectId,
          'finish_point': '${finishPoint.coordinates.latitude},${finishPoint.coordinates.longitude}'
        });

    context.router.push(
      RoutingRoutesRoute(
        points: [
          RouteParamsPointWithLabel(
            value: null,
            label: context.l10n.myLocation,
          ),
          RouteParamsPointWithLabel(
            value: RouteParamsPoint(
              latitude: objectMessage.markerPosition!.latitude,
              longitude: objectMessage.markerPosition!.longitude,
              objectId: objectMessage.id?.objectId,
              entranceId: objectMessage.id?.entranceId,
              levelId: objectMessage.levelId,
            ),
            label: objectMessage.title,
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
}
