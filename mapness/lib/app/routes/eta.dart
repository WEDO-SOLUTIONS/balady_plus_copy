import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/share_eta/eta_route_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'eta.g.dart';

@TypedGoRoute<EtaRoute>(
  path: EtaRoute.path,
)
class EtaRoute extends GoRouteData {
  static const path = '/eta-route';

  static const tokenKey = 'token';
  static const streamKey = 'stream';
  static const latKey = 'lat';
  static const lonKey = 'lon';

  final double? lat;
  final double? lon;

  final String token;
  final String stream;

  const EtaRoute({
    required this.token,
    required this.stream,
    this.lat,
    this.lon,
  });

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: LayoutBuilder(
          builder: (context, constraints) => EtaRoutePage(latitude: lat, longitude: lon),
        ),
      );
}

final $etaRoutes = $appRoutes;
