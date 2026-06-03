part of 'poi_card_widget_page.dart';

class _FoundingDayPoiCardContent extends ConsumerStatefulWidget {
  final int objectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;
  final PoiCardState? poiCardState;
  final DirectoryObjectMessage data;

  const _FoundingDayPoiCardContent({
    required this.objectId,
    required this.data,
    this.closestPoint,
    this.cameraConfig,
    this.poiCardState,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoundingDayContentState();
}

class _FoundingDayContentState extends ConsumerState<_FoundingDayPoiCardContent> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ValueNotifier<PoiTabsType> _tabType;
  late final PoiCardState? poiCardState = widget.poiCardState;
  PoiCardBottomSheetState? _bottomSheetPreviousState;

  /// See `_ContentState._aiSummaryTriggered` for the rationale.
  bool _aiSummaryTriggered = false;
  AiSummaryNotifier? _aiSummaryNotifier;

  late final MultiStateSheetController<PoiCardBottomSheetState> _bottomSheetController = MultiStateSheetController(
    behavior: MultiSnappingBehavior(
      models: [
        FractionSnappingModel({0.0}),
        OffsetSnappingModel({HeaderComponent.photosMaxHeight - PoiHeader.poiHeaderBorderRadius, Spacing.$4x}),
        ComponentsSnappingModel(
          componentsDescriptions: [
            SnapComponent.merge(
              a: const SnapComponent.size(component: Components.header),
              b: const SnapComponent.size(component: Components.footer),
              merge: (a, b) => a + b,
            ),
          ],
        ),
      ],
    ),
    stateMapper: const PoiCardStateMapper(),
    initialState: PoiCardBottomSheetState.halfOpen,
  );

  @override
  void didUpdateWidget(covariant _FoundingDayPoiCardContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    final _parkingObjectId = widget.objectId == parkingObjectId;
    _tabType.value = _parkingObjectId ? PoiTabsType.parking : PoiTabsType.info;
    _tabController.animateTo(0);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    final _parkingObjectId = widget.objectId == parkingObjectId;
    _tabType = ValueNotifier(_parkingObjectId ? PoiTabsType.parking : PoiTabsType.info);
    _tabController.addListener(() {
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
    });

    // Initialize BssService event
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await BssService.instance.sendEvent(
        const BssRequest(
          eventType: BSSEventType.view,
          uiElement: BssUIElement(name: BssUIElementNames.directoryObjectCardScreen),
        ),
      );
    });

    _bottomSheetController.addListener(() {
      final isInitial = _bottomSheetPreviousState == null;
      final state = _bottomSheetController.state;
      if (state == _bottomSheetPreviousState) {
        return;
      }
      _bottomSheetPreviousState = state;

      // Same rule as `_ContentState`: kick off the AI summary
      // fetch the first time the sheet leaves preview states
      // (hidden / halfOpen). Both `open` and `expanded` show the
      // detail content.
      if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
        _maybeTriggerAiSummary();
      }

      if (!isInitial) {
        BssUIElementNames? uiElementName;
        switch (state) {
          case PoiCardBottomSheetState.hidden:
            uiElementName = BssUIElementNames.placeCardHidden;
          case PoiCardBottomSheetState.open:
            uiElementName = BssUIElementNames.placeCardTwoThird;
          case PoiCardBottomSheetState.expanded:
            uiElementName = BssUIElementNames.placeCardFull;
          case PoiCardBottomSheetState.halfOpen:
            uiElementName = BssUIElementNames.placeCardOneThird;
        }

        BssService.instance.sendEvent(
          BssRequest(
            eventType: BSSEventType.view,
            uiElement: BssUIElement(name: uiElementName, ownerName: BssUIElementNames.directoryObjectCardScreen),
            payload: BssPayload(placeItem: widget.data.toBss()),
          ),
        );
      }
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
    // Mirror `_ContentState.dispose()` — cancel any AI Summary inflight when
    // the founding-day POI card goes away. Deferred via a microtask so the
    // notifier state mutation doesn't race the disposing subtree (see the
    // sibling state for the full rationale).
    final notifier = _aiSummaryNotifier;
    if (_aiSummaryTriggered && notifier != null) {
      Future<void>.microtask(() => notifier.cancel(reason: 'Founding-day POI card closed or switched'));
    }
    _tabController.dispose();
    _tabType.dispose();
    super.dispose();
  }

