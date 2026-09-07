import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/app_analytics/datafinder_source_tracker.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/landing/landing_state_mapper.dart';
import 'package:mapness/pages/map_search/ui/map_search_bar.dart';
import 'package:mapness/pages/map_search/ui/map_search_content_v2.dart';
import 'package:mapness/pages/map_search/ui/map_search_controls.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/directory_obj_ext.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/search_type_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sheetify/sheetify.dart';

/// Search sheet that is shown on the explore screen.
class MapSearchSheet extends ConsumerStatefulWidget {
  final bool requestFocus;
  final bool withClustering;
  final double biggestHeight;
  final Expansion? expansion;
  final String? initialState;

  const MapSearchSheet({
    required this.withClustering,
    required this.biggestHeight,
    required this.requestFocus,
    this.expansion,
    super.key,
    this.initialState,
  });

  @override
  ConsumerState<MapSearchSheet> createState() => _MapSearchSheetState();
}

class _MapSearchSheetState extends ConsumerState<MapSearchSheet> with WidgetsBindingObserver {
  late final MultiStateSheetController<ThreeStateSheet> _multiStateSheetController;
  double currentSize = 0.1;
  late final StreamSubscription<bool> _keyboardVisible;
  final kbVisibilityController = KeyboardVisibilityController();
  final settings = MapObjectManagerSettings.search();
  StreamSubscription<TapEvent>? _streamSubscription;
  final _scope = SearchScopeEnum.map.value;

  ClusteringMapObjectManager? _clustering;

  Color? _barrierColor;
  bool _showMoreQuickFilters = false;

  final outsideOpacityDelegate = StatefulSheetDelegate.func<double, ThreeStateSheet>((controller) {
    final fraction = controller.fraction;
    const startFade = 0.56;
    const endFade = 1.0;

    final opacity = (1 - ((fraction - startFade) / (endFade - startFade))).clamp(0.0, 1.0);

    return fraction < startFade ? 1.0 : opacity;
  });

  late final barrierColorDelegate = StatefulSheetDelegate.func<Color?, ThreeStateSheet>((controller) {
    final state = controller.state;
    return state.index > 1 ? _barrierColor : null;
  });

  @override
  void initState() {
    super.initState();

    // DataFinder: this is the Explore-tab map search (scope=map). Opening it is
    // an Explore-tab entry control, so reset the journey origin to `explore`
    // (BRD "Explore Tab → Main Page → Search Bar"). This clears any sticky `map`
    // origin left by an earlier map-POI tap. Deferred: can't modify a provider
    // during initState. The Map→POI→Go nav search uses NaviSearch, not this.
    Future(() {
      ref.read(dataFinderSourceTrackerProvider.notifier).stampOrigin(DataFinderOrigin.explore);
    });

    _multiStateSheetController = MultiStateSheetController(
      forceMultiplier: 2,
      initialState: ThreeStateSheet.expanded,
      behavior: MultiSnappingBehavior(
        models: [
          FractionSnappingModel({.56, 1.0}),
          ComponentsSnappingModel(componentsDescriptions: [const SnapComponent.size(component: Components.header)]),
        ],
      ),
      stateMapper: const LandingStateMapper(),
    );
    _keyboardVisible = kbVisibilityController.onChange.listen(_onKeyboardToggle);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _barrierColor = context.colors.screenOverlayDimming40;
    _clustering ??= ClusteringMapObjectManager(
      options: ClusteringMapObjectManagerOptionsMessage(
        logicalPixel: MediaQuery.of(context).devicePixelRatio,
        maxZoom: 16,
      ),
      renderCluster: _renderCluster,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _unfocusSearchField();
    }
  }

