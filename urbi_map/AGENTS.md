# urbi_map Notes

This subtree owns the Flutter/native map bridge packages.

## Session Context

- Indoor floor-plan visibility is exposed to Flutter via `setIndoorFloorPlansEnabled`.
- The Pigeon source is `dgis_map_platform_interface/pigeons/messages.dart`; generated outputs are produced by running `fvm dart pub run pigeon --input pigeons/messages.dart` from `urbi_map/dgis_map_platform_interface/`. The just-recipe `just build_pigeon` wraps the same command plus `pub get` for both packages.
- The public Dart wrappers are `dgis_map_platform_interface/lib/src/dgis_map_plugin.dart` and `dgis_map/lib/dgis_map_controller.dart`.
- Android maps the bridge method to `map.indoorManager.setIndoorState(IndoorManagerState.ENABLED/DISABLED)`.
- iOS maps the bridge method to `map.indoorManager.setIndoorState(newState: .enabled/.disabled)`.
- Native `DgisMapView` implementations should handle calls before `IndoorControlHandler` is initialized by falling back to `map.indoorManager` directly.

## Known bug fixed 2026-09-13: `setMarkerOptions` never completed

`ObjectTapHandler.swift` (iOS) and `ObjectTapHandler.kt` (Android)'s `setMarkerOptions` never called their `completion`/`callback` on the success path — every sibling marker method (`addMarker`, `addMarkers`, `removeMarker`) does, `setMarkerOptions` alone didn't. Since Pigeon platform-channel calls only resolve their Dart-side `Future` when the native completion fires, **every Dart-side `await ... setMarkerOptions(...)` call hung forever, silently, no exception, no timeout** — for every caller of this method, on both platforms, since it was written. It went unnoticed because no existing caller (`founding_day.dart`, `leap.dart`, `cityscape.dart`, `wrc.dart`) awaited it in a sequential loop over multiple markers; Friends on Map's periodic marker-label refresh (`mapness/lib/features/friends_on_map/providers/friend_markers.dart`) was the first caller shaped that way, which is what exposed it — only the first marker in a loop ever got updated (its field mutations apply synchronously regardless of `completion`), every marker after it silently never got its turn.

**Fixed**: added the missing `completion(Result.success(()))` (iOS) / `callback(Result.success(Unit))` (Android) at the end of `setMarkerOptions`, guarded so it isn't called a *second* time when an icon-load failure already invoked completion internally (mirrors the `guard let ... else { return }` pattern `addMarker`/`mapMarker` use for the same reason — check `markerImage == nil` while an icon change was actually requested, since a genuine "no icon change requested" case must not be mistaken for a failed one).

If you add a new marker-mutation bridge method here, verify by grepping this file for every early-return/failure path and confirming each one calls its completion exactly once — this exact class of bug (a forgotten success-path completion call) is easy to introduce and, per this incident, can go unnoticed for a long time since a hung `Future` throws nothing.

## Bridges (Pigeon → Native Handler)

| Pigeon method | Message | Android handler | iOS handler | Notes |
|---|---|---|---|---|
| `toggleHeatmap` | `WeatherMapMessage` | `WeatherHandler.kt` | `WeatherHandler.swift` | Weather temp/precip raster overlay (Meteoblue). Switches by `WeatherMapType`. |
| `toggleSatellite` | `SatelliteMapMessage` | `SatelliteHandler.kt` | `SatelliteHandler.swift` | Satellite base-map raster overlay. **Separate** from weather to avoid coupling. |
| `setIndoorFloorPlansEnabled` | `bool` | `map.indoorManager` | `map.indoorManager` | Zoom-gated floor-plan visibility. |

### `toggleSatellite` rules

- Handler keeps the previous URL + layer name cached and recreates the `RasterTileSource` only when the incoming message differs. This is intentional — when Firebase Remote Config rotates the token, the URL changes and the old source must be dropped. Do not "optimize" by reusing the cached source after a URL change.
- `SatelliteMapMessage.rasterTileUri` arrives with `{TOKEN}` already substituted (Dart-side replace inside `SatelliteConfig.resolvedTileUri`). Native receives a ready-to-use URL containing `{z}/{y}/{x}` placeholders that 2GIS handles natively.
- Empty `rasterTileUri` or `layerName` is treated as a no-op by Dart (the controller logs a warning and skips the bridge call). Native code does not need a defensive branch for empty strings.
- `enabled = false` only removes the source from `map.sources`; the cached `RasterTileSource` instance is kept so the next enable with the same URL is cheap.

## Verification

```bash
rtk fvm dart format -l 120 urbi_map/dgis_map_platform_interface/pigeons/messages.dart urbi_map/dgis_map_platform_interface/lib/src/dgis_map_plugin.dart urbi_map/dgis_map/lib/dgis_map_controller.dart
rtk fvm flutter analyze --no-pub lib/dgis_map_controller.dart
rtk fvm flutter analyze --no-pub pigeons/messages.dart lib/src/dgis_map_plugin.dart
```
