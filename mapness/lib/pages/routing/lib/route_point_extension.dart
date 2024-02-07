import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_params_point.dart';

extension ToRouteSearchPointMessage on RouteParamsPoint {
  RouteSearchPointMessage get routeSearchPointMessage =>
      RouteSearchPointMessage(
        coordinates: geoPoint,
        objectId: DgisObjectIdMessage(
          objectId: objectId ?? 0,
          entranceId: entraceId ?? 0,
        ),
      );
}
