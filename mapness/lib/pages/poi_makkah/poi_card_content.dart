part of 'poi_makkah_widget_page.dart';

class _PoiCardContent extends StatefulWidget {
  final DirectoryObjectMessage data;
  final int objectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;
  final PoiCardDataFromGoogle? poiCardDataFromGoogle;
  final List<String> photoUrls;
  final MakkahPlace? makkahPlace;

  const _PoiCardContent({
    required this.data,
    required this.objectId,
    this.closestPoint,
    this.cameraConfig,
    this.poiCardDataFromGoogle,
    this.photoUrls = const [],
    this.makkahPlace,
  });

  @override
  State<_PoiCardContent> createState() => _ContentState();
}

class _ContentState extends State<_PoiCardContent> with SingleTickerProviderStateMixin {
  PoiCardBottomSheetState? _bottomSheetPreviousState;
  late final VoidCallback _bottomSheetListener;
  bool _isClosing = false;

  void _handleCloseTap() {
    if (_isClosing) return;
    _isClosing = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final router = context.router;
      try {
        // Use removeWhere to cleanly remove the Makkah POI route.
        // This matches how the regular POI card handles closing and avoids
        // the sheet state transition issue with maybePop().
        router.removeWhere((route) => route.name == PoiMakkahWidgetRoute.name);
      } catch (e, st) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: e,
            stack: st,
          ),
        );
        if (mounted) {
          setState(() {
            _isClosing = false;
          });
        }
      }
    });
  }

  late final MultiStateSheetController<PoiCardBottomSheetState> _bottomSheetController = MultiStateSheetController(
    behavior: MultiSnappingBehavior(
      models: [
        FractionSnappingModel({0.0}),
        OffsetSnappingModel({
          _makkahPhotosMaxHeight - PoiHeader.poiHeaderBorderRadius,
          Spacing.$4x,
        }),
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

  bool get isGooglePoi => widget.poiCardDataFromGoogle != null;

  @override
  void didUpdateWidget(covariant _PoiCardContent oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    _bottomSheetListener = () {
      if (!mounted) return;
      final isInitial = _bottomSheetPreviousState == null;
      final state = _bottomSheetController.state;
      if (state == _bottomSheetPreviousState) {
        return;
      }
      _bottomSheetPreviousState = state;
      if (!isInitial) {
        // no-op for poi_makkah dummy card
      }
    };
    _bottomSheetController.addListener(_bottomSheetListener);
  }

  @override
  void dispose() {
    _bottomSheetController.removeListener(_bottomSheetListener);
    _bottomSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = isGooglePoi ? widget.poiCardDataFromGoogle?.displayName : widget.data.buildingInfo.buildingName;
    if (name != null) {
      widget.data.title = name;
    }

    return Directionality(
      textDirection: Directionality.of(context),
      child: Consumer(
        builder: (context, ref, _) {
          final mode = ref.watch(specialThemeModeProvider);
          final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
          final colors = _resolveMakkahPoiColors(context, mode, isDark: isDark);

          return MultiStateSheet(
            dragger: null,
            scrollController: _bottomSheetController,
            offsetOutsideWidgetByTopheader: false,
            safeAreaColor: colors.cardBackground,
            backgroundColor: colors.cardBackground,
            barrierColorDelegate: PoiCardStateMapper.barrierColorDelegate,
            outside: PoiCardMapControlsWrapper(
              bottomSheetController: _bottomSheetController,
              objectIdForIndoorLevels: widget.objectId,
            ),
            topHeader: _MakkahPoiPhotosHeaderDummy(
              objectId: widget.objectId,
              photoUrls: widget.photoUrls,
            ),
            topHeaderOffset: PoiCardStateMapper.topHeaderOffsetDelegate,
            footer: _MakkahPoiFooterPlaceholder(
              bottomSheetController: _bottomSheetController,
              data: widget.data,
              closestPoint: widget.closestPoint,
              makkahPlace: widget.makkahPlace,
              colors: colors,
            ),
            header: _MakkahPoiHeader(
              colors: colors,
              title: widget.makkahPlace != null
                  ? MakkahMultilingualHelper.getTitle(
                      widget.makkahPlace!,
                      Directionality.of(context),
                    )
                  : (widget.data.address?.buildingName ??
                        widget.poiCardDataFromGoogle?.displayName ??
                        widget.data.pinTitle(context.l10n)),
              subTitleWidget: _MakkahPoiSubtitle(
                colors: colors,
                data: widget.data,
                makkahPlace: widget.makkahPlace,
              ),
              onTapClose: () {
                _handleCloseTap();
              },
            ),
            sliver: DecoratedSliver(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(PoiHeader.poiHeaderBorderRadius),
                ),
              ),
              sliver: SliverFillAfter(
                sliver: _MakkahPoiInfoSliverPlaceholder(
                  objectId: widget.objectId,
                  colors: colors,
                  aboutText: widget.data.about,
                  makkahPlace: widget.makkahPlace,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
