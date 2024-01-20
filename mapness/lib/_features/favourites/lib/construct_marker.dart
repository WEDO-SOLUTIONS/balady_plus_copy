import 'package:dgis_map/library.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/poi_map.dart';

Marker constructMarker(FavouriteItem item, String iconAsset, GoRouter router) =>
    Marker(
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
      onTap: () async => (String? idStr) async {
        final id = int.tryParse(idStr ?? '');
        if (id == null) {
          return;
        }

        /// TODO(someone): after router fixes use something less crunchy
        router.go(const LandingRoute().location);
        await router.push(PoiMapRoute(dgisObjectId: id).location);
      }(item.entity?.id),
    );
