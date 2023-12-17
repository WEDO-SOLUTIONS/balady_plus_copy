// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $weatherRoute,
    ];

RouteBase get $weatherRoute => GoRouteData.$route(
      path: '/weather',
      parentNavigatorKey: WeatherRoute.$parentNavigatorKey,
      factory: $WeatherRouteExtension._fromState,
    );

extension $WeatherRouteExtension on WeatherRoute {
  static WeatherRoute _fromState(GoRouterState state) => const WeatherRoute();

  String get location => GoRouteData.$location(
        '/weather',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
