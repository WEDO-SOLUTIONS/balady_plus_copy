part of 'poi_card_widget_page.dart';

class _CityscapePoiCardContent extends ConsumerStatefulWidget {
  final DirectoryObjectMessage data;
  final int objectId;
  final LatLng? closestPoint;
  final PoiCardState? poiCardState;
  final PoiCameraConfig? cameraConfig;

  const _CityscapePoiCardContent({
    required this.data,
    required this.objectId,
    this.poiCardState,
    this.closestPoint,
    this.cameraConfig,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CityscapeContentState();
}

class _CityscapeContentState extends ConsumerState<_CityscapePoiCardContent>
    with SingleTickerProviderStateMixin {
  late final MultiStateSheetController<PoiCardBottomSheetState>
      _bottomSheetController;

  @override
  void initState() {
    super.initState();

    _bottomSheetController = MultiStateSheetController(
      behavior: MultiSnappingBehavior(
        models: [
          FractionSnappingModel({0.0, .8}),
          OffsetSnappingModel({
            HeaderComponent.photosMaxHeight - PoiHeader.poiHeaderBorderRadius
          }),
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
  }

  @override
  void dispose() {
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final colors = context.colors;

    final about = data.getAbout(context.l10n);

    final cityscapeNotifier = ref.read(cityscapeProvider.notifier);

    Future<void> bssOnContactTap(BssContactType type, String value) async {
      await BssService.instance.sendEvent(
        BssRequest(
          eventType: BSSEventType.action,
          actionType: BSSActionType.tap,
          uiElement: const BssUIElement(
            name: BssUIElementNames.contactTap,
            ownerName: BssUIElementNames.cardInformation,
          ),
          payload: BssPayload(
            placeItem: data.toBss(),
            contact: BssContact(
              type: type,
              value: value,
            ),
          ),
        ),
      );
    }

    final actionsProvider = ref.read(poiCardActionsProvider.notifier);
    final contacts = data.getContacts(
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
          objectIdForIndoorLevels:
              widget.poiCardState?.gisObjectIdMessage?.levelId != null
                  ? null
                  : widget.objectId,
        ),
        topHeaderOffset: PoiCardStateMapper.topHeaderOffsetDelegate,
        footer: PoiCardFooter(
          closestPoint: widget.closestPoint,
          bottomSheetController: _bottomSheetController,
          data: data,
          share: () => ref.read(poiCardActionsProvider.notifier).share(
                objectId: widget.objectId,
                markerCoords: widget.closestPoint,
              ),
          callPhone: () {
            final phoneNumber = data.getContactsInfoModels.firstWhereOrNull(
              (element) => element.type == ContactsInfoType.phone,
            );
            if (phoneNumber?.value != null) {
              ref
                  .read(poiCardActionsProvider.notifier)
                  .callPhone(phoneNumber!.value!);
            }
          },
          onEntranceTap: () {},
          onTapCar: () {},
          onTapFavorite: (item) {},
        ),
        header: PoiHeader(
          title: data.title ?? data.buildingInfo.buildingName ?? '',
          subTitle: data.subtitle,
          parkingInfo: data.parkingInfo,
          poiCardState: widget.poiCardState,
          data: data,
          onTapClose: () {
            ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
            ref.read(parkingManageProvider.notifier).restoreMarker();
            ref.read(highlightProvider.notifier).removeHighlight(data.id!);
            context.router.popForced();
          },
        ),
        sliver: DecoratedSliver(
          decoration: BoxDecoration(
            color: context.colors.backgroundSurface4,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(PoiHeader.poiHeaderBorderRadius),
            ),
          ),
          sliver: SliverFillAfter(
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
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
                                    Text(widget.data.title,
                                        style: context
                                            .textStyles.bodyLargeSemiBold),
                                    const SizedBox(height: Spacing.$1_5x),
                                    Text(
                                      widget.data.subtitle,
                                      style: context.textStyles.bodySmallRegular
                                          .copyWith(
                                              color: colors.foregroundSoft),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Image.asset(
                                cityscapeNotifier.globalImg,
                                width: 48,
                                height: 48,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        PoiContentAboutCard(data: about!),
                        const SizedBox(height: 16),
                        PoiContentContactsCard(
                          data: contacts,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
