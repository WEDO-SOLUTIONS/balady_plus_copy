import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/map_search/ui/map_search_content.dart';
import 'package:mapness/pages/map_search/ui/map_search_header_delegate.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/markers_from_search.dart';
import 'package:mapness/shared/lib/search/compute_camera_position.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

class MapSearchSheet extends ConsumerStatefulWidget {
  const MapSearchSheet({
    required this.withClustering,
    required this.biggestHeight,
    super.key,
    this.initialQuery,
  });

  final String? initialQuery;
  final bool withClustering;
  final double biggestHeight;

  @override
  ConsumerState<MapSearchSheet> createState() => _MapSearchSheetState();
}

class _MapSearchSheetState extends ConsumerState<MapSearchSheet> {
  late final _dgisSheetController = DgisBottomSheetController();

  late final StreamSubscription<bool> _keyboardVisible;
  final kbVisibilityController = KeyboardVisibilityController();
  final settings = MapObjectManagerSettings.search();

  ClusteringMapObjectManager? _clustering;

  void onClose() {
    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.exitIcon,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
    );
    searchObjectManager.removeAllMarkers().then((value) => context.pop());
  }

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

  void _onKeyboardToggle(bool kbState) {
    if (!kbState) {
      return;
    }
    return switch (_dgisSheetController.currentExpansion) {
      Expansion.middle || Expansion.expanded => null,
      _ => _dgisSheetController.animateTo(Expansion.expanded),
    };
  }

  @override
  void dispose() {
    _keyboardVisible.cancel();
    _dgisSheetController.dispose();
    super.dispose();
  }

  MapObjectManager get searchObjectManager => ref.read(
        mapObjectManagerProvider(
          named: settings.name,
          layerId: settings.layerId,
          clustering: _clustering,
        ).notifier,
      );

  Future<void> _drawSearchMarkers(SearchState searchState) async {
    if (searchState is SearchStateResults) {
      final icon = LayersSvgPaths.basicMarker.markerIcon(size: 16);
      final markers = await searchState.results.getMarkers(router: ref.read(goRouterProvider), icon: icon);

      await searchObjectManager.removeAllMarkers();
      await searchObjectManager.addMarkers(markers);

      await computeCameraPosition(
        markers,
        ref.read(cameraPositionProvider),
        ref.read(cameraPositionProvider.notifier).animateTo,
      );
    }
  }

  void _currentRouteListener(RouteState? previous, RouteState? next) {
    if (next?.currentPath != null && next!.currentPath!.startsWith('/search')) {
      _dgisSheetController.animateTo(Expansion.expanded);
    } else {
      _dgisSheetController.animateTo(Expansion.hidden);
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
        Expansion.hidden => searchObjectManager.removeAllMarkers().then((value) => context.pop()),
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    ref
      ..watch(
        mapObjectManagerProvider(
          named: settings.name,
          layerId: settings.layerId,
          clustering: _clustering,
        ).notifier,
      )
      ..listen(
        searchProvider(SearchScopeEnum.map.value),
        (previous, next) => _drawSearchMarkers(next),
      )
      ..listen<RouteState?>(currentRouteProvider, _currentRouteListener);

    return Directionality(
      textDirection: Directionality.of(context),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            if (kbVisibilityController.isVisible) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          }
          return true;
        },
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
            scrollController.addListener(
              () {
                /// some buggy behavior with ScrollViewKeyboardDismissBehavior.onDrag
                /// https://www.youtube.com/watch?v=L_WoOkDAqbM
                if (kbVisibilityController.isVisible) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
            );

            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
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
    );
  }
}
