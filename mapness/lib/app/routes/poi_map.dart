import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/content_my_location.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/poi_card_widget.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'poi_map.g.dart';

@TypedGoRoute<PoiMapRoute>(
  path: PoiMapRoute.path,
)
class PoiMapRoute extends GoRouteData {
  const PoiMapRoute({
    required this.dgisObjectId,
    this.zoom,
    this.bearing,
    this.tilt,
    this.lat,
    this.lng,
  });
  static const path = '/poi-map';
  final int dgisObjectId;
  final double? zoom;
  final double? bearing;
  final double? tilt;
  final double? lat;
  final double? lng;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(
    GoRouter router,
    int dgisObjectId, {
    double? zoom,
    double? bearing,
    double? tilt,
    LatLng? latLng,
  }) {
    final poiMapRoute = PoiMapRoute(
      dgisObjectId: dgisObjectId,
      zoom: zoom,
      bearing: bearing,
      tilt: tilt,
      lat: latLng?.latitude,
      lng: latLng?.longitude,
    );
    // final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation.contains(IwishCardRoute.path) ||
        matches.last.matchedLocation == (PoiMapRoute.path)) {
      router.pushReplacement(poiMapRoute.location);
    } else {
      router.push(poiMapRoute.location);
    }
  }

  PoiCameraConfig? get cameraConfig =>
      zoom != null || bearing != null || tilt != null
          ? PoiCameraConfig(
              zoom: zoom,
              bearing: bearing,
              tilt: tilt,
            )
          : null;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final closesPoint = lat != null && lng != null
        ? LatLng(
            latitude: lat!,
            longitude: lng!,
          )
        : null;
    if (dgisObjectId == -1) {
      return TransculentPage(
        child: ContentMyLocation(
          theme: Theme.of(context),
          key: const Key('POI MY LOCATION CARD WIDGET'),
          closestPoint: closesPoint,
        ),
      );
    }
    return TransculentPage(
      child: PoiCardWidget(
        key: const Key('POI CARD WIDGET'),
        cameraConfig: cameraConfig,
        objectId: DgisObjectIdMessage(
          objectId: dgisObjectId,
          entranceId: 0,
        ),
        closestPoint: closesPoint,
      ),
    );
  }
}

final $poiMapRoutes = $appRoutes;
