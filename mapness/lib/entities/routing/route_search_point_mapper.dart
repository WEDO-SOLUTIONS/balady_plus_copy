import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_search_point.dart';

extension RouteSearchPointMapper on RouteSearchPoint {
  RouteSearchPointMessage toMessage() => RouteSearchPointMessage(
        coordinates: coordinates,
        objectId: dgisObjectId,
        course: course,
        levelId: levelId,
      );
}
