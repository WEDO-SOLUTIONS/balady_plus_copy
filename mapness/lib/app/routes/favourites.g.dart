// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourites.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $favouritesRoute,
    ];

RouteBase get $favouritesRoute => GoRouteData.$route(
      path: '/favourites',
      parentNavigatorKey: FavouritesRoute.$parentNavigatorKey,
      factory: $FavouritesRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'search',
          parentNavigatorKey: FavouritesSearchRoute.$parentNavigatorKey,
          factory: $FavouritesSearchRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'delete_all',
          factory: $FavouritesDeleteAllRouteExtension._fromState,
        ),
      ],
    );

extension $FavouritesRouteExtension on FavouritesRoute {
  static FavouritesRoute _fromState(GoRouterState state) =>
      const FavouritesRoute();

  String get location => GoRouteData.$location(
        '/favourites',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FavouritesSearchRouteExtension on FavouritesSearchRoute {
  static FavouritesSearchRoute _fromState(GoRouterState state) =>
      FavouritesSearchRoute(
        markerType: _$FavouriteItemMarkerTypeEnumMap
            ._$fromName(state.uri.queryParameters['marker-type']!),
      );

  String get location => GoRouteData.$location(
        '/favourites/search',
        queryParams: {
          'marker-type': _$FavouriteItemMarkerTypeEnumMap[markerType],
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

const _$FavouriteItemMarkerTypeEnumMap = {
  FavouriteItemMarkerType.unknown: 'unknown',
  FavouriteItemMarkerType.home: 'home',
  FavouriteItemMarkerType.work: 'work',
  FavouriteItemMarkerType.place: 'place',
};

extension $FavouritesDeleteAllRouteExtension on FavouritesDeleteAllRoute {
  static FavouritesDeleteAllRoute _fromState(GoRouterState state) =>
      FavouritesDeleteAllRoute();

  String get location => GoRouteData.$location(
        '/favourites/delete_all',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) =>
      entries.singleWhere((element) => element.value == value).key;
}
