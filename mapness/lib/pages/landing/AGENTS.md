# Landing Page Notes

This subtree owns the landing page route and its sheet/dashboard integration.

## Session Context

The current session investigated a production/profile-only freeze where Flutter UI disappeared and only the native `DgisMap` stayed visible. Logs implicated Flutter framework tree corruption around `AutoTabsRouter`, `ListenableBuilder`, `InheritedElement.notifyClients`, and render object detach/dropChild assertions.

One critical risk was returning `SizedBox.shrink()` from `LandingPage` when another route covers it. That destroys/deactivates the landing subtree while the route stack and sheet controllers are still active. In this app, `MapPage` keeps the native map below `AutoRouter`; if the Flutter overlay route tree gets into a bad state, the map remains visible while UI disappears.

## Rules For This Subtree

- When a route covers Landing, keep the landing subtree mounted. Prefer `Offstage` + `TickerMode` + `IgnorePointer` over returning `SizedBox.shrink()`.
- Do not dispose/recreate dashboard/sheet/listener subtrees merely because `didPushNext` fired.
- Maintain `AutoRouteAwareStateMixin` lifecycle carefully: route-covered state should only affect visibility and input, not subtree identity.
- Keep camera padding recalculation after `didPopNext`, but guard with `mounted`.
- Avoid synchronous mutations from sheet listeners that can invalidate provider/build state during route transitions.

## Important Files

- `landing_page.dart`: route-aware Landing subtree, sheet overlay visibility, camera padding.
- `landing_page_bottom_sheet_controller.dart`: bottom sheet controller provider used by BottomMenu/Landing.

## Verification

```bash
rtk fvm dart format -l 120 mapness/lib/pages/landing/landing_page.dart
rtk fvm flutter analyze --no-pub mapness/lib/pages/landing/landing_page.dart
```
