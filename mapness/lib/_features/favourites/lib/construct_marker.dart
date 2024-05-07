import 'package:dgis_map/library.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/poi_map.dart';

Marker constructMarker(
    FavouriteItem item, MarkerIconMessage icon, GoRouter router) {
  final position = GeoPointWithElevationMessage(
    latitude: item.coordinates.latitude,
    longitude: item.coordinates.longitude,
    elevation: 1,
  );

  final onTapInsideOnTap = () async {
    final id = int.tryParse(item.entity?.id ?? '');
    if (id == null) {
      return;
    }
    router.go(const LandingRoute().location);
    await router.push(PoiMapRoute(dgisObjectId: id).location);
  };

  return Marker(
    id: item.id,
    options: MarkerOptionsMessage(position: position, icon: icon),
    onTap: onTapInsideOnTap,
  );
}
