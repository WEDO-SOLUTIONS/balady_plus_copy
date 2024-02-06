import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/general_card_widget.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

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

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  const PoiMapRoute(
      {required this.dgisObjectId, this.zoom, this.bearing, this.tilt});

  static void open(
    BuildContext context,
    int dgisObjectId, {
    double? zoom,
    double? bearing,
    double? tilt,
  }) {
    final poiMapRoute = PoiMapRoute(
        dgisObjectId: dgisObjectId, zoom: zoom, bearing: bearing, tilt: tilt);
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation == '/poi-map') {
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
        child: GeneralMapCardWidget(
          key: const Key('POI CARD WIDGET'),
          cameraConfig: cameraConfig,
          DgisObjectIdMessage(
            objectId: dgisObjectId,
            entranceId: 0,
          ),
        ),
      );
}

final $poiMapRoutes = $appRoutes;
