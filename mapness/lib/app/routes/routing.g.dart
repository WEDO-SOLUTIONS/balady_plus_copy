// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routing.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $routingSearchRoute,
      $routingFavouritesRoute,
      $routingRoutesRoute,
    ];

RouteBase get $routingSearchRoute => GoRouteData.$route(
      path: '/routingSearch',
      parentNavigatorKey: RoutingSearchRoute.$parentNavigatorKey,
      factory: $RoutingSearchRouteExtension._fromState,
    );

extension $RoutingSearchRouteExtension on RoutingSearchRoute {
  static RoutingSearchRoute _fromState(GoRouterState state) =>
      RoutingSearchRoute(
        placeholder: state.uri.queryParameters['placeholder']!,
        showMyLocation:
            _$boolConverter(state.uri.queryParameters['show-my-location']!),
      );

  String get location => GoRouteData.$location(
        '/routingSearch',
        queryParams: {
          'placeholder': placeholder,
          'show-my-location': showMyLocation.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

RouteBase get $routingFavouritesRoute => GoRouteData.$route(
      path: '/routingFavourites',
      parentNavigatorKey: RoutingFavouritesRoute.$parentNavigatorKey,
      factory: $RoutingFavouritesRouteExtension._fromState,
    );

extension $RoutingFavouritesRouteExtension on RoutingFavouritesRoute {
  static RoutingFavouritesRoute _fromState(GoRouterState state) =>
      RoutingFavouritesRoute();

  String get location => GoRouteData.$location(
        '/routingFavourites',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $routingRoutesRoute => GoRouteData.$route(
      path: '/routingRoutes',
      parentNavigatorKey: RoutingRoutesRoute.$parentNavigatorKey,
      factory: $RoutingRoutesRouteExtension._fromState,
    );

extension $RoutingRoutesRouteExtension on RoutingRoutesRoute {
  static RoutingRoutesRoute _fromState(GoRouterState state) =>
      RoutingRoutesRoute(
        startLatitude: _$convertMapValue(
            'start-latitude', state.uri.queryParameters, double.parse),
        startLongitude: _$convertMapValue(
            'start-longitude', state.uri.queryParameters, double.parse),
        startLabel: state.uri.queryParameters['start-label']!,
        finishLatitude: _$convertMapValue(
            'finish-latitude', state.uri.queryParameters, double.parse),
        finishLongitude: _$convertMapValue(
            'finish-longitude', state.uri.queryParameters, double.parse),
        finishLabel: state.uri.queryParameters['finish-label']!,
      );

  String get location => GoRouteData.$location(
        '/routingRoutes',
        queryParams: {
          if (startLatitude != null)
            'start-latitude': startLatitude!.toString(),
          if (startLongitude != null)
            'start-longitude': startLongitude!.toString(),
          'start-label': startLabel,
          if (finishLatitude != null)
            'finish-latitude': finishLatitude!.toString(),
          if (finishLongitude != null)
            'finish-longitude': finishLongitude!.toString(),
          'finish-label': finishLabel,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}
