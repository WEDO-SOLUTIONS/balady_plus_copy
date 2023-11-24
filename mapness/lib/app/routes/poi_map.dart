import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/general_card_widget.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'poi_map.g.dart';

@TypedGoRoute<PoiMapRoute>(
  path: '/poi-map',
)
class PoiMapRoute extends GoRouteData {
  final int dgisObjectId;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  const PoiMapRoute({required this.dgisObjectId});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return TransculentPage(
      child: GeneralMapCardWidget(
        DgisObjectIdMessage(
          objectId: dgisObjectId,
          entranceId: 0,
        ),
      ),
    );
  }
}

final $poiMapRoutes = $appRoutes;
