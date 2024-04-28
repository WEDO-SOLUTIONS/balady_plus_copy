import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/favourites/lib/construct_marker.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_markers.g.dart';

final favouriteMarkersProvider = _favouriteMarkersProvider;

@riverpod
class FavouriteToggle extends _$FavouriteToggle {
  @override
  bool build() {
    final sharedPrefs = ref.watch(sharedPrefsProvider);
    final string = sharedPrefs.getString(MapnessConsts.activeLayerKey);
    final bool = string == LayerType.favourites.name;
    return bool;
  }

  Future<void> enable() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    await sharedPrefs.setString(
      MapnessConsts.activeLayerKey,
      LayerType.favourites.name,
    );
    ref.invalidateSelf();
  }

  Future<void> disable() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    await sharedPrefs.remove(
      MapnessConsts.activeLayerKey,
    );
    ref.invalidateSelf();
  }

  Future<void> toggle() async {
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final name = LayerType.favourites.name;
    final currentState =
        sharedPrefs.getString(MapnessConsts.activeLayerKey) == name;
    if (currentState) {
      await sharedPrefs.remove(MapnessConsts.activeLayerKey);
    } else {
      await sharedPrefs.setString(
        MapnessConsts.activeLayerKey,
        name,
      );
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
    final router = ref.watch(goRouterProvider);
    final favItemsAsync = ref.watch(favouriteCacheProvider);
    final showMarkers = ref.watch(favouriteToggleProvider);

    /// clear markers (for state change handling)
    await mapObjectManager.removeAllMarkers();

    /// don't show markers if user disabled them or if there are no favourites
    if (!showMarkers || favItemsAsync.value == null) {
      return;
    }

    final markers = <Marker>[];
    final favItems = favItemsAsync.requireValue;

    for (final element in favItems.items) {
      markers.add(
        constructMarker(
          element,
          'packages/mapness/assets/icons/svg/ic_fav_pin.svg',
          router,
        ),
      );
    }

    /// add home if exists
    if (favItems.home != null) {
      markers.add(
        constructMarker(
          favItems.home!,
          'packages/mapness/assets/icons/svg/ic_home_pin.svg',
          router,
        ),
      );
    }

    /// add work if exists
    if (favItems.work != null) {
      markers.add(
        constructMarker(
          favItems.work!,
          'packages/mapness/assets/icons/svg/ic_work_pin.svg',
          router,
        ),
      );
    }

    /// add markers to map
    await mapObjectManager.addMarkers(markers);
  }
}
