# Free Roam Notes

This subtree owns free-roam ("Drive") activation and the app-side navigation-camera configuration.

## Session Context

BE-193 added live, tunable control over the 2GIS navigation camera. `navigation_camera_settings_controller.dart` holds a `CameraTuneState` (tilt-by-zoom curve, zoom-by-speed rules, follow toggles, zoom restriction, follow-return delay, maneuver tuning), seeded from `NavigationConstants.defaultNavigationCameraSettings`, and pushes it to native via `DgisMapController.setNavigationCameraSettings(...)`. Every navigation/free-roam **start** site now re-applies these settings so debug tuning survives a restart within the session.

The debug panel (`camera_controls_debug_panel.dart`) shows a live **ZOOM/TILT/BEARING readout**, a **side-view projection** (`_CameraSideProjection` — a CustomPainter schematic of camera-vs-car: tilt arc, zoom-derived distance, a "road ahead" marker; reads `cameraPositionProvider`), the tilt/zoom/follow sliders, and a **numeric speed-input field** (`SpeedInputField` in `slider_speed.dart`, two-way synced with `simulationSpeedProvider`). The tuned settings are also mirrored to **Android Auto / CarPlay** (see `urbi_map/dgis_map/AGENTS.md` → *Propagating to CarPlay / Android Auto*).

> **SDK ceiling / map blank:** this branch is on **SDK 12** — the HUD, side-view and **tilt-by-zoom** work, but **tilt-by-speed (per-band `styleTilt`) is SDK-13-only** (`feat/BE-200/…`), so the speed-band sliders won't move the camera here. Separately, the map renders blank unless the `keys.api.urbi.ae` license server is reachable (corp VPN) — see the plugin AGENTS.md → *License activation & the "blank map" trap*.

## Rules For This Subtree

- The single source of defaults is `NavigationConstants.defaultNavigationCameraSettings` (in `mapness/lib/shared/constants/navigation_constants.dart`). `CameraTuneState.initial()` is derived from it — change defaults there, not in the controller.
- After **any** native navigation/free-roam start or restore, call `setNavigationCameraSettings(ref.read(navigationCameraSettingsControllerProvider).toMessage())`. Current call sites: `free_roam_manager.dart` (initFreeRoam + restoreNavigationState), `pages/path_nav/path_nav_page.dart` (×2 start + restore), `widgets/debug_overlay/debug_navigation_controll.dart` (simulation). Keep them in sync if you add a new start path.
- The pigeon message fields are nullable = "leave SDK value unchanged"; `toMessage()` only sends `minZoom`/`maxZoom` when `zoomRestrictionEnabled` is true.
- Boolean setters on the controller are intentionally **positional** (so they pass as `ValueChanged<bool>` to debug toggles) — keep the `ignore_for_file: avoid_positional_boolean_parameters`.
- Live tuning UI is `widgets/debug_overlay/camera_controls_debug_panel.dart`; use it during a simulation to benchmark against the 2GIS app, then fold chosen values back into the defaults.
- Speeds in `SpeedZoomRule` are **m/s** (the SDK's `SpeedRange` unit), distances **mm**.

## Important Files

- `navigation_camera_settings_controller.dart`: `CameraTuneState` + `@Riverpod` `NavigationCameraSettingsController` (`toMessage()`, live re-apply).
- `free_roam_manager.dart`: free-roam start/restore/end-trip; applies camera settings after start.
- `../../shared/constants/navigation_constants.dart`: `defaultNavigationCameraSettings` + legacy `navigationSpeedRangeZooms`.
- `../../widgets/debug_overlay/camera_controls_debug_panel.dart`: live tuning panel + `_CameraSideProjection` (side-view schematic).
- `../../widgets/debug_overlay/slider_speed.dart`: `SpeedInputField` (numeric speed entry) + sim-speed slider.
- `simulation_speed_controller.dart` / `camera_controls_overlay_provider.dart`: shared sim-speed + on-map overlay toggle.

## Verification

```bash
rtk fvm dart run build_runner build --delete-conflicting-outputs   # regenerates navigation_camera_settings_controller.g.dart
rtk fvm dart format -l 120 mapness/lib/features/free_roam/navigation_camera_settings_controller.dart mapness/lib/features/free_roam/free_roam_manager.dart
rtk fvm dart analyze mapness/lib/features/free_roam/navigation_camera_settings_controller.dart mapness/lib/features/free_roam/free_roam_manager.dart
```
