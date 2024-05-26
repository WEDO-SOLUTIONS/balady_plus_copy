import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_search_point.dart';

extension ToRouteSearchPointMessage on RouteParamsPoint {
  RouteSearchPointMessage get routeSearchPointMessage => RouteSearchPointMessage(
        coordinates: geoPoint,
        objectId: DgisObjectIdMessage(
          objectId: objectId ?? 0,
          entranceId: entraceId ?? 0,
        ),
      );
}

extension toRouteSearchPoint on RouteParamsPoint {
  RouteSearchPoint? get toRouteSearch {
    if (dgisObjectId != null) {
      return RouteSearchPoint(
        coordinates: GeoPointMessage(
          latitude: latitude,
          longitude: longitude,
        ),
        dgisObjectId: dgisObjectId!,
      );
    }
    return null;
  }
}
