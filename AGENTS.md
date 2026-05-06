# AGENTS.md

## Project Overview

Balady Plus is a Flutter superapp repository with three main code areas:

- `lib/`: the main application shell and feature modules.
- `mapness/`: a large local Flutter package with its own features, tests, codegen, and linting flow.
- `urbi_map/`: local map plugin packages (`dgis_map` and `dgis_map_platform_interface`) with native Android and iOS code.

Use this file as the primary shared instruction set for coding agents. In large subtrees, the nearest nested `AGENTS.md` adds more specific rules.

## Trust Order

- If documentation conflicts with executable config, trust the executable config first.
- Prefer `justfile`, `lefthook.yml`, `.lefthook/*`, `analysis_options.yaml`, and `pubspec.yaml` over aspirational docs.
- Treat existing local patterns as the source of truth. Do not normalize the whole repository to one style unless the task explicitly requires it.

## Environment And Setup

- Flutter version is pinned by FVM in `.fvmrc`: `3.38.5`.
- Prefer `fvm ...` commands over global Flutter/Dart binaries.
- Prefer `just` recipes over ad hoc multi-step shell commands because this repo spans multiple packages.

Common commands:

- Install dependencies for the app and local packages: `just pubget`
- Full local prep: `just prebuild`
- Run the dev flavor: `just run`
- iOS pod recovery/setup: `just ios_setup`
- Mapness code generation: `just codegen`
- Pigeon regeneration for map plugins: `just build_pigeon`

## Validation

Run targeted checks for the area you changed.

- Root app analyze: `fvm flutter analyze`
- Root app tests: `fvm flutter test`
- Format Dart files: `fvm dart format -l 120 <files>`
- `mapness` analyze: `cd mapness && fvm flutter analyze`
- `mapness` tests: `cd mapness && fvm flutter test`
- `dgis_map` analyze: `cd urbi_map/dgis_map && fvm flutter analyze`
- `dgis_map_platform_interface` analyze: `cd urbi_map/dgis_map_platform_interface && fvm flutter analyze`

If you touch `mapness/**/*.dart`, expect the local hook to run:

- `fvm flutter analyze <staged files>`
- `fvm flutter pub run custom_lint <staged files>`

## Repository Structure

- `lib/app/core`: shared services, DI, error handling, utilities, remote services.
- `lib/app/features`: main app feature modules.
- `mapness/lib`: map-related package code with Riverpod, codegen, and feature slices.
- `urbi_map/dgis_map`: Flutter plugin plus native Android and iOS implementations.
- `urbi_map/dgis_map_platform_interface`: shared plugin contract and Pigeon schema.
- `test/` and `mapness/test/`: targeted test suites.
- `docs/`: team workflow, KPIs, and governance docs. Useful context, but not always perfectly aligned with hooks.

## Architecture Rules

This repository is intentionally mixed. Match the module you are editing.

- In `lib/`, preserve the existing feature-first app structure, `flutter_bloc`, `formz`, and `get_it` patterns.
- In `mapness/`, preserve existing Riverpod, hooks, AutoRoute, Freezed, and mapper/provider patterns. Do not force Bloc-only rewrites there.
- In `urbi_map/`, keep the Flutter API, platform interface, Kotlin, and Swift/Objective-C implementations synchronized.
- Avoid cross-package API breaks unless the task explicitly calls for a coordinated change.

## Generated Files

Do not hand-edit generated artifacts unless the task is specifically about generated output debugging.

Examples in this repo:

- `**/*.g.dart`
- `**/*.freezed.dart`
- `**/*.gen.dart`
- `mapness/lib/l10n/generated/**`
- `mapness/lib/app/auto_route/app_routes.gr.dart`
- `urbi_map/dgis_map_platform_interface/lib/src/pigeons/messages.g.dart`
- `urbi_map/dgis_map/android/src/main/kotlin/com/dgis/map/map_api/Messages.kt`
- `urbi_map/dgis_map/ios/Classes/Messages.swift`

Edit the source annotations or schema, then regenerate with the relevant command.

## Git And PR Workflow

Follow the actual hook rules in `.lefthook`, because they are stricter and more accurate than older prose docs.

Branch names accepted by the push hook use one of these shapes:

- `<type>/short-name`
- `<type>/<BSA-or-BALADY-ticket>/short-name`
- `urbi-release-x.y.z`

Allowed branch types:

- `feat`
- `bugfix`
- `hotfix`
- `test`

Commit messages touching `mapness/` must follow:

- `<type>(scope?): message`

Allowed commit types:

- `build`
- `chore`
- `ci`
- `docs`
- `feat`
- `fix`
- `perf`
- `refactor`
- `revert`
- `style`
- `test`

For UI-facing changes, expect screenshots to be required by the PR process.

## Security And Secrets

- Do not add, rotate, or expose credential-like files without explicit instruction.
- Treat `.env.*`, signing assets, hosted-registry credentials, `android/app/src/main/assets/dgissdk.key`, and `android/app/src/**/google-services.json` as sensitive inputs even if some of them are already tracked in the repository.
- Do not copy secret values from scripts, CI, or local machine state into new docs, comments, logs, or examples.
- Be careful around `ios/`, Android signing config, Firebase config, and any vendor SDK bootstrap code.

## Change Discipline

- Keep changes scoped and reversible.
- Prefer targeted fixes over drive-by refactors in unrelated features.
- Update or add nearby tests when behavior changes.
- Check whether strings belong in the existing localization flow before hardcoding them.
- Respect the repo line length of `120`.

## When You Are Unsure

- Read the nearest `AGENTS.md` first.
- If docs disagree with code or hooks, follow the code and hooks.
- Prefer small, verifiable changes with targeted validation.
