import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/weather/weather_page.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'weather.g.dart';

@TypedGoRoute<WeatherRoute>(
  path: '/weather',
)
class WeatherRoute extends GoRouteData {

  const WeatherRoute();
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
      child: WeatherPage(),
    );
}

final $weatherRoutes = $appRoutes;
