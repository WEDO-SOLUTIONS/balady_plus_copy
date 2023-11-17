import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/favourites.dart';
import 'package:mapness/_features/favourites/favourites_search.dart';
import 'package:mapness/app/routes/routes.dart';

part 'favourites.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@TypedGoRoute<FavouritesRoute>(
  path: '/favourites',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<FavouritesSearchRoute>(
      path: 'search',
    ),
  ],
)
class FavouritesRoute extends GoRouteData {
  const FavouritesRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => const Favourites();
}

class FavouritesSearchRoute extends GoRouteData {
  final FavouriteItemMarkerType markerType;

  const FavouritesSearchRoute({required this.markerType});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => FavouritesSearch(
          markerType: FavouriteItemMarkerType.values.firstWhere(
        (element) => element.name == state.uri.queryParameters['marker-type'],
        orElse: () => FavouriteItemMarkerType.place,
      ));
}

final $favouritesRoutes = $appRoutes;
