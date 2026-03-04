import 'dart:async';
import 'dart:math';

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
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/landing/landing_state_mapper.dart';
import 'package:mapness/pages/map_search/ui/map_search_bar.dart';
import 'package:mapness/pages/map_search/ui/map_search_content_v2.dart';
import 'package:mapness/pages/map_search/ui/map_search_controls.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
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

  const MapSearchSheet({
    required this.withClustering,
    required this.biggestHeight,
    required this.requestFocus,
    this.expansion,
    super.key,
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

  ThreeStateSheet _sheetState = ThreeStateSheet.expanded;
  Color? _barrierColor;

  final outsideOpacityDelegate = StatefulSheetDelegate.func<double, ThreeStateSheet>((controller) {
    final fraction = controller.fraction;
    final state = controller.state;

    return state.index < 1 ? 1.0 : max(0.0, 1 - (fraction - 0.4) * 9);
  });

  late final barrierColorDelegate = StatefulSheetDelegate.func<Color?, ThreeStateSheet>((controller) {
    final state = controller.state;
    return state.index > 1 ? _barrierColor : null;
  });

  @override
  void initState() {
    super.initState();

    _multiStateSheetController = MultiStateSheetController(
      initialState: ThreeStateSheet.expanded,
      behavior: MultiSnappingBehavior(
        models: [
          FractionSnappingModel({.8, 1.0}),
          ComponentsSnappingModel(componentsDescriptions: [const SnapComponent.size(component: Components.header)]),
        ],
      ),
      stateMapper: const LandingStateMapper(),
    );
    _multiStateSheetController.addListener(_onSheetChanged);
    _keyboardVisible = kbVisibilityController.onChange.listen(_onKeyboardToggle);
    WidgetsBinding.instance.addObserver(this);
  }

  void _onSheetChanged() {
    final newState = _multiStateSheetController.state;
    if (newState != _sheetState) {
      setState(() {
        _sheetState = newState;
      });
    }
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
    _multiStateSheetController
      ..removeListener(_onSheetChanged)
      ..dispose();
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
    ref.listen(searchProvider(_scope), (previous, next) {
      _drawSearchMarkers(next, previous, searchObjectManager);
    });
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
              keepContentBehindFooter: true,
              backgroundColor: containerColor,
              safeAreaColor: _sheetState == ThreeStateSheet.hidden ? contentColor : containerColor,
              dragger: SheetDragger(backgroundColor: contentColor),
              outsideOpacityDelegate: outsideOpacityDelegate,
              barrierColorDelegate: barrierColorDelegate,
              header: Container(
                color: contentColor,
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: Spacing.$4x),
                child: MapSearchBar(requestFocus: widget.requestFocus, onClose: onClose, isCloseButton: isCloseButton),
              ),
              outside: MapSearchSheetControls(currentSize: currentSize, collapsedSize: collapsedHeight),
              sliver: SliverToBoxAdapter(
                child: MapSearchContent(bottomSheetContentScrollController: _multiStateSheetController),
              ),
            ),
          ),
        ],
      ),
    );
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
      BaladyAppThemes.light => Assets.icons.svg.placesNew.light.icNewPin.keyName.markerIcon(),
      BaladyAppThemes.saudiDay => Assets.icons.svg.icMarkerMNewSaudiDay.keyName.markerIcon(),
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

    _multiStateSheetController.setState(ThreeStateSheet.expanded);
  }

  void onClose() {
    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.exitIcon,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
    );
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
}
