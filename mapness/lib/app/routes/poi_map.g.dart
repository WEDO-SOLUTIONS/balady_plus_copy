// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi_map.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $poiMapRoute,
    ];

RouteBase get $poiMapRoute => GoRouteData.$route(
      path: '/poi-map',
      parentNavigatorKey: PoiMapRoute.$parentNavigatorKey,
      factory: $PoiMapRouteExtension._fromState,
    );

extension $PoiMapRouteExtension on PoiMapRoute {
  static PoiMapRoute _fromState(GoRouterState state) => PoiMapRoute(
        dgisObjectId: int.parse(state.uri.queryParameters['dgis-object-id']!),
      );

  String get location => GoRouteData.$location(
        '/poi-map',
        queryParams: {
          'dgis-object-id': dgisObjectId.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
