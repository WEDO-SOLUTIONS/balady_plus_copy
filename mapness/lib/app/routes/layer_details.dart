import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/lifestyle_layers/domain/point_layers_data.dart';
import 'package:mapness/_features/lifestyle_layers/layers_details_widget.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'layer_details.g.dart';

@TypedGoRoute<LayerDetailsRoute>(
  path: '/layer-details',
)
class LayerDetailsRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  LayerDetailsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    var extra = state.extra as Map<String, dynamic>?;
    var data = extra?['data'] as PointLayersData?;
    return TransculentPage(
      child: LayersDetailsWidget(
        data: data,
        key: const Key("LayerDetailsRoute"),
      ),
    );
  }
}

final $layerDetailsRoutes = $appRoutes;
