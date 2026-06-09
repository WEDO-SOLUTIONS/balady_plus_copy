# 2GIS Map Plugin Notes (`dgis_map`)

This subtree wraps the **2GIS Mobile SDK** (`ru.dgis.sdk` on Android, `DGis` xcframework on iOS) behind a [pigeon](https://pub.dev/packages/pigeon)-generated platform channel. Dart calls flow: app → `dgis_map` (`DgisMapController`) → `dgis_map_platform_interface` (`DgisMapPlugin` → generated `MapApi`) → native `DgisMapView` (`MapApi` impl) → control handlers (e.g. `NavigationHandler`).

## Session Context

BE-193 added **all available navigation-camera controls** for the phone (Android + iOS): camera tilt (zoom→tilt curve), zoom-by-speed with real maneuver-distance windows, bearing/zoom/tilt follow toggles, global zoom restrictions, follow-return delay, and maneuver-zoom animation tuning. They are exposed additively through a single new host method `setNavigationCameraSettings(NavigationCameraSettings)` whose fields are all nullable (null = "leave the SDK value unchanged"). The phone-tuned settings are **mirrored to CarPlay and Android Auto** — see *Propagating to CarPlay / Android Auto*.

> **Branch / SDK:** `feat/BE-193/navigation_camera_controls` is on **SDK 12**; the SDK-13 upgrade lives on `feat/BE-200/sdk-version-update`. The HUD + AA/CP propagation exist on both, but **tilt-by-speed (per-band `styleTilt`) works only on SDK 13** — see *SDK 12 vs 13*.

## How the SDK models the navigation camera

The navigation camera is **declarative**, not driven by per-frame `camera.move()`:

- `NavigationManager.mapFollowController.cameraBehaviour` = `CameraBehaviour(FollowPosition(FollowBearing, FollowStyleZoom), FollowTilt)` — these are ON/OFF toggles for *whether* each axis auto-follows, not the values.
- **Zoom values** come from `NavigationManager.zoomFollowSettings.speedRangeToStyleZoom[FreeRoam]Sequence` — a list of `SpeedRangeToStyleZoom(SpeedRange(minSpeed,maxSpeed /* m/s */), minDistanceToManeuver, maxDistanceToManeuver /* RouteDistance, mm */, StyleZoom)`. Make zoom both speed- and maneuver-distance-aware here.
- **Tilt** has no entry in `zoomFollowSettings`; drive it with a `TiltFollowController(StyleZoomToTiltRelation)` added via `camera.addFollowController(...)`, and/or clamp with `camera.maxTiltRestriction`.
- **Zoom limits:** `camera.setZoomRestrictions(CameraZoomRestrictions(minZoom, maxZoom))` (iOS: `throws`).
- **Bearing / coordinates** are locked to movement during follow and are not separately settable.

## Propagating to CarPlay / Android Auto

The phone tunes the camera; the same settings are mirrored to the in-car maps:

- **Speed→zoom propagates automatically** — `NavigationManager` (and its `zoomFollowSettings`) is a **singleton shared** by phone, Android Auto and CarPlay, so `speedZoomRules` / `zoomTuning` reach all of them with no extra wiring.
- **Tilt curve + zoom restriction + follow behaviour are per-map** (they live on `map.camera`, not the manager) → applied to each map separately. The last phone-applied settings are stored so an in-car map can adopt them when its scene connects: iOS `NavigationHandler.lastNavigationCameraSettings` (static), Android `DgisMapInitializer.lastNavigationCameraSettings`.
  - **CarPlay (iOS):** `applyCameraSettings` and `setupCamera` call `applyPerMapSettings(settings, to: carPlayMap, tiltController: &carPlayTiltFollowController)`.
  - **Android Auto:** `CarNavigationHandler.addMap` builds its `TiltFollowController` from the stored `tiltRelation` curve (`interpolateTilt`) when present (else the fixed near/far chase tilt); `updateCarPlayStyleCameraTilt` defers to the curve when present.

## SDK 12 vs 13

- **BE-193 = SDK 12, BE-200 = SDK 13.** `SpeedRangeToStyleZoom` is **4-arg on SDK 12** (range, min/maxDistance, styleZoom) and **7-arg on SDK 13** (adds `roadClassesStyleZooms`, `roadClassesTilts`, **`styleTilt`**).
- **tilt-by-speed** (per-band `styleTilt`) is **SDK-13-only** — on SDK 12 those bands don't drive tilt. **tilt-by-zoom** (`TiltFollowController` + zoom→tilt curve) and **zoom restrictions** work on **both**. So on BE-193 the HUD/AA/CP render and tilt-by-zoom works, but per-speed-band tilt is inert until the branch gets SDK 13.

## License activation & the "blank map" trap

On-premise build. The SDK activates its license at startup via `keys.api.urbi.ae` (`…/keys/<key>/services/mobile-sdk`; key/URL from `*-vendor-config.jsonx`). **If that host is unreachable the SDK renders no tiles → blank beige map** (the rest of the app works). It is **not DNS, not the app code, not the build**:

- `keys.api.urbi.ae` (and `jam/tjam/tugc/bss.*.urbi.ae`, IPs `91.236.51.x`) are **IP-allowlisted** — they accept TCP but return no HTTP to non-allowed source IPs. Needs an **allowlisted egress (corp VPN / SA network)**. The tileserver (`urbi-lifestyle*.momah.gov.sa`) is reachable directly, so the **license** is the blocker, not tiles.
- The activated key is **cached**: iOS `…/Library/DownloadedData/dgissdk.key`, Android `…/files/ru.dgis.sdk/` + `cache/ru.dgis.sdk/http_cache` (leveldb). A warm cache renders offline; a **fresh install** must reach `keys.api`.
- **Don't `xcrun simctl uninstall`** to refresh an iOS build — it wipes the data container (and the cached key). Use `install` (replace) to keep the cache.

## Rules For This Subtree

- Edit the contract in `../dgis_map_platform_interface/pigeons/messages.dart`, then regenerate (see root `AGENTS.md` → *Code generation → Pigeon*). The `--package_name dgis_map_platform_interface` flag is **required**. Generated `Messages.kt` / `Messages.swift` / `messages.g.dart` are **git-ignored** — never hand-edit.
- Any new `@HostApi()` method must be implemented in **both** `MapApi` conformers: `android/.../DgisMapView.kt` and `ios/Classes/DgisMapView.swift` (they are the only conformers — a missing impl fails compilation).
- Keep Android and iOS behavior in parity. **Unit gotcha:** Android durations are `ru.dgis.sdk.Duration` (`Duration.ofMilliseconds(Long)` / `ofSeconds(Long)`); iOS durations are `TimeInterval` in **seconds** — convert ms→s on iOS (`TimeInterval(ms)/1000.0`).
- When adding a `FollowController` (e.g. `TiltFollowController`), **track and remove it** on `resetCamera()` so navigation-only camera behavior does not leak into normal map mode.
- `CameraBehaviour.position` is optional on iOS — always pass a non-nil `FollowPosition` for navigation.
- Phone-tuned `NavigationCameraSettings` are **mirrored to the in-car maps** (Android Auto `android/.../android_auto/CarNavigationHandler.kt`; CarPlay map via `applyPerMapSettings` in `NavigationHandler.swift`). Keep that propagation in sync when you touch `applyCameraSettings`. Speed→zoom is automatic (shared `NavigationManager`); tilt-curve / zoom-restriction / follow-behaviour are per-map.
- **Codegen after `flutter clean` / branch switch:** the generated `messages.g.dart` + riverpod `*.g.dart` are git-ignored; regenerate with pigeon + `build_runner` (or `just prebuild`), else the app fails to compile with undefined `NavigationCameraSettings` / `*Provider`.
- Verify SDK symbol names/signatures against the actual binaries before relying on them: Android `unzip` the `.aar` from `~/.gradle/caches/.../ru.dgis.sdk/sdk-full/<ver>/` and `javap -p`; iOS read `DGis.xcframework/.../DGis.swiftmodule/*.swiftinterface`.

## Important Files

- `../dgis_map_platform_interface/pigeons/messages.dart`: the pigeon source of truth (message types + `MapApi`).
- `lib/dgis_map_controller.dart`: public Dart API (`DgisMapController`).
- `../dgis_map_platform_interface/lib/src/dgis_map_plugin.dart`: thin Dart forwarders to generated `MapApi`.
- `android/src/main/kotlin/com/dgis/map/DgisMapView.kt` & `ios/Classes/DgisMapView.swift`: the `MapApi` implementations.
- `android/.../control_handlers/NavigationHandler.kt` & `ios/Classes/control_handlers/NavigationHandler.swift`: navigation start/stop, `setupCamera`, and `applyCameraSettings` (maps `NavigationCameraSettings` onto the SDK).

## Verification

```bash
rtk fvm dart format -l 120 urbi_map/dgis_map/lib/dgis_map_controller.dart urbi_map/dgis_map_platform_interface/lib/src/dgis_map_plugin.dart urbi_map/dgis_map_platform_interface/pigeons/messages.dart
rtk fvm dart analyze urbi_map/dgis_map/lib/dgis_map_controller.dart urbi_map/dgis_map_platform_interface/lib/src/dgis_map_plugin.dart
```

Native (Kotlin/Swift) is validated by a device build of `mapness/`; there is no standalone analyzer for it.
