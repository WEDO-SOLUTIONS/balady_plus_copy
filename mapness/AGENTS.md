# AGENTS.md for `mapness`

Read the repository root `AGENTS.md` first. These instructions add `mapness`-specific rules.

## Scope

This package is a local Flutter package consumed by the root app. It has its own dependencies, tests, codegen, and lint rules.

## Commands

- Install dependencies: `cd mapness && fvm flutter pub get`
- Analyze package: `cd mapness && fvm flutter analyze`
- Run tests: `cd mapness && fvm flutter test`
- Build generated code from the repo root: `just codegen`
- Alternative cached codegen: `just codegen_cached`

If a change touches only one generated area, prefer targeted validation before broader runs.

## Local Architecture

- Follow the package's existing mix of Riverpod, hooks, AutoRoute, Freezed, JSON serialization, and provider patterns.
- Some legacy Bloc usage exists. Do not rewrite feature state management just to make it uniform.
- Preserve mapper/entity/provider boundaries where they already exist.
- Prefer extending an existing feature slice over creating a new parallel pattern.

## Generated And Derived Files

Do not hand-edit:

- `mapness/lib/_generated/**`
- `mapness/lib/l10n/generated/**`
- `mapness/lib/app/auto_route/app_routes.gr.dart`
- `mapness/**/*.g.dart`
- `mapness/**/*.freezed.dart`

Regenerate after changing:

- `@freezed` types
- `@JsonSerializable` models
- `@riverpod` declarations
- AutoRoute definitions
- Localization sources

## Testing And Hooks

- Pre-commit hooks analyze staged Dart files under `mapness/`.
- When changing behavior, add or update targeted tests in `mapness/test/` when practical.
- Keep formatting at `120` columns and use `fvm dart format -l 120 <files>`.

## Guardrails

- Avoid introducing new state-management frameworks here.
- Avoid broad package-wide refactors unless the task explicitly requires one.
- Keep public APIs stable for the root app unless you are intentionally coordinating both sides of the change.

## Feature-specific Instructions

Some features under `mapness/lib/features/` have their own `AGENTS.md` with
domain rules, file maps, and assumptions. Read the nearest one before changing
that feature.

- `mapness/lib/features/saudi_pass/AGENTS.md` — Tadalal Offers feature.
  Covers the By Preference / All Offers tabs, the offers map view, and the
  city resolution chain (BRD "Offers Lists Enhancements", Jira BALADY-188).
  The single source of truth for offers `city` parameter resolution is
  `services/city_resolver/by_preference_city_resolver_provider.dart`; do not
  re-implement the priority chain elsewhere.
