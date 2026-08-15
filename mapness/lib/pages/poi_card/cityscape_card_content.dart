part of 'poi_card_widget_page.dart';

class _CityscapePoiCardContent extends ConsumerStatefulWidget {
  final int objectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;
  final PoiCardState? poiCardState;

  const _CityscapePoiCardContent({required this.objectId, this.closestPoint, this.cameraConfig, this.poiCardState});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CityscapeContentState();
}

class _CityscapeContentState extends ConsumerState<_CityscapePoiCardContent> with SingleTickerProviderStateMixin {
  late final MultiStateSheetController<PoiCardBottomSheetState> _bottomSheetController;

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

    final customCityscapeData = DirectoryObjectMessage(
      types: [],
      title: l10n.cityscape_title,
      titleAddition: l10n.cityscape_subtitle,
      subtitle: l10n.commercialBuilding,
      about: l10n.cityscape_about,
      id: DgisObjectIdMessage(objectId: widget.objectId, entranceId: 0),
      markerPosition: GeoPointWithElevationMessage(
        latitude: widget.closestPoint?.latitude ?? 24.7136,
        longitude: widget.closestPoint?.longitude ?? 46.6753,
        elevation: 0,
      ),
      attributes: [],
      contextAttributes: [],
      contactInfos: [ContactInfoMessage(type: 'phone', displayText: '+966 11 211 2222', value: '+966112112222')],
      entrances: [],
      buildingInfo: BuildingInfoMessage(
        buildingName: l10n.cityscape_title,
        purposeName: l10n.cityscape_title,
        purposeCode: 501,
      ),
      rubricIds: [],
      group: [],
      routeInfos: [],
      platformIds: [],
    );

    final poiActions = ref.read(poiCardActionsProvider.notifier);
    final poiCardState = widget.poiCardState?.copyWith(gisObjectIdMessage: customCityscapeData);
    final colors = context.colors;
    final cityscapeNotifier = ref.read(cityscapeProvider.notifier);

    Future<void> bssOnContactTap(BssContactType type, String value) async {
      await BssService.instance.sendEvent(
        BssRequest(
          eventType: BSSEventType.action,
          actionType: BSSActionType.tap,
          uiElement: const BssUIElement(name: BssUIElementNames.contact, ownerName: BssUIElementNames.cardInformation),
          payload: BssPayload(
            placeItem: customCityscapeData.toBss(),
            contact: BssContact(type: type, value: value),
          ),
        ),
      );
    }

    void _bssOnFavouritesTap() {
      BssService.instance.sendEvent(
        BssRequest(
          eventType: BSSEventType.action,
          actionType: BSSActionType.tap,
          uiElement: const BssUIElement(name: BssUIElementNames.bookmark, ownerName: BssUIElementNames.actionBar),
          payload: BssPayload(placeItem: customCityscapeData.toBss()),
        ),
      );
    }

    final actionsProvider = ref.read(poiCardActionsProvider.notifier);
    final contacts = customCityscapeData.getContacts(
      (value) {
        bssOnContactTap(BssContactType.phone, value);
        actionsProvider.callPhone(value);
      },
      (value) {
        bssOnContactTap(BssContactType.email, value);
        actionsProvider.sendEmail(value);
      },
      (value) {
        bssOnContactTap(BssContactType.website, value);
        actionsProvider.launch(value);
      },
      context.l10n,
    );

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
          objectIdForIndoorLevels: poiCardState?.gisObjectIdMessage?.levelId != null ? null : widget.objectId,
        ),
        topHeaderOffset: PoiCardStateMapper.topHeaderOffsetDelegate,
        footer: PoiCardFooter(
          closestPoint: widget.closestPoint,
          bottomSheetController: _bottomSheetController,
          data: customCityscapeData,
          share: () => ref
              .read(poiCardActionsProvider.notifier)
              .share(objectId: widget.objectId, markerCoords: widget.closestPoint),
          callPhone: () {
            final phoneNumber = customCityscapeData.getContactsInfoModels.firstWhereOrNull(
              (element) => element.type == ContactsInfoType.phone,
            );
            if (phoneNumber?.value != null) {
              ref.read(poiCardActionsProvider.notifier).callPhone(phoneNumber!.value!);
            }
          },
          onEntranceTap: () => poiActions.toggleEntrances(
            customCityscapeData,
            () => _bottomSheetController.setState(PoiCardBottomSheetState.halfOpen),
            widget.closestPoint,
          ),
          onTapCar: () {
            final closestPoint = widget.closestPoint;
            if (closestPoint == null) {
              return;
            }

            _onDirectionsTap(
              context,
              widget.objectId,
              '',
              RouteParamsPoint(
                latitude: closestPoint.latitude,
                longitude: closestPoint.longitude,
                objectId: widget.objectId,
              ),
              ref,
            );
          },
          onAddPointToRoute: () => _onAddEmptyPointToRoute(context, l10n, ref, widget.objectId, widget.closestPoint),
          onRemovePointFromRoute: () =>
              _onRemoveEmptyPointToRoute(context, l10n, ref, widget.objectId, widget.closestPoint),
          onTapFavorite: () {
            _bssOnFavouritesTap();
            _onFavoriteTap(context: context, ref: ref, data: customCityscapeData);
          },
        ),
        header: PoiHeader(
          bottomSheetController: _bottomSheetController,
          title: ref.watch(customPlaceNicknameProvider(widget.objectId.toString())).value ?? customCityscapeData.title,
          subTitle: customCityscapeData.subtitle,
          parkingInfo: customCityscapeData.parkingInfo,
          poiCardState: poiCardState,
          data: customCityscapeData,
          onTapClose: () {
            closePoiCard(context, ref);
          },
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(customCityscapeData.title, style: context.textStyles.bodyLargeSemiBold),
                                  const SizedBox(height: Spacing.$1_5x),
                                  Text(
                                    customCityscapeData.titleAddition,
                                    style: context.textStyles.bodySmallRegular.copyWith(color: colors.foregroundSoft),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Image.asset(cityscapeNotifier.globalImg, width: 48, height: 48),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      PoiContentAboutCard(data: customCityscapeData.getAbout(context.l10n)!),
                      const SizedBox(height: 16),
                      PoiContentContactsCard(data: contacts),
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
