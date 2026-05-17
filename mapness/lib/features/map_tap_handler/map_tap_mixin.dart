part of 'map_tap_handler_provider.dart';

mixin GuardTapEventMixin on _$MapTapHandler {
  static final Object _legacyTapDisableOwner = Object();
  final Set<Object> _tapDisableOwners = <Object>{};

  /// Disables the default tap handler for a specific owner.
  ///
  /// The returned token must be released by [releaseTapDisableOwner]. This keeps
  /// multiple screens from racing on one global boolean and leaving the map
  /// permanently non-interactive.
  Object acquireTapDisableOwner() {
    final owner = Object();
    _tapDisableOwners.add(owner);
    return owner;
  }

  void releaseTapDisableOwner(Object? owner) {
    if (owner == null) {
      return;
    }
    _tapDisableOwners.remove(owner);
  }

  /// Legacy compatibility for existing call sites.
  ///
  /// Prefer [acquireTapDisableOwner]/[releaseTapDisableOwner] for new code.
  // ignore: avoid_setters_without_getters
  set disableTapOnMap(bool value) {
    if (value) {
      _tapDisableOwners.add(_legacyTapDisableOwner);
    } else {
      _tapDisableOwners.remove(_legacyTapDisableOwner);
    }
  }

  bool get isDisabledTapHandler => _tapDisableOwners.isNotEmpty;

  void _clearTapDisableOwners() {
    _tapDisableOwners.clear();
  }

  /// Processes map tap events if no priority handler is set,
  /// including navigation and metrics logging.
  void _guardDefaultTap(void Function() action) {
    final appRouter = ref.read(appRouterProvider);

    // We don't want to handle tap events when the search is running (for now it is quick search)
    final isQuickSearchRunning = ref.read(searchProvider(SearchScopeEnum.map.value).notifier).isQuickSearchRunning;
    final objectIgnoreRoute = [RoutingMapSelectRoute.name, SearchRoute.name];
    if (isQuickSearchRunning) {
      objectIgnoreRoute.add(PoiCardWidgetRoute.name);
    }

    final shouldBeIgnored = objectIgnoreRoute.any(appRouter.isRouteActive);
    if (!shouldBeIgnored) {
      action();
    }
  }
}
