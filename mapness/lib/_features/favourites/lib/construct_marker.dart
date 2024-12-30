import 'package:dgis_map/library.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';

Marker constructMarker(FavouriteItem item, MarkerIconMessage icon, AppRouter router) {
  final position = GeoPointWithElevationMessage(
    latitude: item.coordinates.latitude,
    longitude: item.coordinates.longitude,
    elevation: 1,
  );

  final onTapInsideOnTap = () {
    final id = int.tryParse(item.entity?.id ?? '');
    if (id == null) {
      return;
    }
    router.replaceOrPush(
      route: PoiCardWidgetRoute(
        objectId: DgisObjectIdMessage(
          objectId: id,
          entranceId: 0,
        ),
      ),
      toCompareRoutes: [PoiCardWidgetRoute.page],
    );
  };

  return Marker(
    id: item.id,
    options: MarkerOptionsMessage(position: position, icon: icon),
    onTap: onTapInsideOnTap,
  );
}
