// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_nav.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $pathNavRoute,
    ];

RouteBase get $pathNavRoute => GoRouteData.$route(
      path: '/pathNav',
      parentNavigatorKey: PathNavRoute.$parentNavigatorKey,
      factory: $PathNavRouteExtension._fromState,
    );

extension $PathNavRouteExtension on PathNavRoute {
  static PathNavRoute _fromState(GoRouterState state) => const PathNavRoute();

  String get location => GoRouteData.$location(
        '/pathNav',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
