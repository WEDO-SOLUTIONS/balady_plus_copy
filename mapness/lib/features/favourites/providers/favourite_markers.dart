import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_type.dart';
import 'package:mapness/features/favorite_lists/data/models/map_marker_dto.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/features/favorite_lists/providers/aggregated_favorite_markers.dart';
import 'package:mapness/features/favourites/helpers/construct_marker.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/favorite_pin_marker_bitmap.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_markers.g.dart';

final favouriteMarkersProvider = _favouriteMarkersProvider;

@riverpod
class FavouriteToggle extends _$FavouriteToggle {
  @override
  bool build() {
    final currentLayer = ref.read(activeLayerProvider);
    final isFavourites = currentLayer == LayerType.favourites;

    return isFavourites;
  }

  Future<void> enable() async {
    final activeLayer = ref.read(activeLayerProvider.notifier);
    await activeLayer.setActiveLayer(LayerType.favourites);
    ref.invalidateSelf();
  }

  Future<void> disable() async {
    final activeLayer = ref.read(activeLayerProvider.notifier);
    await activeLayer.removeActiveLayer();
    ref.invalidateSelf();
  }

  Future<void> toggle() async {
    final activeLayersNotifier = ref.read(activeLayerProvider.notifier);

    final isFavourites = ref.read(activeLayerProvider) == LayerType.favourites;
    if (isFavourites) {
      await activeLayersNotifier.removeActiveLayer();
    } else {
      await activeLayersNotifier.setActiveLayer(LayerType.favourites);
    }

    ref.invalidateSelf();
  }
}

@Riverpod(keepAlive: true)
class _FavouriteMarkers extends _$FavouriteMarkers {
  // A place's position never changes, so resolved positions are cached for
  // the lifetime of this (keepAlive) provider — repeat builds triggered by
  // unrelated dependency changes don't re-issue native searchByObjectId
  // calls for placeIds already resolved.
  final Map<String, ({GeoPointWithElevationMessage position, String title})> _resolvedPlaces = {};

