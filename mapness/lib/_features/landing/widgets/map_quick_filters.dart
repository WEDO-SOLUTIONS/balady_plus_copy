import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/quick_filters/ui/quick_filters.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

const _objectManager = "QuickFilters";

class MapQuickFilters extends ConsumerStatefulWidget {
  const MapQuickFilters({
    super.key,
    this.customFilters,
    this.onCustomTap,
    this.forMap = false,
  });

  final List<FilterItem>? customFilters;
  final void Function(int)? onCustomTap;
  final bool forMap;

  @override
  ConsumerState<MapQuickFilters> createState() => _MapQuickFiltersState();
}

class _MapQuickFiltersState extends ConsumerState<MapQuickFilters> {
  late ClusteringMapObjectManager _clustering;

  @override
  void initState() {
    super.initState();
    _clustering = ClusteringMapObjectManager(
      options: ClusteringMapObjectManagerOptionsMessage(
        logicalPixel: 40,
        maxZoom: 16,
      ),
      renderCluster: _renderCluster,
    );
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
    final selectedFilter = ref.watch(searchByRubricsQueryProvider);
    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: _objectManager,
        clustering: _clustering,
      ).notifier,
    );
    ref.listen(searchByRubricsProvider, (previous, next) async {
      if (!widget.forMap) return;
      await searchObjectManager.removeAllMarkers();

      if (next != null) {
        List<Marker> markers = [];
        for (final markerInfo
            in (next.itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty())) {
          markers.add(
            Marker(
              id: markerInfo?.objectId?.objectId.toString() ??
                  context.l10n.invalid,
              onTap: () {
                PoiMapRoute.open(context, markerInfo.objectId!.objectId);
              },
              options: MarkerOptionsMessage(
                position: markerInfo!.geoPoint,
                icon: MarkerIconMessage(
                  path:
                      "packages/mapness/${selectedFilter?.$1.mapIcon ?? "assets/icons/svg/ic_marker.svg"}",
                  width: 24,
                ),
              ),
            ),
          );
        }

        await searchObjectManager.addMarkers(markers);

        ref.read(cameraPositionProvider.notifier).animateToMarkers(markers);
      }
    });

    return QuickFilters(
      onFavouritesBookmarkTap: () async {
        CommonFunctions.authOrOpen(ref, context, callback: () {
          const FavouritesRoute().push(context);
        });
      },
      onFilterTap: (filter, index) {
        if (selectedFilter?.$2 == index) {
          ref.read(searchByRubricsQueryProvider.notifier).update(null);
        } else {
          ref
              .read(searchByRubricsQueryProvider.notifier)
              .update((filter, index));
        }
      },
      selectedIndex: selectedFilter?.$2,
      itemBackground: widget.forMap ? Colors.white : const Color(0x0D1E2A36),
      customFilters: widget.customFilters,
      onCustomTap: widget.onCustomTap,
      padding: widget.forMap
          ? const EdgeInsets.symmetric(
              horizontal: 12,
            )
          : const EdgeInsets.symmetric(
              horizontal: 16,
            ),
    );
  }
}