  @override
  void dispose() {
    _multiStateSheetController.dispose();
    _keyboardVisible.cancel();
    _streamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final collapsedHeight = 88 + bottomSafeArea;
    final contentColor = context.colors.backgroundSurface1;
    final containerColor = context.colors.backgroundSurface4;

    final searchState = ref.watch(searchProvider(_scope));
    final searcher = ref.watch(searchProvider(_scope).notifier);
    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
        // If we add `_clustering` we use `MapObjectManager.withClustering` which draws points above marker pin
        // and in all cases is above all other markers that has been created by ` MapObjectManager.withGeneralization`
        // So we need to use `MapObjectManager.withGeneralization` to draw points below marker pin
        // Also we don't know do we need clusterization now, so we fix the problem of drawing points above marker pin just by not using clustering
        //
        // TODO: [Product question] Do we need clusterization or generalization?
        // TODO: [Development] Why clusterization draws points above marker pin even if we pass `layerId`?
        clustering: widget.withClustering ? _clustering : null,
      ).notifier,
    );
    ref
      ..listen(searchProvider(_scope), (previous, next) {
        if (!mounted) {
          return;
        }
        if (_showMoreQuickFilters && next is! SearchStateHistory) {
          setState(() {
            _showMoreQuickFilters = false;
          });
        }
        _drawSearchMarkers(next, previous, searchObjectManager);
      })
      ..listen<SearchState>(
        searchProvider(_scope),
        (previous, next) {
          if (next is SearchStateLoading) {
            _multiStateSheetController.setState(ThreeStateSheet.open);
          }
        },
      );
    final isCloseButton = ref.watch(
      searchProvider(
        _scope,
      ).select((state) => state is SearchStateResults || state is SearchStateEmpty || state is SearchStateLoading),
    );

    return SearchScope(
      named: SearchScopeEnum.map,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              _unfocusSearchField();
              _collapseBottomSheet();
            },
          ),
          NotificationListener<ScrollNotification>(
            onNotification: _onNotification,
            child: MultiStateSheet<ThreeStateSheet>(
              scrollController: _multiStateSheetController,
              // Sheet is already wrapped in a fade route transition (see SearchRoute
              // in app_routes.dart), so suppress sheetify's own slide-up open animation.
              // Otherwise the sheet would slide ~700–900 ms from the bottom on top of
              // the route fade, dominating perceived latency.
              animateOpening: false,
              keepContentBehindFooter: true,
              backgroundColor: containerColor,
              safeAreaColor: _showMoreQuickFilters
                  ? switch (searchState) {
                      SearchStateEmpty() ||
                      SearchStateLoading() ||
                      SearchStateResults() ||
                      SearchStateError() => containerColor,
                      SearchStateHistory() || SearchStateSuggest() => contentColor,
                    }
                  : containerColor,
              dragger: SheetDragger(
                backgroundColor: switch (searchState) {
                  SearchStateEmpty() ||
                  SearchStateLoading() ||
                  SearchStateResults() ||
                  SearchStateError() => containerColor,
                  SearchStateHistory() || SearchStateSuggest() => contentColor,
                },
              ),
              outsideOpacityDelegate: outsideOpacityDelegate,
              barrierColorDelegate: barrierColorDelegate,
              header: switch (searchState) {
                SearchStateEmpty() || SearchStateLoading() || SearchStateResults() || SearchStateError() => Container(
                  color: containerColor,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          searchState.searchText,
                          style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppButton(
                        buttonColorScheme: ButtonColorScheme.neutral,
                        buttonType: ButtonType.secondary,
                        primaryIcon: SystemIcons.close,
                        onTap: () => _onBackPressed(searcher),
                        padding: const EdgeInsets.all(0),
                        innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                      ),
                    ],
                  ),
                ),
                SearchStateHistory() || SearchStateSuggest() => Container(
                  color: contentColor,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: Spacing.$4x),
                  child: MapSearchBar(
                    initialState: widget.initialState,
                    requestFocus: widget.requestFocus,
                    onClose: onClose,
                    isCloseButton: isCloseButton,
                    showLeadingBackButton: _showMoreQuickFilters,
                    onLeadingBackPressed: () => _setShowMoreQuickFilters(false),
                    onTap: _expandSheet,
                  ),
                ),
              },
              outside: ListenableBuilder(
                listenable: _multiStateSheetController,
                builder: (context, _) => MapSearchSheetControls(
                  onClose: onClose,
                  currentSize: currentSize,
                  collapsedSize: collapsedHeight,
                  sheetState: _multiStateSheetController.state,
                ),
              ),
              sliver: SliverToBoxAdapter(
                child: MapSearchContent(
                  bottomSheetContentScrollController: _multiStateSheetController,
                  showMoreQuickFilters: _showMoreQuickFilters,
                  onMoreQuickFiltersChanged: _setShowMoreQuickFilters,
                ),
              ),
            ),
          ),
          //TODO: check why ?
          if (MediaQuery.paddingOf(context).bottom > 0)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.paddingOf(context).bottom,
                child: ColoredBox(color: containerColor),
              ),
            ),
        ],
      ),
    );
  }

  void _onBackPressed(Search searcher) {
    FocusScope.of(context).unfocus();
    searcher.clear();
    onClose();
  }

  Future<void> _drawSearchMarkers(
    SearchState searchState,
    SearchState? prevState,
    MapObjectManager mapObjectManager,
  ) async {
    if (searchState is SearchStateResults &&
        (prevState is! SearchStateResults || prevState.results != searchState.results)) {
      final mapMarkerMapper = ref.read(rubricMarkerMapperProvider.notifier);

      final isRtl = ref.read(appLanguageProvider) == Language.arabic;
      final dark = await ref.watch(darkModeProvider.future);
      final activeCityEvent = ref.read(activeCityEventProvider);

      final markers = await searchState.results.getMarkers(
        router: ref.read(appRouterProvider),
        iconResolver: mapMarkerMapper.getMarkerType,
        advancedIconResolver: mapMarkerMapper.getMarkerPath,
        activeCityEvent: activeCityEvent,
        isRtl: isRtl,
        isDark: dark.isDark,
        onTapAnalytic: (markerInfo, index) async {
          await BssService.instance.sendEvent(
            BssRequest(
              eventType: BSSEventType.action,
              actionType: BSSActionType.tap,
              uiElement: const BssUIElement(
                name: BssUIElementNames.mapMarker,
                ownerName: BssUIElementNames.searchResultList,
              ),
              payload: BssPayload(
                mapMarker: const BssMapMarker(scale: BssMarkerSize.small, adsHighlight: false),
                searchResultList: searchState.results.toBss(),
                placeItem: markerInfo?.toBss(index),
              ),
            ),
          );
        },
      );
      if (!ref.read(searchInRectProvider(_scope)).isSearchInThisAreaRequest) {
        ref.read(searchInRectProvider(_scope).notifier).searchInThisAreaSwitch(value: false);
        await mapObjectManager.removeAllMarkers();
      }
      await mapObjectManager.addMarkers(markers);
    } else if (searchState is SearchStateEmpty || searchState is SearchStateHistory && searchState.searchText.isEmpty) {
      await mapObjectManager.removeAllMarkers();
    }
  }

  SimpleClusterOptionsMessage _renderCluster(int objectCount) => SimpleClusterOptionsMessage(
    icon: switch (context.read<ThemeController>().currentTheme) {
      BaladyAppThemes.dark => Assets.icons.svg.placesNew.dark.icNewPin.keyName.markerIcon(),
      BaladyAppThemes.saudiDay => Assets.icons.svg.icMarkerMNewSaudiDay.keyName.markerIcon(),
      BaladyAppThemes.foundationDay => Assets.icons.svg.placesNewFoundingDay.icDefault.keyName.markerIcon(),
      _ => Assets.icons.svg.placesNew.light.icNewPin.keyName.markerIcon(),
    },
    text: '$objectCount',
    textStyle: MarkerTextStyleMessage(
      textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.centerCenter),
    ),
  );

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      // BSA-1103
      // We need to check if the user is dragging the sheet
      // If not we don't need to unfocus the search field
      //
      // This check is necessary because the [ScrollStartNotification] is called even on the scroll of the TextField
      // when the user is typing a long text and the TextField is scrolling to show it
      if (notification.dragDetails != null) {
        _unfocusSearchField();
        MapSearchContent.scrollSendEvent(
          searchState: ref.read(searchProvider(_scope)),
          historyListSize: ref.read(searchHistoryProvider(_scope)).length,
          sendEvent: BssService.instance.sendEvent,
        );
      }
    }
    return true;
  }

  void _unfocusSearchField() {
    if (kbVisibilityController.isVisible) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void _onKeyboardToggle(bool kbState) {
    if (!kbState || _multiStateSheetController.state == ThreeStateSheet.expanded) {
      return;
    }
    _expandSheet();
  }

  /// Snaps the sheet to `expanded`. Wired both to the field tap (synchronous,
  /// reliable on Android — BALADY-3580) and to the keyboard visibility signal
  /// (fallback for programmatic focus requests, e.g. after Loading → Results).
  /// Idempotent: a no-op if the sheet is already at expanded.
  ///
  /// The sheet mutation is deferred to a post-frame callback: tapping the field
  /// opens the keyboard, which drives the sheet snap animation. Mutating the
  /// sheet controller synchronously (from `onTap` / keyboard-visibility) lands
  /// inside the same frame's layout + semantics pass and reparents the sheet's
  /// slivers while semantics are being flushed, tripping the framework
  /// `!semantics.parentDataDirty` assertion (Flutter 3.38). Deferring runs the
  /// state change on a clean frame boundary.
  void _expandSheet() {
    if (!mounted || _multiStateSheetController.state == ThreeStateSheet.expanded) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _multiStateSheetController.state == ThreeStateSheet.expanded) {
        return;
      }
      _multiStateSheetController.setState(ThreeStateSheet.expanded);
    });
  }

  void onClose() {
    _removeAllMarkersAndPop();
  }

  void _removeAllMarkersAndPop() {
    ref
        .read(
          mapObjectManagerProvider(
            named: settings.name,
            layerId: settings.layerId,
            clustering: widget.withClustering ? _clustering : null,
          ).notifier,
        )
        .removeAllMarkers();
    ref.read(searchInRectProvider(_scope).notifier).update();
    context.router.pop();
  }

  void _collapseBottomSheet() {
    _multiStateSheetController.setState(ThreeStateSheet.hidden);
  }

  void _setShowMoreQuickFilters(bool value) {
    if (!mounted || _showMoreQuickFilters == value) {
      return;
    }
    setState(() => _showMoreQuickFilters = value);
  }
}
