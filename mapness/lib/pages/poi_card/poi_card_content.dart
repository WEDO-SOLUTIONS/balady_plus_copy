part of 'poi_card_widget_page.dart';

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
  late final PoiCardState? poiCardState = widget.poiCardState;
  PoiCardBottomSheetState? _bottomSheetPreviousState;

  late final MultiStateSheetController<PoiCardBottomSheetState> _bottomSheetController = MultiStateSheetController(
    behavior: MultiSnappingBehavior(
      models: [
        FractionSnappingModel({0.0, .931}),
        OffsetSnappingModel({HeaderComponent.photosMaxHeight - PoiHeader.poiHeaderBorderRadius}),
        ComponentsSnappingModel(componentsDescriptions: [
          SnapComponent.merge(
            a: const SnapComponent.size(component: Components.header),
            b: const SnapComponent.size(component: Components.footer),
            merge: (a, b) => a + b,
          ),
        ])
      ],
    ),
    stateMapper: const PoiCardStateMapper(),
    initialState: PoiCardBottomSheetState.halfOpen,
  );

  @override
  void didUpdateWidget(covariant _PoiCardContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    final _parkingObjectId = widget.objectId == parkingObjectId;
    _tabType.value = _parkingObjectId ? PoiTabsType.parking : PoiTabsType.info;
    _tabController.animateTo(0);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    final _parkingObjectId = widget.objectId == parkingObjectId;
    _tabType = ValueNotifier(_parkingObjectId ? PoiTabsType.parking : PoiTabsType.info);
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
              _tabType.value = PoiTabsType.organizations;
              _bottomSheetController.setState(PoiCardBottomSheetState.expanded);
          }
        }
      },
    );

    // Initialize BssService event
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await BssService.instance.sendEvent(
        visibleRect: ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect,
        const BssRequest(
          eventType: BSSEventType.view,
          uiElement: BssUIElement(
            name: BssUIElementNames.directoryObjectCardScreen,
          ),
        ),
      );
    });

    _bottomSheetController.addListener(() {
      final state = _bottomSheetController.state;
      if (state == _bottomSheetPreviousState) {
        return;
      }
      _bottomSheetPreviousState = state;
      BssUIElementNames? uiElementName;
      switch (state) {
        case PoiCardBottomSheetState.hidden:
          uiElementName = BssUIElementNames.placeCardHidden;
        case PoiCardBottomSheetState.open:
          uiElementName = BssUIElementNames.placeCardOneThird;
        case PoiCardBottomSheetState.expanded:
          uiElementName = BssUIElementNames.placeCardFull;
        case PoiCardBottomSheetState.halfOpen:
          uiElementName = BssUIElementNames.placeCardTwoThird;
      }

      BssService.instance.sendEvent(
        visibleRect: ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect,
        BssRequest(
          eventType: BSSEventType.view,
          uiElement: BssUIElement(
            name: uiElementName,
            ownerName: BssUIElementNames.directoryObjectCardScreen,
          ),
          payload: BssPayload(
            placeItem: widget.data.toBss(),
          ),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      // Fix bug with Exception when calling ref after dispose
      if (!mounted) {
        return;
      }
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

    final parkingPoi = widget.objectId == parkingObjectId;

    final name = widget.data.buildingInfo.buildingName;
    if (name != null && parkingPoi == false) {
      widget.data.title = name;
    }

    final poiActions = ref.read(poiCardActionsProvider.notifier);

    final photos = ref.watch(poiPhotoProvider(widget.objectId));
    final isPhotosNotEmpty = (!photos.hasValue || photos.requireValue.items.isEmpty) && !photos.isLoading;

    final finishPoint = RouteSearchPoint(
      coordinates: widget.data.markerPosition!.toGeoPointMessage(),
      dgisObjectId: widget.data.id!,
    );

    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    final brief = briefInfo?.firstOrNull;

    String? createPoiHeaderSubTitle() {
      final carParkingLabel = [
        brief?.getBriefRouteDescription(context.l10n),
        brief?.getBriefRouteDistanceDescription(context.l10n),
      ].where((e) => e != null && e.trim().isNotEmpty).join(' ');

      return parkingPoi ? carParkingLabel : briefInfo?.firstOrNull?.getBriefRouteDescription(context.l10n);
    }

    final poiHeaderSubTitle = createPoiHeaderSubTitle();

    return Directionality(
      textDirection: Directionality.of(context),
      child: MultiStateSheet(
        dragger: null,
        scrollController: _bottomSheetController,
        offsetOutsideWidgetByTopheader: !isPhotosNotEmpty,
        safeAreaColor: context.colors.backgroundSurface2,
        backgroundColor: context.colors.backgroundSurface2,
        barrierColorDelegate: PoiCardStateMapper.barrierColorDelegate,
        outside: PoiCardMapControlsWrapper(
            bottomSheetController: _bottomSheetController,
            // we should not use objectIdForIndoorLevels if POI has levelId
            objectIdForIndoorLevels: poiCardState?.gisObjectIdMessage?.levelId != null ? null : widget.objectId),
        topHeader: PoiPhotosHeader(objectId: widget.objectId),
        topHeaderOffset: PoiCardStateMapper.topHeaderOffsetDelegate,
        footer: PoiCardFooter(
          closestPoint: widget.closestPoint,
          bottomSheetController: _bottomSheetController,
          data: widget.data,
          share: () {
            Metrics.logEventAdvanced(MetricsConstants.poiKeys.share,
                group: MetricsConstants.poiTag,
                action: MetricAction.tap.toString(),
                props: {
                  'object_id': widget.data.id?.objectId,
                  'closest_point': '${widget.closestPoint?.latitude},${widget.closestPoint?.longitude}'
                });

            return poiActions.share(
              objectId: widget.objectId,
              markerCoords: widget.closestPoint,
            );
          },
          callPhone: () {
            Metrics.logEventAdvanced(MetricsConstants.poiKeys.call,
                group: MetricsConstants.poiTag,
                action: MetricAction.tap.toString(),
                props: {
                  'objectId': widget.objectId,
                });

            final phoneNumber = widget.data.getContactsInfoModels.firstWhereOrNull(
              (element) => element.type == ContactsInfoType.phone,
            );
            _bssOnCallTap();
            if (phoneNumber?.value != null) {
              poiActions.callPhone(phoneNumber!.value!);
            }
          },
          onEntranceTap: () => poiActions.toggleEntrances(
            widget.data,
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
                _bssOnRouteTap();
            _openRoutingRoutes(
              context,
              widget.data.id!.objectId,
              widget.data.title,
              RouteParamsPoint(
                latitude: widget.data.markerPosition!.latitude,
                longitude: widget.data.markerPosition!.longitude,
                objectId: widget.data.id?.objectId,
                entranceId: widget.data.id?.entranceId,
                levelId: widget.data.levelId,
              ),
            );
          },
          onTapFavorite: (item) {
            _bssOnFavouritesTap();
            _onFavoriteTap(context: context, ref: ref, data: widget.data, favouriteItem: item);
          },
        ),
        header: PoiHeader(
          title: widget.data.address?.buildingName ?? widget.data.title,
          subTitle: _getParkingSubtitle(widget.data.parkingInfo, context.l10n) ?? widget.data.subtitle,
          subTitleExtraInlineSpans: (poiHeaderSubTitle != null)
              ? [
                  const TextSpan(text: ' • '),
                  WidgetSpan(
                    child: Icon(General16Icons.car, size: 16, color: context.colors.foregroundSoft),
                    baseline: TextBaseline.ideographic,
                    alignment: PlaceholderAlignment.middle,
                  ),
                  TextSpan(text: ' $poiHeaderSubTitle'),
                ]
              : [],
          parkingInfo: widget.data.parkingInfo,
          poiCardState: poiCardState,
          tabController: _tabController,
          data: widget.data,
          onTapClose: () {
            Metrics.logEventAdvanced(
              MetricsConstants.poiKeys.exitButton,
              group: MetricsConstants.poiTag,
              action: MetricAction.tap.toString(),
            );

            ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
            ref.read(parkingManageProvider.notifier).restoreMarker();
            ref.read(highlightProvider.notifier).removeHighlight(widget.data.id!);
            context.router.popForced();
          },
        ),
        sliver: ValueListenableBuilder(
          valueListenable: _tabType,
          builder: (context, tabType, _) => DecoratedSliver(
            decoration: BoxDecoration(
              color: context.colors.backgroundSurface4,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(PoiHeader.poiHeaderBorderRadius)),
            ),
            sliver: SliverFillAfter(
              sliver: SliverAnimatedSwitcher(
                duration: Durations.medium2,
                child: switch (tabType) {
                  PoiTabsType.info => PoiContentSliver(
                      poiCardState: poiCardState,
                      onEntrancesTap: () {
                        poiActions.toggleEntrances(
                          widget.data,
                          () => _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen),
                          widget.closestPoint,
                        );
                      },
                    ),
                  PoiTabsType.photos => PoiPhotoCardSliver(objectId: widget.data.id?.objectId ?? 0),
                  PoiTabsType.organizations => PoiOrganizationsSliver(
                      state: poiCardState,
                      objectId: widget.data.id!,
                      bottomTabsHeight: PoiCardFooter.height + 2 * PoiCardFooter.padding,
                    ),
                  PoiTabsType.parking => const SliverPadding(
                      padding: EdgeInsets.all(Spacing.$4x),
                      sliver: ParkingContent(),
                    ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// This is temporary solution. We need to show text for parking info
  /// If parking is not presented for this POI we return null
  /// Should work for all poi because only parking lots have parking info
  String? _getParkingSubtitle(ParkingInfoMessage? parkingInfo, AppLocalizations l10n) {
    if (parkingInfo == null) {
      return null;
    }
    final total = parkingInfo.capacity?.total;
    final freeText = parkingInfo.isPaid ? l10n.paid : l10n.free;
    if (total == null) {
      return freeText;
    }
    return '$total ${l10n.lots} • $freeText';
  }

  // BSS
  void _bssOnRouteTap() {
    BssService.instance.sendEvent(
      visibleRect: ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect,
      BssRequest(
        eventType: BSSEventType.action,
        actionType: BSSActionType.tap,
        uiElement: BssUIElement(
          name: const BssUIElementNames.buildRoute,
          ownerName: BssUIElementNames.actionBar,
        ),
        payload: BssPayload(
          placeItem: widget.data.toBss(),
        ),
      ),
    );
  }

  void _bssOnCallTap() {
    BssService.instance.sendEvent(
      visibleRect: ref.read(dgisControllerProvider.notifier).visibleRectSubject.valueOrNull?.visibleRect,
      const BssRequest(
        eventType: BSSEventType.action,
        actionType: BSSActionType.tap,
      ),
    );
  }

  void _bssOnFavouritesTap() {

  }

  void _bssSocialMediaTap() {

  }
}
