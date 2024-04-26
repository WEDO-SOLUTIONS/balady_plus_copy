import 'package:balady_plus/app/core/utils/debouncer.dart';
import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/features/quick_filters/ui/quick_filters.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/geo/geo_utils.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';

class MapQuickFilters extends ConsumerStatefulWidget {
  const MapQuickFilters({
    super.key,
    this.customFilters,
    this.onCustomTap,
    this.forMap = false,
  });

  final List<FilterItem>? customFilters;
  final void Function(FilterItem)? onCustomTap;
  final bool forMap;

  @override
  ConsumerState<MapQuickFilters> createState() => _MapQuickFiltersState();
}

class _MapQuickFiltersState extends ConsumerState<MapQuickFilters> {
  bool isZoomInteracted = false;
  bool isCoordComputed = false;

  late final Debouncer _debouncer = Debouncer(milliseconds: 400);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isZoomInteracted = false;
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedFilter = ref.watch(searchByRubricsQueryProvider);
    final settings = MapObjectManagerSettings.quickFilter();
    final searchObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );
    ref.listen(searchByRubricsProvider, (previous, next) async {
      if (!widget.forMap) {
        return;
      }
      final value = next.unwrapPrevious().value;
      if (value != null) {
        Debouncer(milliseconds: 300).run(() async {
          await _computeCameraPosition(value);
        });
      } else {
        isZoomInteracted = false;
      }
    });

    return QuickFilters(
      onFavouritesBookmarkTap: () => CommonFunctions.authOrOpen(
        context,
        callback: () {
          if (!mounted) {
            return;
          }
          const FavouritesRoute().push(context);
        },
      ),
      onFilterTap: (filter, index) {
        _debouncer.run(() {
          if (selectedFilter?.$1 == filter) {
            ref.read(searchByRubricsQueryProvider.notifier).update(null);
            searchObjectManager.removeAllMarkers();
          } else {
            ref.read(layersControlsProvider.notifier).disable();
            ref
                .read(searchByRubricsQueryProvider.notifier)
                .update((filter, index));
          }
        });
      },
      onFavouritesTap: () {
        _debouncer.run(() {
          ref.read(searchByRubricsQueryProvider.notifier).update(null);
          searchObjectManager.removeAllMarkers();
        });
      },
      selectedIndex: selectedFilter?.$2,
      itemBackground: widget.forMap ? Colors.white : NonThemeColor.color11,
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
    if (isCoordComputed) {
      return;
    }

    final location = ref.read(cameraPositionProvider)?.point;

    if (location?.latitude == null && location?.longitude == null) {
      return;
    }
    if (isZoomInteracted) {
      return;
    }

    isCoordComputed = true;

    var zoom = await GeoUtils.zoomByMarkersNearby(
      markers: markers,
      position: location!,
    );

    isCoordComputed = false;
    final cameraPosition = ref.read(cameraPositionProvider);

    if (cameraPosition?.zoom != null) {
      zoom = cameraPosition!.zoom < zoom ? cameraPosition.zoom : zoom;
    }
    if (cameraPosition?.point == null) {
      return;
    }

    await ref.read(cameraPositionProvider.notifier).animateTo(
          CameraPositionMessage(
            point: cameraPosition!.point,
            tilt: cameraPosition.tilt,
            bearing: cameraPosition.bearing,
            zoom: zoom,
          ),
        );

    isZoomInteracted = true;
  }
}
