part of 'poi_card_widget_page.dart';

class _WrcCardContent extends ConsumerStatefulWidget {
  final WRCEventPoint wrcEventPoint;
  final PoiCardState? poiCardState;

  const _WrcCardContent({required this.wrcEventPoint, this.poiCardState});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WrcCardContentState();
}

class _WrcCardContentState extends ConsumerState<_WrcCardContent> with SingleTickerProviderStateMixin {
  late final MultiStateSheetController<PoiCardBottomSheetState> _bottomSheetController;

  int get _objectId => widget.wrcEventPoint.objectId;

  GeoPointMessage get _pointCenter => widget.wrcEventPoint.center;

  LatLng get _closestPoints => LatLng(latitude: _pointCenter.latitude, longitude: _pointCenter.longitude);

  @override
  void initState() {
    super.initState();
    _bottomSheetController = MultiStateSheetController(
      behavior: MultiSnappingBehavior(
        models: [
          FractionSnappingModel({0.0, .8}),
          OffsetSnappingModel({HeaderComponent.photosMaxHeight - PoiHeader.poiHeaderBorderRadius}),
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
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final wrcDirectoryObject = widget.wrcEventPoint.mergeDirectoryObjectMessage(
      l10n,
      widget.poiCardState?.gisObjectIdMessage,
    );

    final poiActions = ref.read(poiCardActionsProvider.notifier);
    final poiCardState = widget.poiCardState?.copyWith(gisObjectIdMessage: wrcDirectoryObject);
    final colors = context.colors;

    void _bssOnFavouritesTap() {
      BssService.instance.sendEvent(
        BssRequest(
          eventType: BSSEventType.action,
          actionType: BSSActionType.tap,
          uiElement: const BssUIElement(name: BssUIElementNames.bookmark, ownerName: BssUIElementNames.actionBar),
          payload: BssPayload(placeItem: wrcDirectoryObject.toBss()),
        ),
      );
    }

    final parkingPoi = widget.wrcEventPoint.objectId == parkingObjectId;

    final finishPoint = RouteSearchPoint(
      coordinates: widget.wrcEventPoint.center,
      dgisObjectId: DgisObjectIdMessage(objectId: widget.wrcEventPoint.objectId, entranceId: 0),
    );

    // Get user's current location to use as startPoint for route calculation
    final userLocation = ref.watch(locationProvider);
    RouteSearchPoint? startPoint;
    if (userLocation != null) {
      startPoint = RouteSearchPoint(
        coordinates: GeoPointMessage(latitude: userLocation.latitude, longitude: userLocation.longitude),
        dgisObjectId: DgisObjectIdMessage(objectId: 0, entranceId: 0),
      );
    }

    final briefInfo = ref.watch(
      briefRouteInfoProvider(finishPoint: finishPoint, navType: RouteSearchOptionsMessage.car, startPoint: startPoint),
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
    final address = wrcDirectoryObject.makeFullAddress();

    return Directionality(
      textDirection: Directionality.of(context),
      child: MultiStateSheet(
        dragger: null,
        scrollController: _bottomSheetController,
        offsetOutsideWidgetByTopheader: false,
        safeAreaColor: colors.backgroundSurface2,
        backgroundColor: colors.backgroundSurface2,
        barrierColorDelegate: PoiCardStateMapper.barrierColorDelegate,
        outside: PoiCardMapControlsWrapper(
          bottomSheetController: _bottomSheetController,
          objectIdForIndoorLevels: poiCardState?.gisObjectIdMessage?.levelId != null ? null : _objectId,
        ),
        topHeaderOffset: PoiCardStateMapper.topHeaderOffsetDelegate,
        footer: PoiCardFooter(
          closestPoint: _closestPoints,
          bottomSheetController: _bottomSheetController,
          data: wrcDirectoryObject,
          share: () =>
              ref.read(poiCardActionsProvider.notifier).share(objectId: _objectId, markerCoords: _closestPoints),
          callPhone: () {
            final phoneNumber = wrcDirectoryObject.getContactsInfoModels.firstWhereOrNull(
              (element) => element.type == ContactsInfoType.phone,
            );
            if (phoneNumber?.value != null) {
              ref.read(poiCardActionsProvider.notifier).callPhone(phoneNumber!.value!);
            }
          },
          onEntranceTap: () => poiActions.toggleEntrances(
            wrcDirectoryObject,
            () => _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen),
            _closestPoints,
          ),
          onTapCar: () {
            _onDirectionsTap(
              context,
              _objectId,
              wrcDirectoryObject.title,
              RouteParamsPoint(latitude: _pointCenter.latitude, longitude: _pointCenter.longitude, objectId: _objectId),
              ref,
            );
          },
          onAddPointToRoute: () => _onAddEmptyPointToRoute(context, l10n, ref, _objectId, _closestPoints),
          onRemovePointFromRoute: () => _onRemoveEmptyPointToRoute(context, l10n, ref, _objectId, _closestPoints),
          onTapFavorite: () {
            _bssOnFavouritesTap();
            _onFavoriteTap(context: context, ref: ref, data: wrcDirectoryObject);
          },
        ),
        header: PoiHeader(
          bottomSheetController: _bottomSheetController,
          title: ref.watch(customPlaceNicknameProvider(_objectId.toString())).value ?? wrcDirectoryObject.title,
          subTitle: wrcDirectoryObject.subtitle,
          parkingInfo: wrcDirectoryObject.parkingInfo,
          poiCardState: poiCardState,
          data: wrcDirectoryObject,
          onTapClose: () => closePoiCard(context, ref),
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
          ],
        ),
        sliver: DecoratedSliver(
          decoration: BoxDecoration(
            color: context.colors.backgroundSurface4,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(PoiHeader.poiHeaderBorderRadius)),
          ),
          sliver: SliverFillAfter(
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: colors.backgroundSurface1,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(wrcDirectoryObject.title, style: context.textStyles.bodyLargeSemiBold),
                            Text(
                              address,
                              style: context.textStyles.bodySmallRegular.copyWith(color: colors.foregroundSoft),
                            ),
                            const SizedBox(height: Spacing.$1_5x),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      PoiContentAboutCard(data: wrcDirectoryObject.getAbout(l10n)!, isExpandable: false),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