  /// Mirrors `_ContentState._maybeTriggerAiSummary`.
  void _maybeTriggerAiSummary() {
    if (_aiSummaryTriggered) {
      return;
    }
    final types = widget.data.types.map((t) => t.type);
    if (!isAiSummaryAllowed(types)) {
      _aiSummaryTriggered = true;
      return;
    }
    _aiSummaryTriggered = true;
    final language = ref.read(appLanguageProvider);
    final poiId = widget.objectId.toString();
    final notifier = ref.read(aiSummaryProvider(poiId, language).notifier);
    _aiSummaryNotifier = notifier;
    notifier.load();
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(appLanguageProvider, (previous, next) {
        if (previous == next) {
          return;
        }
        _aiSummaryTriggered = false;
        final currentState = _bottomSheetController.state;
        if (currentState == PoiCardBottomSheetState.open || currentState == PoiCardBottomSheetState.expanded) {
          _maybeTriggerAiSummary();
        }
      })
      ..listen(poiPhotoProvider(widget.objectId), (previous, next) {
        /// has value
        if (next.hasValue == true && next.value?.items.isNotEmpty == true) {
          return;
        }
      });

    final parkingPoi = widget.objectId == parkingObjectId;

    final name = widget.data.buildingInfo.buildingName;
    if (name != null && parkingPoi == false) {
      widget.data.title = name;
    }

    widget.data.about = context.l10n.foundingDaySalwaPalaceAbout;
    widget.data.contactInfos = [
      ContactInfoMessage(type: 'phone', displayText: '+966 11 211 2222', value: '+966112112222'),
    ];

    final poiActions = ref.read(poiCardActionsProvider.notifier);

    final photos = ref.watch(poiPhotoProvider(widget.objectId));
    final isPhotosNotEmpty = (!photos.hasValue || photos.requireValue.items.isEmpty) && !photos.isLoading;

    final finishPoint = RouteSearchPoint(
      coordinates: widget.data.markerPosition!.toGeoPointMessage(),
      dgisObjectId: widget.data.id!,
    );

    final briefInfo = ref.watch(
      briefRouteInfoProvider(finishPoint: finishPoint, navType: RouteSearchOptionsMessage.car),
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
          objectIdForIndoorLevels: poiCardState?.gisObjectIdMessage?.levelId != null ? null : widget.objectId,
        ),
        topHeader: PoiPhotosHeader(objectId: widget.objectId),
        topHeaderOffset: PoiCardStateMapper.topHeaderOffsetDelegate,
        footer: PoiCardFooter(
          closestPoint: widget.closestPoint,
          bottomSheetController: _bottomSheetController,
          data: widget.data,
          share: () {
            Metrics.logEventAdvanced(
              MetricsConstants.poiKeys.share,
              group: MetricsConstants.poiTag,
              action: MetricAction.tap.toString(),
              props: {
                'object_id': widget.data.id?.objectId,
                'closest_point': '${widget.closestPoint?.latitude},${widget.closestPoint?.longitude}',
              },
            );

            return poiActions.share(objectId: widget.objectId, markerCoords: widget.closestPoint);
          },
          callPhone: () {
            Metrics.logEventAdvanced(
              MetricsConstants.poiKeys.call,
              group: MetricsConstants.poiTag,
              action: MetricAction.tap.toString(),
              props: {'objectId': widget.objectId},
            );

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
            _bssOnRouteTap();
            _onDirectionsTap(
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
              ref,
            );
          },
          onAddPointToRoute: () => _onAddObjectPointToRoute(context, context.l10n, ref, widget.data),
          onRemovePointFromRoute: () => _onRemoveObjectPointToRoute(context, context.l10n, ref, widget.data),
          onTapFavorite: (item) {
            _bssOnFavouritesTap();
            _onFavoriteTap(context: context, ref: ref, data: widget.data, favouriteItem: item);
          },
        ),
        header: PoiHeader(
          title: widget.data.address?.buildingName ?? widget.data.title,
          subTitle: _getParkingSubtitle(widget.data.parkingInfo, context.l10n) ?? widget.data.subtitle,
          subTitleExtraInlineSpans: [
            if (poiHeaderSubTitle != null) ...[
              const TextSpan(text: ' • '),
              WidgetSpan(
                child: Icon(General16Icons.car, size: 16, color: context.colors.foregroundSoft),
                baseline: TextBaseline.ideographic,
                alignment: PlaceholderAlignment.middle,
              ),
              TextSpan(text: ' $poiHeaderSubTitle'),
            ],
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: Spacing.$1x),
                child: Icon(
                  (widget.data.parkingInfo?.isPaid ?? false) ? GeneralIcons.money : GeneralIcons.checkmarkCircle,
                  size: 16,
                  color: context.colors.foregroundSoft,
                ),
              ),
              baseline: TextBaseline.ideographic,
              alignment: PlaceholderAlignment.middle,
            ),
          ],
          parkingInfo: widget.data.parkingInfo,
          poiCardState: poiCardState,
          tabController: _tabController,
          data: widget.data,
          onTapClose: () => closePoiCard(context, ref),
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
      BssRequest(
        eventType: BSSEventType.action,
        actionType: BSSActionType.tap,
        uiElement: const BssUIElement(name: BssUIElementNames.buildRoute, ownerName: BssUIElementNames.actionBar),
        payload: BssPayload(placeItem: widget.data.toBss()),
      ),
    );
  }

  void _bssOnCallTap() {
    BssService.instance.sendEvent(
      BssRequest(
        eventType: BSSEventType.action,
        actionType: BSSActionType.tap,
        uiElement: const BssUIElement(name: BssUIElementNames.contact, ownerName: BssUIElementNames.actionBar),
        payload: BssPayload(placeItem: widget.data.toBss()),
      ),
    );
  }

  void _bssOnFavouritesTap() {
    BssService.instance.sendEvent(
      BssRequest(
        eventType: BSSEventType.action,
        actionType: BSSActionType.tap,
        uiElement: const BssUIElement(name: BssUIElementNames.bookmark, ownerName: BssUIElementNames.actionBar),
        payload: BssPayload(placeItem: widget.data.toBss()),
      ),
    );
  }
}
