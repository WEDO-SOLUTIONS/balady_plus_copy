import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/layers_sheet.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'esri_layers.g.dart';

@TypedGoRoute<EsriLayersRoute>(
  path: EsriLayersRoute.path,
)
class EsriLayersRoute extends GoRouteData {

  const EsriLayersRoute();
  static const path = '/esri-layers';

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static open(BuildContext context) {
    const route = EsriLayersRoute();
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation == path) {
      route.pushReplacement(context);
    } else {
      route.push(context);
    }
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
      child: LayersSheet(
        key: Key('ESRI CARD WIDGET'),
      ),
    );
}

final $layersRoutes = $appRoutes;
