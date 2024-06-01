import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/providers/search_in_rect.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/map_search/ui/map_search_content.dart';
import 'package:mapness/pages/map_search/ui/map_search_header_delegate.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/lib/search/compute_camera_position.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

/// Search sheet that is shown on the explore screen.
class MapSearchSheet extends ConsumerStatefulWidget {
  final String? initialQuery;
  final bool withClustering;
  final double biggestHeight;

  const MapSearchSheet({
    required this.withClustering,
    required this.biggestHeight,
    super.key,
    this.initialQuery,
  });

  @override
  ConsumerState<MapSearchSheet> createState() => _MapSearchSheetState();
}

class _MapSearchSheetState extends ConsumerState<MapSearchSheet> {
  late final _dgisSheetController = DgisBottomSheetController();

  late final StreamSubscription<bool> _keyboardVisible;
  final kbVisibilityController = KeyboardVisibilityController();
  final settings = MapObjectManagerSettings.mappness();

  ClusteringMapObjectManager? _clustering;

  MapObjectManager? searchObjectManager;

  @override
  void initState() {
    super.initState();
    _keyboardVisible = kbVisibilityController.onChange.listen(_onKeyboardToggle);
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    ref
      ..watch(searchInRectProvider.notifier)
      ..listen(
        searchProvider(SearchScopeEnum.map.value),
        (previous, next) => _drawSearchMarkers(next),
      )
      ..listen<RouteState?>(currentRouteProvider, _currentRouteListener);

    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // TODO: We should add map controlls here
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: widget.biggestHeight * 0.2 + 16, left: 12),
            child: SearchInArea(
              visible: false,
              title: context.l10n.searchInThisArea,
              onTap: () {
                ref.read(searchProvider(SearchScopeEnum.map.value).notifier).searchInThisArea();
                ref.read(searchInRectProvider.notifier).update();
              },
            ),
          ),
        ),
        NotificationListener<ScrollNotification>(
          onNotification: _onNotification,
          child: DgisBottomSheet(
            showBarrier: false,
            controller: _dgisSheetController,
            initialExpansion: Expansion.expanded,
            availableExpansions: const {
              Expansion.hidden,
              Expansion.expanded,
              Expansion.collapsed,
            },
            onExpansionChanged: (expansion, {byUser = false}) => _onExpansionChanged(expansion),
            middleHeight: widget.biggestHeight * 0.7,
            collapsedHeight: widget.biggestHeight * 0.2,
            scrollableBody: (context, scrollController) {
              /// some buggy behavior with ScrollViewKeyboardDismissBehavior.onDrag
              /// https://www.youtube.com/watch?v=L_WoOkDAqbM
              scrollController.addListener(_unfocusOnScroll);

              return ClipRRect(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
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
                            requestFocus: widget.initialQuery == null,
                            onClose: onClose,
                          ),
                          pinned: true,
                        ),
                        MapSearchContent(scrollController: scrollController),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _drawSearchMarkers(SearchState searchState) async {
    if (searchState is SearchStateResults) {
      final icon = LayersSvgPaths.basicMarker.markerIcon(size: 16);
      final markers = await searchState.results.getMarkers(router: ref.read(goRouterProvider), icon: icon);

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

  void _currentRouteListener(RouteState? previous, RouteState? next) {
    if (next?.currentPath != null && next!.currentPath!.startsWith('/search')) {
      _dgisSheetController.animateTo(Expansion.expanded);
    } else {
      // _dgisSheetController.animateTo(Expansion.collapsed);
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
        Expansion.hidden => close(),
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
    return switch (_dgisSheetController.currentExpansion) {
      Expansion.middle || Expansion.expanded => null,
      _ => _dgisSheetController.animateTo(Expansion.expanded),
    };
  }

  void onClose() {
    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.exitIcon,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
    );
    close();
  }

  void close() {
    searchObjectManager?.removeAllMarkers().then((value) {
      ref.read(searchInRectProvider.notifier).update();
      searchObjectManager = null;
      context.pop();
    });
  }
}
