// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layer_details.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $layerDetailsRoute,
    ];

RouteBase get $layerDetailsRoute => GoRouteData.$route(
      path: '/layer-details',
      parentNavigatorKey: LayerDetailsRoute.$parentNavigatorKey,
      factory: $LayerDetailsRouteExtension._fromState,
    );

extension $LayerDetailsRouteExtension on LayerDetailsRoute {
  static LayerDetailsRoute _fromState(GoRouterState state) =>
      LayerDetailsRoute();

  String get location => GoRouteData.$location(
        '/layer-details',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
