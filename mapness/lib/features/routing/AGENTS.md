# Routing Notes

This subtree owns route calculation, route state, and route result UI.

## Session Context

The current session touched routing because `Drive back home` enters `RoutingRoutesRoute` and then `PathNavRoute`. Route transition timing was part of the map-only freeze investigation.

Important lifecycle fix from this session: Riverpod lifecycle callbacks must not synchronously read/mutate other providers. Previously `cameraPadding.resetPadding` was called directly from provider `onDispose`, triggering Riverpod assertions like `Cannot use Ref or modify other providers inside life-cycles/selectors`.

## Rules For This Subtree

- Do not call provider mutations directly inside `ref.onDispose`. If cleanup must affect another provider, defer outside the lifecycle callback with a microtask.
- Keep route calculation cancellation subscriptions cancelled in `ref.onDispose`, but avoid touching unrelated provider state synchronously there.
- Before pushing `PathNavRoute`, ensure `currentRouteProvider` and `currentNavigationDestinationProvider` have been set.
- Be careful with `pushAndPopUntil(PathNavRoute, predicate: BottomMenuRoute.name)`: this removes intermediate routing/search routes and can expose Landing/BottomMenu lifecycle races.
- Do not rely on debug-only reproduction for route/sheet races; use profile/release when possible.

## Important Files

- `providers/routes.dart`: route calculation provider and native route params.
- `providers/routes_helper.dart`: routing helper lifecycle cleanup.
- `providers/nearest_object.dart`: provider cleanup around camera padding.
- `providers/current_route.dart`: current route state used by navigation.
- `ui/routing_info.dart`: starts navigation and pushes `PathNavRoute`.

## Verification

```bash
rtk fvm dart format -l 120 mapness/lib/features/routing/providers/routes_helper.dart mapness/lib/features/routing/providers/nearest_object.dart mapness/lib/features/routing/providers/current_route.dart
rtk fvm flutter analyze --no-pub mapness/lib/features/routing/providers/routes_helper.dart mapness/lib/features/routing/providers/nearest_object.dart mapness/lib/features/routing/providers/current_route.dart
```
