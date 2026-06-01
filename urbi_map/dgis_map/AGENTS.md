# 2GIS Map Plugin Notes (`dgis_map`)

This subtree wraps the **2GIS Mobile SDK** (`ru.dgis.sdk` on Android, `DGis` xcframework on iOS) behind a [pigeon](https://pub.dev/packages/pigeon)-generated platform channel. Dart calls flow: app → `dgis_map` (`DgisMapController`) → `dgis_map_platform_interface` (`DgisMapPlugin` → generated `MapApi`) → native `DgisMapView` (`MapApi` impl) → control handlers (e.g. `NavigationHandler`).

## Session Context

BE-193 added **all available navigation-camera controls** for the phone (Android + iOS): camera tilt (zoom→tilt curve), zoom-by-speed with real maneuver-distance windows, bearing/zoom/tilt follow toggles, global zoom restrictions, follow-return delay, and maneuver-zoom animation tuning. They are exposed additively through a single new host method `setNavigationCameraSettings(NavigationCameraSettings)` whose fields are all nullable (null = "leave the SDK value unchanged"). CarPlay / Android Auto were intentionally left untouched.

## How the SDK models the navigation camera

The navigation camera is **declarative**, not driven by per-frame `camera.move()`:

- `NavigationManager.mapFollowController.cameraBehaviour` = `CameraBehaviour(FollowPosition(FollowBearing, FollowStyleZoom), FollowTilt)` — these are ON/OFF toggles for *whether* each axis auto-follows, not the values.
- **Zoom values** come from `NavigationManager.zoomFollowSettings.speedRangeToStyleZoom[FreeRoam]Sequence` — a list of `SpeedRangeToStyleZoom(SpeedRange(minSpeed,maxSpeed /* m/s */), minDistanceToManeuver, maxDistanceToManeuver /* RouteDistance, mm */, StyleZoom)`. Make zoom both speed- and maneuver-distance-aware here.
- **Tilt** has no entry in `zoomFollowSettings`; drive it with a `TiltFollowController(StyleZoomToTiltRelation)` added via `camera.addFollowController(...)`, and/or clamp with `camera.maxTiltRestriction`.
- **Zoom limits:** `camera.setZoomRestrictions(CameraZoomRestrictions(minZoom, maxZoom))` (iOS: `throws`).
- **Bearing / coordinates** are locked to movement during follow and are not separately settable.

## Rules For This Subtree

- Edit the contract in `../dgis_map_platform_interface/pigeons/messages.dart`, then regenerate (see root `AGENTS.md` → *Code generation → Pigeon*). The `--package_name dgis_map_platform_interface` flag is **required**. Generated `Messages.kt` / `Messages.swift` / `messages.g.dart` are **git-ignored** — never hand-edit.
- Any new `@HostApi()` method must be implemented in **both** `MapApi` conformers: `android/.../DgisMapView.kt` and `ios/Classes/DgisMapView.swift` (they are the only conformers — a missing impl fails compilation).
- Keep Android and iOS behavior in parity. **Unit gotcha:** Android durations are `ru.dgis.sdk.Duration` (`Duration.ofMilliseconds(Long)` / `ofSeconds(Long)`); iOS durations are `TimeInterval` in **seconds** — convert ms→s on iOS (`TimeInterval(ms)/1000.0`).
- When adding a `FollowController` (e.g. `TiltFollowController`), **track and remove it** on `resetCamera()` so navigation-only camera behavior does not leak into normal map mode.
- `CameraBehaviour.position` is optional on iOS — always pass a non-nil `FollowPosition` for navigation.
- This file is **phone-only**. Android Auto / CarPlay have their own camera logic in `android/.../android_auto/CarNavigationHandler.kt` and `ios/Classes/CarPlay/` — do not change them when wiring phone controls.
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
