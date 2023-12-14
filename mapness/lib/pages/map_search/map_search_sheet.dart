import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/map_search/ui/map_search_content.dart';
import 'package:mapness/pages/map_search/ui/map_search_header_delegate.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

const searchScope = 'MapSearch';
const searchManagerName = "mapSearchManager";

class MapSearchSheet extends StatelessWidget {
  const MapSearchSheet({
    super.key,
    required this.withClustering,
    this.initialQuery,
  });

  final String? initialQuery;
  final bool withClustering;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _MapSearchSheet(
        initialQuery: initialQuery,
        withClustering: withClustering,
        biggestHeight: constraints.biggest.height,
      ),
    );
  }
}

class _MapSearchSheet extends ConsumerStatefulWidget {
  const _MapSearchSheet({
    super.key,
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
  late DraggableScrollableController _controller;

  double get _headerExtent => 88 / widget.biggestHeight;

  bool visible = true;

  bool closing = false;

  late ClusteringMapObjectManager _clustering;

  void close() {
    setState(() {
      closing = true;
    });
    Future.delayed(const Duration(milliseconds: 50), () {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
    _controller.addListener(() {
      if (_controller.size <= 0.001 && visible) {
        context.pop();
      }
    });
    _clustering = ClusteringMapObjectManager(
      options: ClusteringMapObjectManagerOptionsMessage(
        logicalPixel: 40,
        maxZoom: 16,
      ),
      renderCluster: _renderCluster,
    );
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
        clustering: _clustering,
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
              id: markerInfo?.objectId?.objectId.toString() ??
                  context.l10n.invalid,
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
          0.7,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      }
    });
    ref.listen(currentRouteProvider, (prev, next) {
      if (next != null && next.startsWith("/search")) {
        _controller
            .animateTo(
              0.7,
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
    final closable = ref.watch(searchProvider(searchScope)
            .select((value) => value is! SearchStateResults)) ||
        closing;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        controller: _controller,
        initialChildSize: closable ? 0 : _headerExtent,
        minChildSize: closable ? 0 : _headerExtent,
        maxChildSize: 0.9,
        snap: true,
        snapSizes: [closable ? 0 : _headerExtent, 0.7, 0.9],
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
        ),
      ),
    );
  }
}