  Future<({GeoPointWithElevationMessage position, String title})?> _resolvePlace(
    DgisMapController dgisController,
    MapMarkerDto marker,
  ) async {
    final cached = _resolvedPlaces[marker.placeId];
    if (cached != null) {
      return cached;
    }

    final point = marker.point;
    if (point != null) {
      final position = GeoPointWithElevationMessage(latitude: point.lat, longitude: point.lon, elevation: 1);
      // The API returns a name for most markers; for the rest (legacy/unresolved
      // places) fall back to the directory lookup, same as before `name` existed.
      // A lookup failure no longer removes the marker: its position is already
      // known from the API.
      final apiName = marker.name;
      final title = (apiName != null && apiName.isNotEmpty)
          ? apiName
          : await _resolveTitle(dgisController, marker.placeId);
      final resolved = (position: position, title: title ?? '');
      _resolvedPlaces[marker.placeId] = resolved;
      return resolved;
    }

    // No coordinates from the API for this place (legacy/unresolved) — fall
    // back to resolving both position and title from the same directory
    // lookup, as before `point` existed.
    final objectId = int.tryParse(marker.placeId);
    if (objectId == null) {
      return null;
    }
    try {
      final directoryObject = await dgisController
          .searchByObjectId(
            DgisObjectIdMessage(objectId: objectId, entranceId: 0),
          )
          .timeout(const Duration(seconds: 10));
      final markerPosition = directoryObject.markerPosition;
      if (markerPosition == null) {
        return null;
      }
      final resolved = (
        position: GeoPointWithElevationMessage(
          latitude: markerPosition.latitude,
          longitude: markerPosition.longitude,
          elevation: 1,
        ),
        title: directoryObject.title,
      );
      _resolvedPlaces[marker.placeId] = resolved;
      return resolved;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _resolveTitle(DgisMapController dgisController, String placeId) async {
    final objectId = int.tryParse(placeId);
    if (objectId == null) {
      return null;
    }
    try {
      final directoryObject = await dgisController
          .searchByObjectId(
            DgisObjectIdMessage(objectId: objectId, entranceId: 0),
          )
          .timeout(const Duration(seconds: 10));
      return directoryObject.title;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> build({required BaladyAppThemes theme}) async {
    final settings = MapObjectManagerSettings.favourites();
    final mapObjectManager = ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );
    final router = ref.watch(appRouterProvider);
    final favItemsAsync = ref.watch(favouriteCacheProvider);
    final showMarkers = ref.watch(favouriteToggleProvider);

    /// don't show markers if user disabled them or if there are no favourites
    if (!showMarkers || favItemsAsync.value == null) {
      return;
    }

    final markers = <Marker>[];
    final favItems = favItemsAsync.requireValue;

    final devicePixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final favoritePinIcon = PngBytesMarkerIcon(
      pngData: await ref
          .read(favoritePinMarkerBitmapProvider)
          .render(tint: const Color(0xFF1E928F), icon: FavoriteIconType.$default, devicePixelRatio: devicePixelRatio),
      width: 24,
    );
    if (!ref.mounted) {
      return;
    }
    for (final element in favItems.items) {
      markers.add(constructMarker(element, favoritePinIcon, router));
    }

    /// add home if exists
    if (favItems.home != null) {
      final homeIconBytes = await ref
          .read(favoritePinMarkerBitmapProvider)
          .render(tint: MarkerColorCode.green.color, icon: FavoriteIconType.home, devicePixelRatio: devicePixelRatio);
      if (!ref.mounted) {
        return;
      }
      final homeObjectId = parseObjectIdFromFavouriteEntityId(favItems.home!.entity?.id);
      markers.add(
        constructMarker(
          favItems.home!,
          PngBytesMarkerIcon(pngData: homeIconBytes, width: 24),
          router,
          markerId: homeObjectId != null ? homeWorkMarkerId(homeObjectId) : null,
        ),
      );
    }

    /// add work if exists
    if (favItems.work != null) {
      final workIconBytes = await ref
          .read(favoritePinMarkerBitmapProvider)
          .render(
            tint: MarkerColorCode.green.color,
            icon: FavoriteIconType.building,
            devicePixelRatio: devicePixelRatio,
          );
      if (!ref.mounted) {
        return;
      }
      final workObjectId = parseObjectIdFromFavouriteEntityId(favItems.work!.entity?.id);
      markers.add(
        constructMarker(
          favItems.work!,
          PngBytesMarkerIcon(pngData: workIconBytes, width: 24),
          router,
          markerId: workObjectId != null ? homeWorkMarkerId(workObjectId) : null,
        ),
      );
    }

    /// add places from the favorite lists API (new API, colored by list)
    final aggregatedMarkers = await ref.watch(aggregatedFavoriteMarkersProvider.future);
    if (!ref.mounted) {
      return;
    }
    final dgisController = await ref.read(dgisControllerProvider.future);
    if (!ref.mounted) {
      return;
    }
    final favoriteListMarkers = await Future.wait(
      aggregatedMarkers.map((marker) async {
        final resolved = await _resolvePlace(dgisController, marker);
        if (resolved == null) {
          return null;
        }
        try {
          final iconBytes = await ref
              .read(favoritePinMarkerBitmapProvider)
              .render(
                tint: marker.markerColorCode.color,
                icon: marker.iconType ?? FavoriteIconType.$default,
                devicePixelRatio: devicePixelRatio,
              );
          return constructFavoriteListPlaceMarker(
            marker,
            resolved.position,
            PngBytesMarkerIcon(pngData: iconBytes, width: 24),
            router,
          );
        } catch (_) {
          return null;
        }
      }),
    );
    if (!ref.mounted) {
      return;
    }
    markers.addAll(favoriteListMarkers.nonNulls);

    await mapObjectManager.removeAllMarkers();

    /// add markers to map
    await mapObjectManager.addMarkers(markers);
  }
}
