import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/widgets/path_nav/lib/utils.dart';

extension ToRouteSearchPointMessage on RouteParamsPoint {
  RouteSearchPointMessage get routeSearchPointMessage => RouteSearchPointMessage(
    coordinates: geoPoint,
    objectId: DgisObjectIdMessage(
      objectId: objectId ?? 0,
      entranceId: entranceId ?? 0,
    ),
  );
}

extension ToRouteSearchPoint on RouteParamsPoint {
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

extension PedestrianDuration on BriefPublicTransportModel {
  int durationInMinutes() {
    int duration = 0;
    for (var i = 0; i < publicTransportTransferRouteLongEntry.length; i++) {
      final pub = publicTransportTransferRouteLongEntry[i];
      final isPedestrian = pub.value.routeParts.isEmpty;
      if (isPedestrian) {
        duration += durationByFoot(pub.length.millimeters);
      }
    }
    return duration;
  }
}
