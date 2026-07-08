import 'package:dgis_map/library.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/entities/routing/route_search_point_mapper.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'car_route_estimate.g.dart';

/// Duration (in seconds) of the car route to [finishPoint], or `null` when it
/// cannot be determined.
///
/// The SDK "brief route" lookup ([DgisMapController.findBriefRouteInfos]) is
/// fast but returns nothing for far destinations (roughly farther than ~1h
/// away). That used to leave the car icon with a blank ETA (HB-134). When the
/// brief lookup yields no result we fall back to a full [findRoute]
/// calculation, which handles long routes, so an ETA is available for far
/// destinations too.
@riverpod
Future<double?> carRouteEstimateSeconds(
  Ref ref, {
  required RouteSearchPoint finishPoint,
}) async {
  final controller = await ref.watch(dgisControllerProvider.future);

  // Primary: brief route info. Omitting startPoint makes the SDK use the
  // current location as the origin.
  try {
    final brief = await controller.findBriefRouteInfos(
      options: RouteSearchOptionsMessage.car,
      finishPoint: finishPoint.toMessage(),
    );
    final first = brief.whereType<BriefRouteInfoMessage>().firstOrNull;
    if (first != null) {
      return first.duration;
    }
  } catch (_) {
    // Ignore and try the full-route fallback below.
  }

  // Fallback: full route calculation. Unlike the brief lookup, findRoute
  // requires an explicit start point, so we build one from the current
  // location.
  final location = ref.read(locationProvider);
  if (location == null) {
    return null;
  }
  final startPoint = RouteSearchPointMessage(
    coordinates: GeoPointMessage(
      latitude: location.latitude,
      longitude: location.longitude,
    ),
    objectId: DgisObjectIdMessage(objectId: 0, entranceId: 0),
  );
  try {
    final result = await controller.findRoute(
      options: RouteSearchOptionsMessage.car,
      startPoint: startPoint,
      finishPoint: finishPoint.toMessage(),
    );
    return result.routes.firstOrNull?.duration;
  } catch (_) {
    return null;
  }
}
