# AGENTS.md for `lib`

Read the repository root `AGENTS.md` first. These instructions apply to the main application code under `lib/`.

## Local Architecture

The main app uses a feature-first structure with a mostly Bloc-based UI layer plus `get_it` dependency injection.

Common patterns already in use:

- `flutter_bloc` for feature state in the app shell
- `get_it` via `sl` for DI
- `formz` in validation flows
- `provider` for a few app-wide notifiers
- `MapnessProviderScope` to embed the local `mapness` package into the app runtime

Do not try to force `lib/` into Riverpod-first architecture just because `mapness/` uses it heavily.

## Feature Structure

Most features follow some subset of:

- `data/`
- `domain/`
- `presentation/`
- feature-specific `injection/`, `manager/`, `services/`, `constants/`, or `extensions/`

Preserve the existing structure of the feature you are touching instead of reshaping nearby folders for consistency.

## Entry Points And Environments

- There are multiple app entry points such as `main_dev.dart`, `main_stg.dart`, `main_prod.dart`, `main_pre.dart`, and `main_urbi_pre.dart`.
- Be careful when changing startup, telemetry, env wiring, or `SentryFlutter.init`, because behavior differs by flavor.
- Keep `AppEnv.setupEnv(...)`, `setupMapness(...)`, and the flavor-specific launch flow aligned.

## Dependency Injection

- Prefer existing registration points in `lib/app/core/dependency_injection/`.
- Reuse `sl` registrations when extending existing capabilities.
- Avoid creating hidden singletons or bypassing DI for new dependencies.

## State Management

- In `lib/`, default to existing Bloc/Cubit patterns for app features.
- It is acceptable that the app embeds Riverpod-backed `mapness` code through `MapnessProviderScope`; do not treat that as a reason to migrate app features.

## Guardrails

- Avoid broad rewrites of app startup or dependency injection unless the task explicitly targets them.
- When a change crosses into `mapness`, coordinate both sides of the integration rather than patching only one package.
