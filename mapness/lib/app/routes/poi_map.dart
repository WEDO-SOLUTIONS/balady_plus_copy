import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/my_location_poi/content_deeplink.dart';
import 'package:mapness/features/poi_card/poi_card_widget.dart';
import 'package:mapness/features/share_eta/ui/share_my_location_content.dart';
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

  /// Open PoiMapRoute. Because [dgisObjectId] is required, to open this route you need to provide it.
  /// So if we want to open my location or deeplink location:
  /// `dgisObjectId = -1` - for my location
  /// `dgisObjectId = -2` - for deeplink location for other person
  ///
  /// [zoom], [bearing], [tilt] - camera settings
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
    if (PoiMapRoute.isSameRoute(router)) {
      router.pushReplacement(poiMapRoute.location);
    } else {
      router.push(poiMapRoute.location);
    }
  }

  static bool isSameRoute(GoRouter router) {
    final matches = router.routerDelegate.currentConfiguration.matches;
    return matches.last.matchedLocation.contains(IwishCardRoute.path) ||
        matches.last.matchedLocation == (PoiMapRoute.path);
  }

  PoiCameraConfig? get cameraConfig => zoom != null || bearing != null || tilt != null
      ? PoiCameraConfig(
          zoom: zoom,
          bearing: bearing,
          tilt: tilt,
        )
      : null;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final closestPoint = lat != null && lng != null
        ? LatLng(
            latitude: lat!,
            longitude: lng!,
          )
        : null;
    if (dgisObjectId == -1) {
      return TransculentPage(
        name: path,
        child: ShareMyLocationContent(
          key: const Key('POI MY LOCATION CARD WIDGET'),
          cameraConfig: cameraConfig,
          closestPoint: closestPoint,
        ),
      );
    } else if (dgisObjectId == -2) {
      return TransculentPage(
        name: path,
        child: ContentDeeplink(
          key: const Key('POI OTHER LOCATION CARD WIDGET'),
          cameraConfig: cameraConfig,
          closestPoint: closestPoint,
        ),
      );
    }
    return TransculentPage(
      name: path,
      child: PoiCardWidget(
        key: const Key('POI CARD WIDGET'),
        cameraConfig: cameraConfig,
        objectId: DgisObjectIdMessage(
          objectId: dgisObjectId,
          entranceId: 0,
        ),
        closestPoint: closestPoint,
      ),
    );
  }
}

final $poiMapRoutes = $appRoutes;
