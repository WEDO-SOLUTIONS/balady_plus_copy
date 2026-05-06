# AGENTS.md for `urbi_map`

Read the repository root `AGENTS.md` first. These instructions add plugin-specific rules.

## Scope

This subtree contains the local map plugin packages:

- `urbi_map/dgis_map`
- `urbi_map/dgis_map_platform_interface`

Changes here often span Dart, Kotlin, and Swift/Objective-C code at the same time.

## Commands

- Analyze plugin package: `cd urbi_map/dgis_map && fvm flutter analyze`
- Analyze platform interface: `cd urbi_map/dgis_map_platform_interface && fvm flutter analyze`
- Rebuild Pigeon bindings from the repo root: `just build_pigeon`

## Contract Discipline

- Keep the platform interface contract, Flutter plugin API, and native implementations synchronized.
- Prefer small, explicit API changes. Plugin breakage tends to cascade into both the root app and `mapness`.
- Preserve existing package names, channel wiring, and initializer flow unless a task explicitly requires changing them.

## Pigeon And Generated Files

Treat `urbi_map/dgis_map_platform_interface/pigeons/messages.dart` as the source schema.

Do not hand-edit generated outputs:

- `urbi_map/dgis_map_platform_interface/lib/src/pigeons/messages.g.dart`
- `urbi_map/dgis_map/android/src/main/kotlin/com/dgis/map/map_api/Messages.kt`
- `urbi_map/dgis_map/ios/Classes/Messages.swift`

Edit the schema, then regenerate with `just build_pigeon`.

## Native Code Rules

- Keep Android and iOS behavior aligned when changing shared plugin features.
- Do not introduce secrets, SDK keys, or signing material into source control.
- Avoid changing vendor bootstrap logic or platform initialization unless the task specifically targets it.
- Be careful with Android Auto code paths and map-control handlers because they fan out into many feature surfaces.
