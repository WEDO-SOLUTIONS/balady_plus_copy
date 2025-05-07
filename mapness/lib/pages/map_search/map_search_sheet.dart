import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit hide Stories;
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
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
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

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
  late final DgisBottomSheetController _dgisSheetController;
  late final StatefulBottomSheetController<uikit.ThreeStateBottomSheet> _statefulBottomSheetController;
  late final ScrollController _searchResultsScrollController;
  double currentSize = 0.1;
  late final StreamSubscription<bool> _keyboardVisible;
  final kbVisibilityController = KeyboardVisibilityController();
  final settings = MapObjectManagerSettings.search();
  StreamSubscription<TapEvent>? _streamSubscription;

  ClusteringMapObjectManager? _clustering;

  final _initialExpansion = Expansion.middle;

  @override
  void initState() {
    super.initState();
    _dgisSheetController = DgisBottomSheetController();
    _searchResultsScrollController = ScrollController();
    _statefulBottomSheetController = StatefulBottomSheetController(
      initialState: ThreeStateBottomSheet.expanded,
      behavior: AspectRatioSnappingBehavior(aspectRatios: {0.0, if (Platform.isIOS) .3 else .38, .931}),
      stateMapper: const LandingStateMapper(),
    );
    _keyboardVisible = kbVisibilityController.onChange.listen(_onKeyboardToggle);
    _setupTapListener();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    _keyboardVisible.cancel();
    _dgisSheetController.dispose();
    _streamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final collapsedHeight = 88 + bottomSafeArea;

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
    ref.listen(
      searchProvider(SearchScopeEnum.map.value),
      (previous, next) {
        _drawSearchMarkers(next, previous, searchObjectManager);
      },
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
          // MapSearchSheetControls(currentSize: currentSize, collapsedSize: collapsedHeight),
          NotificationListener<ScrollNotification>(
            onNotification: _onNotification,
            child: uikit.StatefulBottomSheet<uikit.ThreeStateBottomSheet>(
                animateOpening: false,
                keepContentBehindFooter: true,
                scrollController: _statefulBottomSheetController,
                topHeaderOffset: 0.0,
                header: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      // const SizedBox(height: Spacing.$1_5x),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                        child: MapSearchBar(
                          requestFocus: widget.requestFocus,
                          onClose: onClose,
                        ),
                      ),
                      const SizedBox(height: Spacing.$4x),
                    ],
                  ),
                ),
                outside: MapSearchSheetControls(currentSize: currentSize, collapsedSize: collapsedHeight),
                content: [
                  MapSearchContent(
                    scrollController: _searchResultsScrollController,
                  ),
                ]),
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

      final markers = await searchState.results.getMarkers(
        router: ref.read(appRouterProvider),
        iconResolver: mapMarkerMapper.getMarkerType,
        isRtl: isRtl,
        isDark: dark.isDark,
      );
      if (!ref.read(searchInRectProvider).isSearchInThisAreaRequest) {
        ref.read(searchInRectProvider.notifier).searchInThisAreaSwitch(value: false);
        await mapObjectManager.removeAllMarkers();
      }
      await mapObjectManager.addMarkers(markers);
    } else if (searchState is SearchStateEmpty || searchState is SearchStateHistory && searchState.searchText.isEmpty) {
      await mapObjectManager.removeAllMarkers();
    }
  }

  SimpleClusterOptionsMessage _renderCluster(int objectCount) => SimpleClusterOptionsMessage(
        icon: Assets.icons.svg.icMarkerMNew.keyName.markerIcon(),
        text: '$objectCount',
        textStyle: MarkerTextStyleMessage(
          textPlacement: MarkerTextPlacementMessage(
            placement: TextPlacementMessage.centerCenter,
          ),
        ),
      );

  void _onExpansionChanged(Expansion expansion) => switch (expansion) {
        Expansion.middle => setState(() {
            currentSize = 0.8;
          }),
        Expansion.collapsed => setState(() {
            currentSize = 0.1;
          }),
        Expansion.hidden => _removeAllMarkersAndPop(),
        _ => null,
      };

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
    if (!kbState) {
      return;
    }
    final currentExp = _dgisSheetController.currentExpansion;
    if (currentExp == Expansion.expanded || currentExp == Expansion.middle) {
      return;
    }
    // We need to wait because of the rebuild the sheet state
    // At the build method we recalculate [collapsedHeight] and we secretly call the [didUpdateWidget] method
    // of [_dgisSheetController]. And if we call the [animateTo] method before the [didUpdateWidget] method
    // we will get set wrong [Expansion] value
    Future.delayed(Durations.short2).then((_) {
      _dgisSheetController.animateTo(Expansion.expanded);
    });
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
    ref.read(searchInRectProvider.notifier).update();
    context.router.popForced();
  }

  void _setupTapListener() {
    _streamSubscription = ref.read(mapTapHandlerProvider.notifier).listen((_) {
      if (context.router.isRouteActive(SearchRoute.name)) {
        _unfocusSearchField();
        _collapseBottomSheet();
      }
    });
  }

  void _collapseBottomSheet() {
    _dgisSheetController.animateTo(Expansion.collapsed);
  }
}
