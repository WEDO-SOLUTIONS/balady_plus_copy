import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/map/providers/object_manager.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/map_search/ui/map_search_content.dart';
import 'package:mapness/pages/map_search/ui/map_search_header_delegate.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

const searchScope = 'MapSearch';
const searchManagerName = "mapSearchManager";

class MapSearchSheet extends ConsumerStatefulWidget {
  const MapSearchSheet({
    super.key,
    required this.withClustering,
    this.initialQuery,
  });

  final String? initialQuery;
  final bool withClustering;

  @override
  ConsumerState<MapSearchSheet> createState() => _MapSearchSheetState();
}

class _MapSearchSheetState extends ConsumerState<MapSearchSheet> {
  late DraggableScrollableController _controller;

  bool visible = true;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    _controller.addListener(() {
      if (_controller.size <= 0.001 && visible) {
        context.pop();
      }
    });
    Future.delayed(Duration.zero, () {
      _controller.animateTo(
        0.9,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      if (widget.initialQuery != null) {
        ref
            .read(searchQueryProvider(searchScope).notifier)
            .update(widget.initialQuery!);
        ref
            .read(searchProvider(searchScope).notifier)
            .searchByText(widget.initialQuery!);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  SimpleClusterOptionsMessage _renderCluster(int objectCount) {
    return SimpleClusterOptionsMessage(
      icon: MarkerIconMessage(
        path: "packages/mapness/assets/icons/svg/ic_marker.svg",
        width: 24,
      ),
      text: "$objectCount",
      textStyle: MarkerTextStyleMessage(
        textPlacement: MarkerTextPlacementMessage(
          placement: TextPlacementMessage.centerCenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: searchManagerName,
        clustering: widget.withClustering
            ? ClusteringMapObjectManager(
                options: ClusteringMapObjectManagerOptionsMessage(
                  logicalPixel: 40,
                  maxZoom: 16,
                ),
                renderCluster: _renderCluster)
            : null,
      ).notifier,
    );
    ref.listen(searchProvider(searchScope), (previous, next) async {
      await searchObjectManager.removeAllMarkers();

      if (next is SearchStateResults) {
        List<Marker> markers = [];
        for (final markerInfo in (next.results.itemMarkerInfos ??
            List<ItemMarkerInfoMessage>.empty())) {
          markers.add(
            Marker(
              id: markerInfo?.objectId?.objectId.toString() ?? "invalid",
              onTap: () {
                PoiMapRoute(dgisObjectId: markerInfo.objectId!.objectId)
                    .push(context);
              },
              options: MarkerOptionsMessage(
                position: markerInfo!.geoPoint,
                icon: MarkerIconMessage(
                  path: "packages/mapness/assets/icons/svg/ic_marker.svg",
                  width: 24,
                ),
              ),
            ),
          );
        }

        await searchObjectManager.addMarkers(markers);

        _controller.animateTo(
          0.5,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      }
    });
    ref.listen(currentRouteProvider, (prev, next) {
      print(next);
      if (next != null && next.startsWith("/search")) {
        _controller
            .animateTo(
              0.5,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            )
            .then(
              (value) => setState(() {
                visible = true;
              }),
            );
      } else {
        setState(() {
          visible = false;
        });
        _controller.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: 0,
        minChildSize: 0,
        maxChildSize: 0.9,
        snap: true,
        snapSizes: const [0, 0.5, 0.9],
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
            ),
          ),
          child: Material(
            color: const Color(0xFFF1F4F8),
            child: SearchScope(
              named: searchScope,
              child: CustomScrollView(
                controller: scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    delegate: MapSearchHeaderDelegate(
                      draggableScrollableController: _controller,
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
        ),
      ),
    );
  }
}
