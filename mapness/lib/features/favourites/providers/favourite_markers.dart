import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/favorite_lists/data/models/icon_code.dart';
import 'package:mapness/features/favourites/helpers/construct_marker.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/features/lifestyle_layers/providers/active_layer.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
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

@riverpod
class _FavouriteMarkers extends _$FavouriteMarkers {
  @override
  Future<void> build() async {
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

    // todo(claude): here we need to fetch favorite items from api and draw them
    final devicePixelRatio = WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final favoritePinIcon = PngBytesMarkerIcon(
      pngData: await ref
          .read(favoritePinMarkerBitmapProvider)
          .render(tint: const Color(0xFF1E928F), icon: FavoriteIconCode.$default, devicePixelRatio: devicePixelRatio),
      width: 24,
    );
    for (final element in favItems.items) {
      markers.add(constructMarker(element, favoritePinIcon, router));
    }

    /// add home if exists
    if (favItems.home != null) {
      markers.add(
        constructMarker(
          favItems.home!,
          Assets.icons.svg.layers.icFavHome.keyName.markerIcon(),
          router,
        ),
      );
    }

    /// add work if exists
    if (favItems.work != null) {
      markers.add(
        constructMarker(
          favItems.work!,
          Assets.icons.svg.layers.icFavWork.keyName.markerIcon(),
          router,
        ),
      );
    }

    await mapObjectManager.removeAllMarkers();

    /// add markers to map
    await mapObjectManager.addMarkers(markers);
  }
}
