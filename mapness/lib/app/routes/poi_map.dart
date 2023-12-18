import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  const PoiMapRoute({required this.dgisObjectId});

  static open(BuildContext context, int dgisObjectId) {
    final poiMapRoute = PoiMapRoute(dgisObjectId: dgisObjectId);
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation == '/poi-map') {
      poiMapRoute.pushReplacement(context);
    } else {
      poiMapRoute.push(context);
    }
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return TransculentPage(
      child: GeneralMapCardWidget(
        key: const Key("POI CARD WIDGET"),
        DgisObjectIdMessage(
          objectId: dgisObjectId,
          entranceId: 0,
        ),
      ),
    );
  }
}

final $poiMapRoutes = $appRoutes;
