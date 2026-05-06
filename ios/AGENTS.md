# AGENTS.md for `ios`

Read the repository root `AGENTS.md` first. These instructions apply to the app-level iOS project under `ios/`.

## Scope

This is the iOS host app layer for the main Flutter application, separate from the plugin-native iOS code under `urbi_map/dgis_map/ios/`.

## Editing Rules

- Preserve flavor/build configuration, signing flow, and workspace structure.
- Be careful with provisioning, certificates, export options, and any Fastlane or build-script assumptions.
- Do not introduce or expose signing material, provisioning data, or service credentials in tracked files or logs.
- Avoid broad Xcode project churn for small behavior changes.

## Coordination

- If a change affects both the host app and the local map plugin, update `ios/` and `urbi_map/` deliberately rather than assuming one side is enough.
