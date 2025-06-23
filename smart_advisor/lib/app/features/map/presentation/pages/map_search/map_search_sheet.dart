/*import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/map_search/ui/map_search_content.dart';
import 'package:mapness/pages/map_search/ui/map_search_controls.dart';
import 'package:mapness/pages/map_search/ui/map_search_header_delegate.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/extensions/router_extension.dart';
import 'package:mapness/shared/lib/search/compute_camera_position.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

/// Search sheet that is shown on the explore screen.
class MapSearchSheet extends ConsumerStatefulWidget {
  final bool requestFocus;
  final bool withClustering;
  final double biggestHeight;

  const MapSearchSheet({
    required this.withClustering,
    required this.biggestHeight,
    required this.requestFocus,
    super.key,
  });

  @override
  ConsumerState<MapSearchSheet> createState() => _MapSearchSheetState();
}

class _MapSearchSheetState extends ConsumerState<MapSearchSheet> {
  late final DgisBottomSheetController _dgisSheetController;
  double currentSize = 0.1;
  late final StreamSubscription<bool> _keyboardVisible;
  final kbVisibilityController = KeyboardVisibilityController();
  final settings = MapObjectManagerSettings.search();
  StreamSubscription<TapEvent>? _streamSubscription;

  ClusteringMapObjectManager? _clustering;

  MapObjectManager? searchObjectManager;
  final _initialExpansion = Expansion.middle;

  @override
  void initState() {
    super.initState();
    _dgisSheetController = DgisBottomSheetController();
    _keyboardVisible = kbVisibilityController.onChange.listen(_onKeyboardToggle);
    _setupTapListener();
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
  void dispose() {
    _keyboardVisible.cancel();
    _dgisSheetController.dispose();
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final collapsedHeight = 88 + bottomSafeArea;

    searchObjectManager ??= ref.watch(
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
        _drawSearchMarkers(next, previous);
      },
    );

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        MapSearchSheetControls(currentSize: currentSize, collapsedSize: collapsedHeight),
        NotificationListener<ScrollNotification>(
          onNotification: _onNotification,
          child: DgisBottomSheet(
            key: const Key('MAP SEARCH SHEET KEY'),
            showBarrier: false,
            controller: _dgisSheetController,
            initialExpansion: _initialExpansion,
            availableExpansions: const {
              Expansion.hidden,
              Expansion.middle,
              Expansion.expanded,
              Expansion.collapsed,
            },
            onExpansionChanged: (expansion, {byUser = false}) => _onExpansionChanged(expansion),
            middleHeight: widget.biggestHeight * 0.8,
            collapsedHeight: collapsedHeight,
            scrollableBody: (context, scrollController) {
              /// some buggy behavior with ScrollViewKeyboardDismissBehavior.onDrag
              /// https://www.youtube.com/watch?v=L_WoOkDAqbM
              scrollController.addListener(_unfocusOnScroll);

              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Material(
                  color: Colors.white,
                  child: SearchScope(
                    named: SearchScopeEnum.map,
                    child: CustomScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        SliverPersistentHeader(
                          delegate: MapSearchHeaderDelegate(
                            requestFocus: widget.requestFocus,
                            onClose: onClose,
                          ),
                          pinned: true,
                        ),
                        MapSearchContent(
                          scrollController: scrollController,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          height: bottomSafeArea + 10,
          width: double.maxFinite,
          color: Colors.white,
        )
      ],
    );
  }

  Future<void> _drawSearchMarkers(SearchState searchState, SearchState? prevState) async {
    if (searchState is SearchStateResults &&
        (prevState is! SearchStateResults || prevState.results != searchState.results)) {
      final markerIconPath = searchState.markerType?.iconPath;
      final icon = markerIconPath != null
          ? markerIconPath.markerIcon(size: 32)
          : LayersSvgPaths.basicMarker.markerIcon(size: 16);

      final isRtl = ref.read(appLanguageProvider) == Language.arabic;
      final markers = await searchState.results.getMarkers(
        router: ref.read(goRouterProvider),
        icon: icon,
        isRtl: isRtl,
      );

      await searchObjectManager?.removeAllMarkers();
      await searchObjectManager?.addMarkers(markers);

      await computeCameraPosition(
        markers,
        ref.read(cameraPositionProvider),
        ref.read(cameraPositionProvider.notifier).animateTo,
      );
    } else if (searchState is SearchStateEmpty || searchState is SearchStateHistory) {
      await searchObjectManager?.removeAllMarkers();
    }
  }

  SimpleClusterOptionsMessage _renderCluster(int objectCount) => SimpleClusterOptionsMessage(
        icon: LayersSvgPaths.basicMarker.markerIcon(),
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
      _unfocusOnScroll();
    }
    return true;
  }

  void _unfocusOnScroll() {
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
    Future.delayed(Durations.short1).then((_) {
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
    searchObjectManager?.removeAllMarkers().then((value) {
      ref.read(searchInRectProvider.notifier).update();
      searchObjectManager = null;
    });
    context.pop();
  }

  Future<void> _setupTapListener() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _streamSubscription = dgisController.objectTapEvents.listen((_) {
      final goRouter = ref.read(goRouterProvider);

      if (goRouter.isCurrentRoute(SearchRoute.path)) {
        _dgisSheetController.animateTo(Expansion.collapsed);
      }
    });
  }
}
*/