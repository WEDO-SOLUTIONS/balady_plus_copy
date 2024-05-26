import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/layers_utils.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/map_search/ui/map_search_content.dart';
import 'package:mapness/pages/map_search/ui/map_search_header_delegate.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';

const searchScope = 'MapSearch';

class MapSearchSheet extends StatelessWidget {
  const MapSearchSheet({
    required this.withClustering,
    super.key,
    this.initialQuery,
  });

  final String? initialQuery;
  final bool withClustering;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => _MapSearchSheet(
          initialQuery: initialQuery,
          withClustering: withClustering,
          biggestHeight: constraints.biggest.height,
        ),
      );
}

class _MapSearchSheet extends ConsumerStatefulWidget {
  const _MapSearchSheet({
    required this.withClustering,
    required this.biggestHeight,
    this.initialQuery,
  });

  final String? initialQuery;
  final bool withClustering;
  final double biggestHeight;

  @override
  ConsumerState<_MapSearchSheet> createState() => _MapSearchSheetState();
}

class _MapSearchSheetState extends ConsumerState<_MapSearchSheet> {
  late final _dgisSheetController = DgisBottomSheetController();

  late final StreamSubscription<bool> _keyboardVisible;
  final kbVisibilityController = KeyboardVisibilityController();
  final settings = MapObjectManagerSettings.search();

  bool closing = false;

  ClusteringMapObjectManager? _clustering;

  void close() {
    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.exitIcon,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
    );

    setState(() {
      closing = true;
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      _dgisSheetController.animateTo(Expansion.hidden);
    });
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

  Future<void> _drawSearchMarkers(SearchState searchState) async {
    final searchObjectManager = ref.read(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
        clustering: _clustering,
      ).notifier,
    );
    await searchObjectManager.removeAllMarkers();
    if (searchState is SearchStateResults) {
      final markers = <Marker>[];
      for (final markerInfo in searchState.results.itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty()) {
        markers.add(
          Marker(
            id: markerInfo?.objectId?.objectId.toString() ?? context.l10n.invalid,
            onTap: () {
              Metrics.logEventAdvanced(MetricsConstants.poiKeys.marker,
                  group: MetricsConstants.poiTag,
                  action: MetricAction.tap.toString(),
                  props: {'objectId': markerInfo.objectId!.objectId});

              PoiMapRoute.open(
                ref.read(goRouterProvider),
                markerInfo.objectId!.objectId,
              );
            },
            options: MarkerOptionsMessage(
              position: markerInfo!.geoPoint,
              icon: LayersSvgPaths.basicMarker.markerIcon(size: 16),
            ),
          ),
        );
      }

      await searchObjectManager.addMarkers(markers);

      _dgisSheetController.animateTo(Expansion.middle);
    }
  }

  void _currentRouteListener(RouteState? previous, RouteState? next) {
    if (next?.currentPath != null && next!.currentPath!.startsWith('/search')) {
      _dgisSheetController.animateTo(Expansion.middle);
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
      Expansion.hidden => context.pop(),
      Expansion.middle => context.pop(),
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
        searchProvider(searchScope),
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
            Expansion.expanded,
            Expansion.middle,
          },
          onExpansionChanged: (expansion, {byUser = false}) => _onExpansionChanged(expansion),
          middleHeight: widget.biggestHeight * 0.7,
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
                  named: searchScope,
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverPersistentHeader(
                        delegate: MapSearchHeaderDelegate(
                          requestFocus: widget.initialQuery == null,
                          onClose: close,
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
