import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_search_point.dart';

extension RouteSearchPointMapper on RouteSearchPoint {
  RouteSearchPointMessage toMessage() => RouteSearchPointMessage(
        coordinates: coordinates,
        objectId: dgisObjectId,
        course: course,
        levelId: levelId,
      );
}

extension DirectoryObjectMessageMapper on DirectoryObjectMessage {
  RouteParamsPoint toRouteParamsPoint() => RouteParamsPoint(
        latitude: markerPosition!.latitude,
        longitude: markerPosition!.longitude,
        objectId: id?.objectId,
        entranceId: id?.entranceId,
        levelId: levelId,
      );

  RouteParamsPointWithLabel toRouteParamsPointWithLabel() => RouteParamsPointWithLabel(
        label: title,
        value: toRouteParamsPoint(),
      );
}
