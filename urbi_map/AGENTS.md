# urbi_map Notes

This subtree owns the Flutter/native map bridge packages.

## Session Context

- Indoor floor-plan visibility is exposed to Flutter via `setIndoorFloorPlansEnabled`.
- The Pigeon source is `dgis_map_platform_interface/pigeons/messages.dart`; generated outputs are produced by running `fvm dart pub run pigeon --input pigeons/messages.dart` from `urbi_map/dgis_map_platform_interface/`. The just-recipe `just build_pigeon` wraps the same command plus `pub get` for both packages.
- The public Dart wrappers are `dgis_map_platform_interface/lib/src/dgis_map_plugin.dart` and `dgis_map/lib/dgis_map_controller.dart`.
- Android maps the bridge method to `map.indoorManager.setIndoorState(IndoorManagerState.ENABLED/DISABLED)`.
- iOS maps the bridge method to `map.indoorManager.setIndoorState(newState: .enabled/.disabled)`.
- Native `DgisMapView` implementations should handle calls before `IndoorControlHandler` is initialized by falling back to `map.indoorManager` directly.

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
