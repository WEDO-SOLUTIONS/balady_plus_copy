# Satellite Layer Notes

This subtree owns the satellite raster-tile overlay. Implements [BE-243](https://wedosolutions-sa.atlassian.net/browse/BE-243) (parent: [BE-175](https://wedosolutions-sa.atlassian.net/browse/BE-175)).

## Architecture

Satellite is a **base-map toggle**, not an overlay. It coexists with overlay layers (traffic / parking / metro / favourites). The layers sheet exposes two mutually-exclusive base-map tiles, `Default` and `Satellite`, backed by a single `bool` provider — `Default` is "satellite off".

Flow on tap:

1. `LayerSliverList.onTap` → `LayersControls.handleTap(value)` (debounced 250 ms).
2. `LayersControls._tapHandler` short-circuits when `value == satellite || value == defaultMap` — does NOT route through the overlay `_hidePreviousLayers`/`toggleLayers` logic. This keeps satellite independent of overlay state.
3. `LayersControls.toggleLayers` calls `SatelliteMapController.enable()` / `.disable()`.
4. Controller reads `satellite_config` from Firebase Remote Config via `AppConfigLoader.getSatelliteConfig()`, substitutes `{TOKEN}` into the URL template, and hands the result to `dgisController.toggleSatellite` (native bridge).
5. Native `SatelliteHandler` (Kotlin + Swift) creates a 2GIS `RasterTileSource` and adds it to `map.sources`. Cached URL/layerName lets it recreate the source on rotation instead of reusing a stale one.

## Rules For This Subtree

- **`SatelliteMapController` is `@Riverpod(keepAlive: true)`**. Do not remove the flag — without it the provider auto-disposes when the layers sheet closes and the UI desyncs from the native layer on reopen (UI shows `Default` selected while satellite tiles are still on the map). If you change the annotation, re-run `build_runner` to refresh `satellite_map_controller.g.dart` (gitignored).
- **`{TOKEN}` substitution lives in Dart**, not on the bridge. The bridge receives the final URL. `SatelliteConfig.resolvedTileUri` does the replace; if the template has no `{TOKEN}` placeholder the substitution is a no-op (works for token-less providers like ESRI World Imagery).
- **Token is optional**. `SatelliteConfig.isUsable` only requires `token` when the URL template embeds `{TOKEN}`. Do not tighten this — it would break public tile servers used as dev stand-ins.
- **Do not couple satellite state with `LayersControls.selectedType`**. Selected-type tracks the overlay layer (traffic / parking / metro / etc.). Satellite has its own bool because users can mix `Satellite` base with any overlay.
- **Native handler recreates the raster source when URL or layer name changes**. This is intentional: when FRC rotates the token, the cached `RasterTileSource` would otherwise keep pointing at the old URL. If you add caching/optimization, preserve the recreate-on-change behavior.
- **Do not log the token**. The `isExpired` warning includes `expiresAt` only — never the token string.

## Firebase Remote Config

Key: `satellite_config` (see `RemoteConfigConstants.satelliteConfig`).

JSON shape:

```json
{
  "layer_name": "satellite",
  "url_template": "https://.../tile/{z}/{y}/{x}?token={TOKEN}",
  "token": "...",
  "expires": 1784245894893
}
```

- `url_template` — placeholders: `{z}`, `{y}`, `{x}` (interpreted by 2GIS native), `{TOKEN}` (substituted in Dart).
- `token` — empty for token-less tile servers.
- `expires` — milliseconds since epoch. Informational only — controller logs a warning when past expiry, does **not** block enable.

Bundled default lives in `mapness/lib/shared/utils/app_config_loader.dart` as `_kSatelliteConfigDefault` and is registered via `setDefaults` so the layer works before Firebase Console is wired up. Currently points at ESRI World Imagery (public, no token) as a dev stand-in. The production Saudi Geoportal endpoint is preserved in the docstring above the constant — swap before release.

ESRI Saudi Geoportal caps token expiry at ~30 days regardless of the requested duration. Rotation = single JSON edit in Firebase Console, no app release.

## Important Files

- `models/satellite_config.dart`: JSON parser, `{TOKEN}` substitution, `isUsable`, `isExpired`, `requiresToken`.
- `providers/satellite_map_controller.dart`: `@Riverpod(keepAlive: true)` notifier exposing `enable()` / `disable()` / `toggle()`. Reads FRC, substitutes token, calls native bridge.
- `../../shared/utils/app_config_loader.dart`: `_kSatelliteConfigDefault`, `getSatelliteConfig()`, FRC `setDefaults` registration.
- `../../shared/constants/remote_config_constants.dart`: `satelliteConfig` key.
- `../lifestyle_layers/providers/layers_state.dart`: `LayerType.defaultMap` and `LayerType.satellite` enum entries + position in the `v1` grid.
- `../lifestyle_layers/providers/layers_controls.dart`: short-circuit in `_tapHandler` and dedicated branches in `toggleLayers` / `_hidePreviousLayers`.
- `../lifestyle_layers/helpers/layers_type_extension.dart`: PNG-path thumbnails for both tiles (raster, not SVG).
- `../../widgets/layers/layer_switcher_card.dart`: extension-based dispatch to `Image.asset` for raster thumbnails vs `SvgPicture.asset` for SVG.
- `../../../../urbi_map/dgis_map/android/.../control_handlers/SatelliteHandler.kt` + `.../ios/Classes/control_handlers/SatelliteHandler.swift`: native raster-source lifecycle.
- `../../../../urbi_map/dgis_map_platform_interface/pigeons/messages.dart`: `SatelliteMapMessage` + `toggleSatellite` pigeon definitions.

## Verification

```bash
rtk fvm dart format -l 120 \
  mapness/lib/features/satellite/models/satellite_config.dart \
  mapness/lib/features/satellite/providers/satellite_map_controller.dart \
  mapness/lib/shared/utils/app_config_loader.dart
rtk fvm flutter analyze --no-pub mapness/lib/features/satellite/
```

After editing the pigeon source or the controller's `@Riverpod` annotation:

```bash
just build_pigeon            # regenerates Messages.kt / Messages.swift / messages.g.dart
cd mapness && fvm dart run build_runner build --delete-conflicting-outputs
```
