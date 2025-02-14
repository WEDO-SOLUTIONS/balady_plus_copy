part of 'map_tap_handler_provider.dart';

mixin GuardTapEventMixin on _$MapTapHandler {
  /// Processes map tap events if no priority handler is set,
  /// including navigation and metrics logging.
  bool _guardOfDefaultTap() {
    final appRouter = ref.read(appRouterProvider);

    // We don't want to handle tap events when the search is running (for now it is quick search)
    final isQuickSearchRunning = ref.read(searchProvider(SearchScopeEnum.map.value).notifier).isQuickSearchRunning;
    final objectIgnoreRoute = [
      RoutingMapSelectRoute.name,
      SearchRoute.name,
      RoutingRoutesRoute.name,
    ];
    if (isQuickSearchRunning) {
      objectIgnoreRoute.add(PoiCardWidgetRoute.name);
    }

    if (objectIgnoreRoute.any(appRouter.isRouteActive)) {
      return true;
    }
    return false;
  }
}
