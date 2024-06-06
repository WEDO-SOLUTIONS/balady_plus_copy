import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/map_search/map_search_sheet.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'search.g.dart';

@TypedGoRoute<SearchRoute>(
  path: '/search',
)
class SearchRoute extends GoRouteData {
  const SearchRoute({
    this.initialQuery,
    this.withClustering = false,
  });

  final String? initialQuery;
  final bool withClustering;

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => TransculentPage(
        child: LayoutBuilder(
          builder: (context, constraints) => MapSearchSheet(
            initialQuery: initialQuery,
            withClustering: withClustering,
            biggestHeight: constraints.biggest.height,
          ),
        ),
      );
}

final $searchRoutes = $appRoutes;
