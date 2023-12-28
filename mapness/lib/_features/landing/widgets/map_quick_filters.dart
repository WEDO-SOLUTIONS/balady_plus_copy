import 'package:balady_plus/app/core/utils/debouncer.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/features/quick_filters/ui/quick_filters.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

const _objectManager = "QuickFilters";

double distanceToZoom(
    (List<(double, double)> coordinates, (double, double) position) data) {
  double minDistance = double.infinity;
  for (final coordinate in data.$1) {
    final distance = CommonFunctions.distance(
      coordinate.$1,
      coordinate.$2,
      data.$2.$1,
      data.$2.$2,
    );
    if (distance < minDistance) {
      minDistance = distance;
    }
  }

  if (minDistance < 1) {
    return 15;
  } else if (minDistance < 5) {
    return 13;
  } else if (minDistance < 10) {
    return 11;
  } else if (minDistance < 20) {
    return 9;
  }
  return 7;
}

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
  bool isZoomInteracted = false;
  bool isCoordComputed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isZoomInteracted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedFilter = ref.watch(searchByRubricsQueryProvider);

    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: _objectManager,
      ).notifier,
    );
    ref.listen(searchByRubricsProvider, (previous, next) async {
      if (!widget.forMap) return;
      await searchObjectManager.removeAllMarkers();

      final value = next.unwrapPrevious().valueOrNull;

      if (value != null) {
        List<Marker> markers = [];
        for (final markerInfo
            in (value.itemMarkerInfos ?? List<ItemMarkerInfoMessage>.empty())) {
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

        Debouncer(milliseconds: 300).run(() async {
          await _computeCameraPosition(markers);
        });
      } else {
        isZoomInteracted = false;
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
          ref.read(layersControlsProvider.notifier).disable();
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

  Future<void> _computeCameraPosition(List<Marker> markers) async {
    if (isCoordComputed) return;

    final List<(double, double)> coordinates = markers.map((e) {
      final position = e.options.position;
      return (position.latitude, position.longitude);
    }).toList();

    final location = ref.read(cameraPositionProvider)?.point;

    if (location?.latitude == null && location?.longitude == null) return;
    if (isZoomInteracted) return;

    final position = (location?.latitude ?? 0, location?.longitude ?? 0);

    isCoordComputed = true;

    double zoom = markers.isEmpty
        ? 7.0
        : await compute(distanceToZoom, (coordinates, position));

    isCoordComputed = false;
    final cameraPosition = ref.read(cameraPositionProvider);

    if (isZoomInteracted && cameraPosition?.zoom != null) {
      zoom = cameraPosition!.zoom < zoom ? cameraPosition.zoom : zoom;
    }

    if (cameraPosition?.point == null) return;

    ref.read(cameraPositionProvider.notifier).animateTo(CameraPositionMessage(
          point: cameraPosition!.point,
          tilt: cameraPosition.tilt,
          bearing: cameraPosition.bearing,
          zoom: zoom,
        ));

    isZoomInteracted = true;
  }
}
