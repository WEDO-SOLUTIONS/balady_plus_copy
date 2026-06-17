# Shared Map Providers Notes

This subtree contains map controller/provider integration used across landing, routing, navigation, favourites, and location.

## Session Context

The current session fixed multiple Riverpod/map lifecycle hazards observed in logs:

- `Cannot use the Ref ... after it has been disposed` from async provider continuations.
- Riverpod assertion about using `Ref` inside lifecycle/selectors.
- Map-only UI freeze symptoms where native `DgisMap` remained visible after Flutter overlay tree failed.

## Rules For This Subtree

- After async gaps in providers/notifiers, check `ref.mounted` before writing `state` or reading provider state.
- For overlapping async requests, use a request id/generation guard and only apply the latest result.
- Do not mutate provider state from disposed providers. If a provider rebuilds while the previous async operation is pending, the previous operation must become a no-op.
- Do not call `ref.read`/state changes synchronously inside `ref.onDispose`.
- `camera_padding.dart` should guard `setPadding`/`resetPadding` with `ref.mounted`.
- `dgis_controller.dart` intentionally uses a top-level `activeDgisController` to avoid Riverpod graph cycles with location/dark-mode/map setup. Do not replace it with a provider dependency without re-checking cycles.
- `DgisController.onMapCreated` publishes `activeDgisController` before long async initialization because location setup may need the native controller while Riverpod graph is still settling.
- `DgisController` owns indoor floor-plan zoom gating. It calls `setIndoorFloorPlansEnabled(enabled: false)` during map setup and toggles the native bridge from the debounced `visibleRectEvents` stream when zoom crosses `_indoorFloorPlansMinZoom`.
- The current floor-plan threshold is `19`, matching the "penultimate" zoom level before the bridge's default max zoom `20`. If zoom restrictions change, revisit this threshold instead of scattering another constant.

## Important Files

- `dgis_controller.dart`: native map controller lifecycle and visible rect stream.
- `camera_padding.dart`: camera padding state and native updates.
- `find_brief_route_info_v2.dart`: async route info provider; use mounted/request id guards.
- `object_manager.dart`: map object manager state used by dashboard/routing/favourites.

## Verification

```bash
rtk fvm dart format -l 120 mapness/lib/shared/providers/map/camera_padding.dart mapness/lib/shared/providers/map/find_brief_route_info_v2.dart mapness/lib/shared/providers/map/dgis_controller.dart
rtk fvm flutter analyze --no-pub mapness/lib/shared/providers/map/camera_padding.dart mapness/lib/shared/providers/map/find_brief_route_info_v2.dart mapness/lib/shared/providers/map/dgis_controller.dart
```
