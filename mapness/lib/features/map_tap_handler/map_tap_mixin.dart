part of 'map_tap_handler_provider.dart';

mixin GuardTapEventMixin on _$MapTapHandler {
  bool _isDisabledTapHandler = false;

  /// Disables the default tap handler, preventing it from being called.
  // ignore: avoid_setters_without_getters
  set disableTapOnMap(bool value) => _isDisabledTapHandler = value;

  bool get isDisabledTapHandler => _isDisabledTapHandler;

  /// Processes map tap events if no priority handler is set,
  /// including navigation and metrics logging.
  void _guardDefaultTap(void Function() action) {
    final appRouter = ref.read(appRouterProvider);

    // We don't want to handle tap events when the search is running (for now it is quick search)
    final isQuickSearchRunning = ref.read(searchProvider(SearchScopeEnum.map.value).notifier).isQuickSearchRunning;
    // BALADY-3565: SearchRoute removed from the ignore list so that
    // tapping a POI marker while the search sheet is open opens the
    // POI card instead of being silently dropped.
    final objectIgnoreRoute = [RoutingMapSelectRoute.name];
    if (isQuickSearchRunning) {
      objectIgnoreRoute.add(PoiCardWidgetRoute.name);
    }

    final shouldBeIgnored = objectIgnoreRoute.any(appRouter.isRouteActive);
    if (!shouldBeIgnored) {
      action();
    }
  }
}
