import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';

mixin MapTapGuardMixin {
  bool guardOnSearch(Ref ref) {
    final appRouter = ref.read(appRouterProvider);

    final objectIgnoreRoute = <String>[
      SearchRoute.name,
    ];
    // We don't want to handle tap events when the search is running (for now it is quick search)
    final isQuickSearchRunning = ref.read(searchProvider(SearchScopeEnum.map.value).notifier).isQuickSearchRunning;
    if (isQuickSearchRunning) {
      objectIgnoreRoute.add(PoiCardWidgetRoute.name);
    }

    if (objectIgnoreRoute.any(appRouter.isRouteActive)) {
      return true;
    }
    return false;
  }

  bool guardOnRoute(Ref ref) {
    final appRouter = ref.read(appRouterProvider);
    final objectIgnoreRoute = [
      RoutingMapSelectRoute.name,
      RoutingRoutesRoute.name,
    ];
    if (objectIgnoreRoute.any(appRouter.isRouteActive)) {
      return true;
    }
    return false;
  }
}
