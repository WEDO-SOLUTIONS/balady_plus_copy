import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/favourites.dart';
import 'package:mapness/_features/favourites/favourites_picker.dart';
import 'package:mapness/_features/favourites/favourites_search.dart';
import 'package:mapness/_features/favourites/widgets/delete_all/delete_all_content.dart';
import 'package:mapness/app/routes/routes.dart';

import '../../features/search/ui/search_scope.dart';

part 'favourites.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@TypedGoRoute<FavouritesRoute>(
  path: '/favourites',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<FavouritesSearchRoute>(
      path: 'search',
    ),
    TypedGoRoute<FavouritesDeleteAllRoute>(
      path: 'delete_all',
    ),
    TypedGoRoute<FavouritesPickerRoute>(path: 'picker')
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
  Widget build(BuildContext context, GoRouterState state) => SearchScope(
      named: 'MapSearch',
      child: FavouritesSearch(
            markerType: FavouriteItemMarkerType.values.firstWhere(
          (element) => element.name == state.uri.queryParameters['marker-type'],
          orElse: () => FavouriteItemMarkerType.place,
        )),
    );
}

class FavouritesDeleteAllRoute extends GoRouteData {
  // static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<bool> buildPage(BuildContext context, GoRouterState state) =>
      CustomTransitionPage(
        child: DeleteAllContent(
          onConfirm: () => context.pop(true),
          onCancel: () => context.pop(false),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      );

  Future<bool?> push(BuildContext context) => context.push<bool>(location);
}

class FavouritesPickerRoute extends GoRouteData {
  const FavouritesPickerRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FavouritesPicker();
}

final $favouritesRoutes = $appRoutes;
