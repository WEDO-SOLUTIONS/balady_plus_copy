# Path Navigation Page Notes

This subtree owns the active navigation UI route.

## Session Context

The current session fixed and investigated several active-navigation issues:

- `LateInitializationError` for `_naviEventsListener` when `_initNavigation` was called before the subscription was initialized.
- Incorrect start/restore branching where `PathNavPageInitAction.startNavigation` could be bypassed by restore-style logic.
- Disposed/mounted async gaps during native navigation state save/restore/start.
- Stale saved native navigation state causing `PathNavRoute` to stay open while no native navigation was actually active.

## Rules For This Subtree

- Keep `_naviEventsListener` nullable and cancel with `?.cancel()`. Do not use `late` for subscriptions initialized asynchronously.
- In `_initNavigation`, handle `PathNavPageInitAction.startNavigation` before restore logic. Starting a new route must call native `startNavigation`.
- After every await that precedes `context`, `ref`, route, or notifier usage, check `mounted`.
- `restoreNavigationState` should communicate whether restore actually succeeded. If there is no saved state and no active native navigation, clear stale prefs and pop if possible.
- When saved state is absent, consult native `getCurrentNavigationState()` before assuming navigation is dead. Native navigation can outlive Flutter route state.
- Be cautious with `ref.listen(dgisControllerProvider, ...)` re-calling `_initNavigation`; it can happen after map/controller recreation.
- After every native `startNavigation` / `restoreNavigationState` call here, apply the camera config: `setNavigationCameraSettings(ref.read(navigationCameraSettingsControllerProvider).toMessage())` (BE-193). See `mapness/lib/features/free_roam/AGENTS.md`.

## Important Files

- `path_nav_page.dart`: active navigation UI, native start/restore/save, ETA listeners, end-trip flow.
- `path_nav_wrapper.dart`: sheet/control wrapper around navigation UI.

## Verification

```bash
rtk fvm dart format -l 120 mapness/lib/pages/path_nav/path_nav_page.dart
rtk fvm flutter analyze --no-pub mapness/lib/pages/path_nav/path_nav_page.dart
```
