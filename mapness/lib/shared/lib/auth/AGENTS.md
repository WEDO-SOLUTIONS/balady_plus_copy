# Auth Helpers Notes

This subtree contains auth helper providers used by many UI entry points.

## Session Context

The current session fixed a route/auth race affecting `Drive back home` and other auth-gated flows. Previously `authAndOpen` used a stream listener and invoked callback logic without awaiting the callback. That allowed auth invalidations, favourites writes, sheet hiding, and route pushes to interleave.

## Rules For This Subtree

- Auth-gated callbacks should support async callbacks: `FutureOr<void> Function()?`.
- Await callbacks when the caller awaits `authAndOpen`/`authOrOpen`.
- Avoid fire-and-forget route pushes after login. If a caller is waiting for auth before continuing, the helper must not return before the callback chain has completed or the login flow has been cancelled.
- Keep the login-screen-cancel path completing the wait. Otherwise callers can hang if the login screen is popped without successful auth.
- Keep duplicate callback execution guarded; auth streams can replay or emit multiple states.

## Important Files

- `auth_methods.dart`: `AuthMethods.authAndOpen` and `authOrOpen`.

## Verification

```bash
rtk fvm dart format -l 120 mapness/lib/shared/lib/auth/auth_methods.dart
rtk fvm flutter analyze --no-pub mapness/lib/shared/lib/auth/auth_methods.dart
```
