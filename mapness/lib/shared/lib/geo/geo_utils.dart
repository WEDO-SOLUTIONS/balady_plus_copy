import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';

import 'package:mapness/shared/lib/common_functions.dart';

double _distanceToZoom(
    (List<(double, double)> coordinates, (double, double) position) data,) {
  var minDistance = double.infinity;
  for (final coordinate in data.$1) {
    final distance = CommonFunctions.distance(
      coordinate.$1,
      coordinate.$2,
      data.$2.$1,
      data.$2.$2,
    );
    if (distance < minDistance) {
      minDistance = distance;
    }
  }

  if (minDistance < 1) {
    return 15;
  } else if (minDistance < 5) {
    return 13;
  } else if (minDistance < 10) {
    return 11;
  } else if (minDistance < 20) {
    return 9;
  }
  return 7;
}

class GeoUtils {
  static Future<double> distanceToZoom(
          List<(double, double)> coordinates, (double, double) position,) =>
      compute(_distanceToZoom, (coordinates, position));

  static Future<double> zoomByMarkersNearby(
      {required List<Marker> markers,
      required GeoPointMessage position,}) async {
    final coord = markers.map((e) {
      final position = e.options.position;
      return (position.latitude, position.longitude);
    }).toList();

    final pos = (position.latitude, position.longitude);

    return markers.isEmpty ? 7.0 : await distanceToZoom(coord, pos);
  }

  static List<DistanceRequestMessage> mapToDistanceRequest(
          List<DirectoryObjectMessage> values,) =>
      values
          .where((e) => e.id != null && e.markerPosition != null)
          .map(
            (e) => DistanceRequestMessage(
              geoPoint: GeoPointMessage(
                latitude: e.markerPosition!.latitude,
                longitude: e.markerPosition!.longitude,
              ),
              dgisObjectId: e.id,
            ),
          )
          .toList();

  static List<RouteSearchPointMessage> mapToRoutPoint(
          List<DirectoryObjectMessage?> values,) =>
      values
          .where((e) => e?.id != null && e?.markerPosition != null)
          .map(
            (e) => RouteSearchPointMessage(
              coordinates: GeoPointMessage(
                latitude: e!.markerPosition!.latitude,
                longitude: e.markerPosition!.longitude,
              ),
              objectId: e.id!,
            ),
          )
          .toList();
}
