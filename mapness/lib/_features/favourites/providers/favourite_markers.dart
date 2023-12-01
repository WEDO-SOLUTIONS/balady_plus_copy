// import 'package:collection/collection.dart';
// import 'package:dgis_map/library.dart';
// import 'package:mapness/features/favourites/providers/favourite_items.dart';
// import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
// import 'package:mapness/_features/favourites/providers/favourite_items.dart';
// import 'package:mapness/_features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_markers.g.dart';

const _showFavouritesOnMapKey = "showFavouritesOnMap";

@riverpod
class _FavouriteMarkers extends _$FavouriteMarkers {
  List<Marker> _markers = [];

  @override
  bool build() {
    final dgisController = ref.watch(dgisControllerProvider);

    final sharedPrefs = ref.watch(sharedPrefsProvider);

    state = sharedPrefs.getBool(_showFavouritesOnMapKey) ?? false;
    final router = ref.watch(goRouterProvider);

    ref.listen(favouriteRepositoryProvider, (previous, next) {
      for (var marker in _markers) {
        dgisController?.removeMarker(marker.id);
      }

      if (!state || next.value == null) {
        return;
      }

      Future<void> openPoi(String? idStr) async {
        final id = int.tryParse(idStr ?? '');
        if (id == null) {
          return;
        }

        /// TODO(someone): after router fixes use something less crunchy
        router.go(const LandingRoute().location);
        router.push(PoiMapRoute(dgisObjectId: id).location);
      }

      Marker constructMarker(FavouriteItem item, String iconAsset) => Marker(
            id: item.id,
            options: MarkerOptionsMessage(
              position: GeoPointWithElevationMessage(
                latitude: item.coordinates.latitude,
                longitude: item.coordinates.longitude,
                elevation: 0,
              ),
              icon: MarkerIconMessage(
                path: iconAsset,
                width: 24,
              ),
            ),
            onTap: () => openPoi(item.entity?.id),
          );

      _markers = [];
      for (var element in next.value!.items) {
        _markers.add(
          constructMarker(
            element,
            "packages/mapness/assets/icons/svg/ic_fav_pin.svg",
          ),
        );
      }

      if (next.value!.home != null) {
        _markers.add(
          constructMarker(
            next.value!.home!,
            "packages/mapness/assets/icons/svg/ic_home_pin.svg",
          ),
        );
      }

      if (next.value!.work != null) {
        _markers.add(
          constructMarker(
            next.value!.work!,
            "packages/mapness/assets/icons/svg/ic_work_pin.svg",
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

final favouriteMarkersProvider = _favouriteMarkersProvider;
