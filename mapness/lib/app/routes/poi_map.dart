import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/poi_card_widget.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

import 'iwish.dart';

part 'poi_map.g.dart';

@TypedGoRoute<PoiMapRoute>(
  path: PoiMapRoute.path,
)
class PoiMapRoute extends GoRouteData {
  static const path = '/poi-map';
  final int dgisObjectId;
  final double? zoom;
  final double? bearing;
  final double? tilt;
  final double? lat;
  final double? lng;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  const PoiMapRoute({
    required this.dgisObjectId,
    this.zoom,
    this.bearing,
    this.tilt,
    this.lat,
    this.lng,
  });

  static void open(
    BuildContext context,
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
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation.contains(IwishCardRoute.path) ||
        matches.last.matchedLocation == (PoiMapRoute.path)) {
      poiMapRoute.pushReplacement(context);
    } else {
      poiMapRoute.push(context);
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
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      TransculentPage(
        child: PoiCardWidget(
          key: const Key('POI CARD WIDGET'),
          cameraConfig: cameraConfig,
          objectId: DgisObjectIdMessage(
            objectId: dgisObjectId,
            entranceId: 0,
          ),
          closestPoint: lat != null && lng != null
              ? LatLng(
                  latitude: lat!,
                  longitude: lng!,
                )
              : null,
        ),
      );
}

final $poiMapRoutes = $appRoutes;
