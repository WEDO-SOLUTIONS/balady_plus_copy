# AGENTS.md for `android`

Read the repository root `AGENTS.md` first. These instructions apply to the app-level Android project under `android/`.

## Scope

This is the Android host app layer for the main Flutter application, separate from the native plugin code under `urbi_map/`.

## Editing Rules

- Preserve flavor-aware configuration and manifest structure.
- Be careful with app assets and configuration files under `android/app/src/**`.
- Treat `android/app/src/main/assets/dgissdk.key` and any `google-services.json` files as sensitive operational inputs. Do not modify or expose them unless explicitly instructed.
- Keep changes minimal when working in manifests, Gradle files, or source-set-specific configuration.

## Coordination

- If a change affects both the host app and the local map plugin, update `android/` and `urbi_map/` deliberately rather than assuming one side is enough.
