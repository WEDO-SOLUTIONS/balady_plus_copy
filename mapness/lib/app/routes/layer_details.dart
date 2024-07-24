import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';
import 'package:mapness/widgets/lifestyle_layers/layers_details_widget.dart';

part 'layer_details.g.dart';

@TypedGoRoute<LayerDetailsRoute>(
  path: LayerDetailsRoute.path,
)
class LayerDetailsRoute extends GoRouteData {
  LayerDetailsRoute();

  static const path = '/layer-details';
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(GoRouter router, PointLayersData e) {
    final layerDetailsRoute = LayerDetailsRoute();
    final location = layerDetailsRoute.location;
    final matches = router.routerDelegate.currentConfiguration.matches;
    final extra = {'data': e};
    if (matches.last.matchedLocation == path) {
      router.pushReplacement(location, extra: extra);
    } else {
      router.push(location, extra: extra);
    }
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final extra = state.extra as Map<String, dynamic>?;
    final data = extra?['data'] as PointLayersData?;
    return TransculentPage(
      child: LayersDetailsWidget(
        data: data,
        key: const Key('LayerDetailsRoute'),
      ),
    );
  }
}

final $layerDetailsRoutes = $appRoutes;
