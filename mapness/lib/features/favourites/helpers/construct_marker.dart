import 'package:dgis_map/library.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/features/favorite_lists/data/models/map_marker_dto.dart';
import 'package:mapness/features/favourites/helpers/favourite_entity_id.dart';

Marker constructMarker(FavouriteItem item, MarkerIconMessage icon, AppRouter router) {
  final position = GeoPointWithElevationMessage(
    latitude: item.coordinates.latitude,
    longitude: item.coordinates.longitude,
    elevation: 1,
  );

  final onTapInsideOnTap = () {
    final id = parseObjectIdFromFavouriteEntityId(item.entity?.id);
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

Marker constructFavoriteListPlaceMarker(
  MapMarkerDto marker,
  GeoPointWithElevationMessage position,
  String title,
  MarkerIconMessage icon,
  AppRouter router,
) {
  final objectId = int.tryParse(marker.placeId);

  return Marker(
    id: 'favorite-list-place-${marker.placeId}',
    options: MarkerOptionsMessage(position: position, icon: icon, text: title),
    onTap: objectId == null
        ? null
        : () => router.replaceOrPush(
            route: PoiCardWidgetRoute(objectId: DgisObjectIdMessage(objectId: objectId, entranceId: 0)),
            toCompareRoutes: [PoiCardWidgetRoute.page],
          ),
  );
}
