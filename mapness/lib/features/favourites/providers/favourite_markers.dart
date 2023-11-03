// import 'package:collection/collection.dart';
// import 'package:dgis_map/library.dart';
// import 'package:mapness/features/favourites/providers/favourite_items.dart';
// import 'package:mapness/features/map/providers/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_markers.g.dart';

@riverpod
class FavouriteMarkers extends _$FavouriteMarkers {
  void enable() {
    state = true;
  }

  void disable() {
    state = false;
  }

  void toggle() {
    state = !state;
  }

  @override
  bool build() {
    // final dgisController = ref.watch(dgisControllerProvider);
    // ref.listen(favouriteItemsProvider.select((value) => value.items),
    //     (oldValue, newValue) async {
    //   if (_showOnMap) {
    //     final difference = newValue
    //         .whereNot((element) => oldValue?.contains(element) ?? false)
    //         .toList();
    //     final markers = difference
    //         .map(
    //           (e) => Marker(
    //             id: e.id,
    //             options: MarkerOptionsMessage(
    //               position: GeoPointWithElevationMessage(
    //                 latitude: 0,
    //                 longitude: 0,
    //                 elevation: 0,
    //               ),
    //               icon: MarkerIconMessage(
    //                 path: "packages/mapness/assets/icons/svg/ic_marker.svg",
    //                 width: 24,
    //               ),
    //             ),
    //             onTap: () {
    //               // TODO(Demezy): add something
    //             },
    //           ),
    //         )
    //         .toList();
    //     await dgisController?.addMarkers(markers);
    //   } else {
    //     await dgisController?.removeAllMarkers();
    //   }
    // });

    // TODO: take data from prefs
    return false;
  }
}
