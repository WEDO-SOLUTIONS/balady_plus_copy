---
applyTo: "**/*.dart"
---

Follow the nearest `AGENTS.md` and match the local module style instead of enforcing one architecture repo-wide.

When editing `lib/**`, prefer the existing feature-based structure and `flutter_bloc`/`formz`/`get_it` patterns.

When editing `mapness/**`, prefer the existing Riverpod, hooks, AutoRoute, Freezed, JSON serialization, and provider patterns. Do not replace them with Bloc-only implementations unless the task explicitly requires a migration.

Do not hand-edit generated Dart outputs such as `*.g.dart`, `*.freezed.dart`, `*.gen.dart`, `mapness/lib/l10n/generated/**`, `mapness/lib/app/auto_route/app_routes.gr.dart`, or `urbi_map/dgis_map_platform_interface/lib/src/pigeons/messages.g.dart`.

Before adding user-facing strings, check whether the surrounding feature already uses the existing localization flow.

Use a `120`-character line length and add or update targeted tests when behavior changes.
