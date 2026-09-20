part of 'poi_card_widget_page.dart';

class _PoiCardContent extends ConsumerStatefulWidget {
  final DirectoryObjectMessage data;
  final PoiCardState? poiCardState;
  final int objectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;
  final PoiCardDataFromGoogle? poiCardDataFromGoogle;

  const _PoiCardContent({
    required this.data,
    required this.objectId,
    required this.poiCardState,
    this.closestPoint,
    this.cameraConfig,
    this.poiCardDataFromGoogle,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContentState();
}

class _ContentState extends ConsumerState<_PoiCardContent> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ValueNotifier<PoiTabsType> _tabType;
  late final PoiCardState? poiCardState = widget.poiCardState;
  PoiCardBottomSheetState? _bottomSheetPreviousState;
  late final ValueNotifier<PoiCardBottomSheetState> _stateNotifier;

  late final MultiStateSheetController<PoiCardBottomSheetState> _bottomSheetController;
  late final VoidCallback _bottomSheetControllerListener;

  /// Tracks whether the AI Summary fetch has already been kicked
  /// off for this POI. The spec says the request fires exactly
  /// once, on the first collapsed → expanded transition.
  bool _aiSummaryTriggered = false;
  AiSummaryNotifier? _aiSummaryNotifier;

  bool get isGooglePoi => widget.poiCardDataFromGoogle != null;

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

    _stateNotifier = ValueNotifier<PoiCardBottomSheetState>(PoiCardBottomSheetState.halfOpen);

    // Check if photos are available (will be updated in build if needed)
    final photos = ref.read(poiPhotoProvider(widget.objectId));
    final hasPoiPhotos = photos.hasValue && photos.requireValue.items.isNotEmpty;
    final parkingStore = ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme)).value;
    final hasParkingPhotos =
        widget.objectId == parkingObjectId && parkingStore != null && parkingStore.imagesPaths.isNotEmpty;
    final hasPhotos = hasPoiPhotos || hasParkingPhotos;

    final snappingModels = <SnappingModel>[
      FractionSnappingModel({0.0, 1.0}),
      if (hasPhotos) OffsetSnappingModel({HeaderComponent.photosMaxHeight - PoiHeader.poiHeaderBorderRadius}),
      ComponentsSnappingModel(
        componentsDescriptions: [
          SnapComponent.merge(
            a: const SnapComponent.size(component: Components.header),
            b: const SnapComponent.size(component: Components.footer),
            merge: (a, b) => a + b,
          ),
        ],
      ),
    ];

    _bottomSheetController = MultiStateSheetController(
      behavior: MultiSnappingBehavior(models: snappingModels),
      stateMapper: const PoiCardStateMapper(),
      initialState: PoiCardBottomSheetState.halfOpen,
    );

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

    _bottomSheetControllerListener = _handleBottomSheetControllerChanged;
    _bottomSheetController.addListener(_bottomSheetControllerListener);

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
    // Cancel any AI Summary request that's still in flight — the user has
    // either switched to another POI or closed the card and there's nothing
    // left on screen to show the result. `keepAlive: true` on the notifier
    // means its own `onDispose` wouldn't fire here.
    //
    // The cancel mutates notifier state, which makes its listeners rebuild.
    // Doing that synchronously inside `dispose()` trips Flutter framework
    // assertions when listeners are still in the disposing subtree (the
    // POI card's own AiSummarySection). Defer to a microtask so the
    // dispose pipeline finishes first.
    final notifier = _aiSummaryNotifier;
    if (_aiSummaryTriggered && notifier != null) {
      Future<void>.microtask(() => notifier.cancel(reason: 'POI card closed or switched'));
    }
    _tabController.dispose();
    _tabType.dispose();
    _stateNotifier.dispose();
    _bottomSheetController
      ..removeListener(_bottomSheetControllerListener)
      ..dispose();
    super.dispose();
  }

  void _handleBottomSheetControllerChanged() {
    if (!mounted) {
      return;
    }

    final isInitial = _bottomSheetPreviousState == null;
    final state = _bottomSheetController.state;
    if (state == _bottomSheetPreviousState) {
      return;
    }
    _bottomSheetPreviousState = state;
    _stateNotifier.value = state;

    // Kick off the AI summary fetch as soon as the sheet leaves
    // the preview states (hidden / halfOpen) — i.e. when the
    // card is visually "expanded" per the spec. The enum has
    // two such states (open, expanded) because of the snapping
    // ladder; either one shows the detail content, so both
    // should trigger the request. Runs for the initial
    // transition too, covering the deep-link case.
    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      _maybeTriggerAiSummary();
    }

    if (!isInitial) {
      BssUIElementNames? uiElementName;
      switch (state) {
        case PoiCardBottomSheetState.hidden:
          uiElementName = BssUIElementNames.placeCardHidden;
          if (kDebugMode) {
            logger.log('[MakkahPinDebug] Content: sheet hidden, setActive(false)');
          }
          ref.read(regularPoiActiveProvider.notifier).isActive = false;
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
  }

  /// Kick off the AI summary fetch on the first expand for this
  /// POI. Subsequent expand transitions are no-ops. Also handles
  /// the deep-link edge case where the card is opened directly
  /// in the [PoiCardBottomSheetState.expanded] state.
  void _maybeTriggerAiSummary() {
    if (_aiSummaryTriggered) {
      return;
    }
    // Skip both fetch and UI for POIs whose type is outside the allowed
    // scope — same gate as `AiSummarySection`, applied here so the network
    // request never fires for off-scope POIs.
    final types = (poiCardState?.gisObjectIdMessage?.types ?? widget.data.types).map((t) => t.type);
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
    // When the app language changes, the AI summary is keyed by a
    // different family argument (poiId, newLocale) so a fresh
    // notifier instance appears. Reset the trigger flag so that
    // the next expand fires `load()` for the new locale; if the
    // sheet is already expanded, re-trigger immediately.
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
    final l10n = context.l10n;

    final parkingPoi = widget.objectId == parkingObjectId;

    final name = isGooglePoi ? widget.poiCardDataFromGoogle?.displayName : widget.data.buildingInfo.buildingName;
    if (name != null && parkingPoi == false) {
      widget.data.title = name;
    }

    final poiActions = ref.read(poiCardActionsProvider.notifier);

    final photos = ref.watch(poiPhotoProvider(widget.objectId));
    final hasPoiPhotos = photos.hasValue && photos.requireValue.items.isNotEmpty;
    final parkingStore = ref.watch(parkingManageProvider(theme: context.read<ThemeController>().currentTheme)).value;
    final hasParkingPhotos = parkingPoi && parkingStore != null && parkingStore.imagesPaths.isNotEmpty;
    final hasPhotos = hasPoiPhotos || hasParkingPhotos;

    final finishPoint = RouteSearchPoint(
      coordinates: widget.data.markerPosition!.toGeoPointMessage(),
      dgisObjectId: widget.data.id!,
    );

    final briefInfo = ref.watch(
      briefRouteInfoV2Provider(finishPoint: finishPoint, navType: RouteSearchOptionsMessage.car),
    );

    final brief = briefInfo?.firstOrNull;

    String? createPoiHeaderSubTitle() {
      final carParkingLabel = [
        brief?.getBriefRouteDescription(context.l10n),
        brief?.getBriefRouteDistanceDescription(context.l10n),
      ].where((e) => e != null && e.trim().isNotEmpty).join(' ');

      final result = parkingPoi ? carParkingLabel : briefInfo?.firstOrNull?.getBriefRouteDescription(context.l10n);

      logger.log('[PoiCardContent] createPoiHeaderSubTitle result: "$result" for POI: ${widget.data.title}');

      return result;
    }

    final poiHeaderSubTitle = createPoiHeaderSubTitle();

    logger.log(
      '[PoiCardContent] Final poiHeaderSubTitle: "$poiHeaderSubTitle" for POI: ${widget.data.title}, '
      'Will show in subtitle: ${poiHeaderSubTitle != null}',
    );

    return Directionality(
      textDirection: Directionality.of(context),
      child: ValueListenableBuilder<PoiCardBottomSheetState>(
        valueListenable: _stateNotifier,
        builder: (context, state, _) {
          final safeAreaColor = switch (state) {
            PoiCardBottomSheetState.hidden || PoiCardBottomSheetState.halfOpen => context.colors.backgroundSurface2,
            PoiCardBottomSheetState.open || PoiCardBottomSheetState.expanded => context.colors.backgroundSurface1,
          };
          return ValueListenableBuilder<PoiTabsType>(
            valueListenable: _tabType,
            builder: (context, tabType, _) {
              final backgroundColor = tabType == PoiTabsType.photos && !hasPhotos
                  ? context.colors.backgroundSurface2
                  : context.colors.backgroundSurface4;
              return MultiStateSheet(
                dragger: null,
                scrollController: _bottomSheetController,
                offsetOutsideWidgetByTopheader: !hasPhotos,
                safeAreaColor: safeAreaColor,
                backgroundColor: backgroundColor,
                barrierColorDelegate: PoiCardStateMapper.barrierColorDelegate,
                outside: PoiCardMapControlsWrapper(
                  bottomSheetController: _bottomSheetController,
                  // we should not use objectIdForIndoorLevels if POI has levelId
                  objectIdForIndoorLevels: poiCardState?.gisObjectIdMessage?.levelId != null ? null : widget.objectId,
                ),
                topHeader: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: Spacing.$4x),
                      child: const MapAttributionLabel(),
                    ),
                    if (!isGooglePoi)
                      PoiPhotosHeader(
                        objectId: widget.objectId,
                        bottomSheetController: _bottomSheetController,
                      ),
                  ],
                ),
                topHeaderOffset: PoiCardStateMapper.topHeaderOffsetDelegate,
                footer: PoiCardFooter(
                  // Animated to zero, because safeAreaColor can't be animated now
                  duration: const Duration(),
                  curve: Curves.easeInOut,
                  color: safeAreaColor,
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

                    final phoneNumbers = widget.data.getContactsInfoModels
                        .where((e) => e.type == ContactsInfoType.phone && e.value != null)
                        .toList();
                    _bssOnCallTap();
                    if (phoneNumbers.length == 1) {
                      poiActions.callPhone(phoneNumbers.first.value!);
                    } else if (phoneNumbers.length > 1) {
                      _showPhonePickerSheet(phoneNumbers, poiActions.callPhone);
                    }
                  },
                  onEntranceTap: () => poiActions.toggleEntrances(
                    widget.data,
                    () => _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen),
                    widget.closestPoint,
                  ),
                  onTapCar: () {
                    _bssOnRouteTap();
                    // Let route_built report the destination district from the
                    // POI object that is already loaded on this card.
                    BaladyNavigationEvents.rememberRouteDestination(widget.data);
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
                  onAddPointToRoute: () => _onAddObjectPointToRoute(context, l10n, ref, widget.data),
                  onRemovePointFromRoute: () => _onRemoveObjectPointToRoute(context, l10n, ref, widget.data),
                  onTapFavorite: (item) {
                    _bssOnFavouritesTap();
                    _onFavoriteTap(context: context, ref: ref, data: widget.data, favouriteItem: item);
                  },
                ),
                header: PoiHeader(
                  bottomSheetController: _bottomSheetController,
                  title:
                      widget.data.address?.buildingName ??
                      widget.poiCardDataFromGoogle?.displayName ??
                      widget.data.pinTitle(l10n),
                  subTitle:
                      _getParkingSubtitle(widget.data.parkingInfo, context.l10n) ??
                      (widget.objectId == 70030077050725730
                          ? (context.locale.languageCode == 'en' ? 'Settlement' : 'نطاق')
                          : widget.objectId == 70030076677108076
                          ? (context.locale.languageCode == 'en' ? 'Global tech conference' : 'مؤتمر تقني عالمي')
                          : (['تسوية', 'مستوطنة'].contains(widget.data.subtitle) ? 'نطاق' : widget.data.subtitle)),
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
                          (widget.data.parkingInfo?.isPaid ?? false)
                              ? GeneralIcons.money
                              : GeneralIcons.checkmarkCircle,
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
                  data: poiCardState?.gisObjectIdMessage ?? widget.data,
                  onTapClose: () async {
                    await ref.read(highlightProvider.notifier).removeHighlight(widget.data.id!);
                    await closePoiCard(context, ref);
                  },
                ),
                sliver: DecoratedSliver(
                  decoration: BoxDecoration(
                    color: backgroundColor,
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
              );
            },
          );
        },
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

  void _showPhonePickerSheet(List<ContactsInfoModel> phones, void Function(String) onSelect) =>
      showPhonePickerSheet(context, phones, onSelect);

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
