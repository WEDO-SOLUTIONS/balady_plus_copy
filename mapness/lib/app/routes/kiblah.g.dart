// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiblah.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $kiblahRoute,
    ];

RouteBase get $kiblahRoute => GoRouteData.$route(
      path: '/kiblah',
      parentNavigatorKey: KiblahRoute.$parentNavigatorKey,
      factory: $KiblahRouteExtension._fromState,
    );

extension $KiblahRouteExtension on KiblahRoute {
  static KiblahRoute _fromState(GoRouterState state) => const KiblahRoute();

  String get location => GoRouteData.$location(
        '/kiblah',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
