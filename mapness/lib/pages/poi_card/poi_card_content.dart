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
  late final DirectoryObjectMessage data = widget.data;
  late final int objectId = widget.objectId;
  late final PoiCardState? poiCardState = widget.poiCardState;

  late final StatefulBottomSheetController<PoiCardBottomSheetState> _bottomSheetController =
      StatefulBottomSheetController(
    behavior: MultiSnappingBehavior(
      models: [
        AspectRatioSnappingModel({0.0, 1.0}),
        OffsetSnappingModel({photosMaxHeight + Spacing.$2x}),
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

    _tabController.animateTo(0);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    final _parkingObjectId = objectId == parkingObjectId;
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

    final name = data.buildingInfo.buildingName;
    if (name != null) {
      data.title = name;
    }

    final poiActions = ref.read(poiCardActionsProvider.notifier);

    final photos = ref.watch(poiPhotoProvider(objectId));
    final isPhotosNotEmpty = (!photos.hasValue || photos.requireValue.items.isEmpty) && !photos.isLoading;

    final finishPoint = RouteSearchPoint(
      coordinates: data.markerPosition!.toGeoPointMessage(),
      dgisObjectId: data.id!,
    );

    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    final brief = briefInfo?.firstOrNull;

    String? createPoiHeaderSubTitle() {
      final parkingPoi = objectId == parkingObjectId;

      final carParkingLabel = [
        brief?.getBriefRouteDescription(context.l10n),
        brief?.getBriefRouteDistanceDescription(context.l10n),
      ].where((e) => e != null && e.trim().isNotEmpty).join(' ');

      return parkingPoi ? carParkingLabel : briefInfo?.firstOrNull?.getBriefRouteDescription(context.l10n);
    }

    final poiHeaderSubTitle = createPoiHeaderSubTitle();

    return Directionality(
      textDirection: Directionality.of(context),
      child: SafeArea(
        child: StatefulBottomSheet(
          scrollController: _bottomSheetController,
          offsetOutsideWidgetByTopheader: !isPhotosNotEmpty,
          safeAreaColor: context.colorsV2.backgroundSurface2,
          draggerColor: context.colorsV2.backgroundSurface2,
          backgroundColor: context.colorsV2.backgroundSurface2,
          backgroundColorDelegate: PoiCardStateMapper.backgroundColorDelegate,
          outside: PoiCardMapControlsWrapper(
              bottomSheetController: _bottomSheetController,
              // we should not use objectIdForIndoorLevels if POI has levelId
              objectIdForIndoorLevels: poiCardState?.gisObjectIdMessage?.levelId != null ? null : objectId),
          topHeader: PoiPhotosHeader(objectId: objectId),
          footer: PoiCardFooter(
            bottomSheetController: _bottomSheetController,
            data: data,
            share: () {
              Metrics.logEventAdvanced(MetricsConstants.poiKeys.share,
                  group: MetricsConstants.poiTag,
                  action: MetricAction.tap.toString(),
                  props: {
                    'object_id': data.id?.objectId,
                    'closest_point': '${widget.closestPoint?.latitude},${widget.closestPoint?.longitude}'
                  });

              return poiActions.share(
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
                data.id!.objectId,
                data.title,
                RouteParamsPoint(
                  latitude: data.markerPosition!.latitude,
                  longitude: data.markerPosition!.longitude,
                  objectId: data.id?.objectId,
                  entranceId: data.id?.entranceId,
                  levelId: data.levelId,
                ),
              );
            },
            onTapFavorite: (item) => _onFavoriteTap(context: context, ref: ref, data: data, favouriteItem: item),
          ),
          header: PoiHeader(
            title: data.address?.buildingName ?? data.title,
            subTitle: _getParkingSubtitle(data.parkingInfo, context.l10n) ?? data.subtitle,
            subTitleExtraInlineSpans: (poiHeaderSubTitle != null)
                ? [
                    const TextSpan(text: ' • '),
                    WidgetSpan(
                      child: Icon(General16Icons.car, size: 16, color: context.colorsV3.foregroundSoft),
                      baseline: TextBaseline.ideographic,
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(text: ' $poiHeaderSubTitle'),
                  ]
                : [],
            parkingInfo: data.parkingInfo,
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
              ref.read(parkingManageProvider.notifier).restoreMarker();
              ref.read(highlightProvider.notifier).removeHighlight(data.id!);
              context.router.popForced();
            },
          ),
          sliverBeforeContent: ValueListenableBuilder(
            valueListenable: _tabType,
            builder: (context, tabType, _) => DecoratedSliver(
              decoration: BoxDecoration(
                color: context.colorsV2.backgroundSurface4,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(RadiusBorder.xxl)),
              ),
              sliver: SliverFillAfter(
                sliver: SliverAnimatedSwitcher(
                  duration: Durations.medium2,
                  child: switch (tabType) {
                    PoiTabsType.info => SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const SizedBox(height: Spacing.$4x),
                            FeedbackBannerCard(
                              path: Assets.images.cityExpert.keyName,
                              title: context.l10n.cityExpert,
                              subtitle: context.l10n.cityExpertDescription,
                              gradientColors: const [Color(0xFF3AB7AE), Color(0xFF238A82)],
                              onTap: () {
                                context.router.push(QuickFeedbackRoute(
                                  type: QuickFeedbackType.editCompany,
                                  params: FeedbackObjectIdParams(objectId),
                                ));
                              },
                            ),
                            InfoWidget(
                              objectInfo: poiCardState?.gisObjectIdMessage,
                              qrTradeLicense: poiCardState?.qrTradeLicense,
                              onEntrancesTap: () => poiActions.toggleEntrances(
                                data,
                                () => _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen),
                                widget.closestPoint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    PoiTabsType.photos => PoiPhotoCardSliver(objectId: data.id?.objectId ?? 0),
                    PoiTabsType.organizations => PoiOrganizationsSliver(
                        state: poiCardState,
                        objectId: data.id!,
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
}
