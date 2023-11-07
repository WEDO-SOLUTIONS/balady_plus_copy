// import 'package:collection/collection.dart';
// import 'package:dgis_map/library.dart';
// import 'package:mapness/features/favourites/providers/favourite_items.dart';
// import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/features/common/providers/shared_prefs.dart';
import 'package:mapness/features/favourites/providers/favourite_repository.dart';
import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_markers.g.dart';

const _showFavouritesOnMapKey = "showFavouritesOnMap";

@riverpod
class FavouriteMarkers extends _$FavouriteMarkers {
  List<Marker> _markers = [];

  @override
  bool build() {
    final dgisController = ref.watch(dgisControllerProvider);

    final sharedPrefs = ref.watch(sharedPrefsProvider);

    state = sharedPrefs.getBool(_showFavouritesOnMapKey) ?? false;

    ref.listen(favouriteRepositoryProvider, (previous, next) {
      for (var marker in _markers) {
        dgisController?.removeMarker(marker.id);
      }

      if (!state || next.value == null) {
        return;
      }

      _markers = [];
      for (var element in next.value!.items) {
        _markers.add(
          Marker(
            id: element.id,
            options: MarkerOptionsMessage(
              position: GeoPointWithElevationMessage(
                latitude: element.coordinates.latitude,
                longitude: element.coordinates.longitude,
                elevation: 0,
              ),
              icon: MarkerIconMessage(
                path: "packages/mapness/assets/icons/svg/ic_fav_pin.svg",
                width: 24,
              ),
            ),
            onTap: () {
              // TODO(Demezy): add something
            },
          ),
        );
      }

      if (next.value!.home != null) {
        _markers.add(
          Marker(
            id: next.value!.home!.id,
            options: MarkerOptionsMessage(
              position: GeoPointWithElevationMessage(
                latitude: next.value!.home!.coordinates.latitude,
                longitude: next.value!.home!.coordinates.longitude,
                elevation: 0,
              ),
              icon: MarkerIconMessage(
                path: "packages/mapness/assets/icons/svg/ic_home_pin.svg",
                width: 24,
              ),
            ),
            onTap: () {
              // TODO(Demezy): add something
            },
          ),
        );
      }

      if (next.value!.work != null) {
        _markers.add(
          Marker(
            id: next.value!.work!.id,
            options: MarkerOptionsMessage(
              position: GeoPointWithElevationMessage(
                latitude: next.value!.work!.coordinates.latitude,
                longitude: next.value!.work!.coordinates.longitude,
                elevation: 0,
              ),
              icon: MarkerIconMessage(
                path: "packages/mapness/assets/icons/svg/ic_work_pin.svg",
                width: 24,
              ),
            ),
            onTap: () {
              // TODO(Demezy): add something
            },
          ),
        );
      }

      dgisController?.addMarkers(_markers);
    }, fireImmediately: true);

    return state;
  }

  void enable() {
    final sharedPrefs = ref.watch(sharedPrefsProvider);
    sharedPrefs.setBool(_showFavouritesOnMapKey, true);
    ref.invalidateSelf();
  }

  void disable() {
    final sharedPrefs = ref.watch(sharedPrefsProvider);
    sharedPrefs.setBool(_showFavouritesOnMapKey, false);
    ref.invalidateSelf();
  }

  void toggle() {
    final sharedPrefs = ref.watch(sharedPrefsProvider);
    sharedPrefs.setBool(_showFavouritesOnMapKey, !state);
    ref.invalidateSelf();
  }
}
