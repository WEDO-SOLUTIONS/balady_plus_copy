Use the repository-root `AGENTS.md` as the primary project instruction file and treat the nearest nested `AGENTS.md` as higher priority for subtrees such as `mapness/` and `urbi_map/`.

Prefer executable repo config over older prose docs when they conflict. In this repository, `justfile`, `lefthook.yml`, `.lefthook/*`, `analysis_options.yaml`, and `pubspec.yaml` are more trustworthy than legacy workflow documents.

Use FVM-managed Flutter (`.fvmrc` pins Flutter `3.38.5`) and prefer `just` recipes for multi-package setup, codegen, and plugin regeneration.

Match the architecture of the module you are editing instead of forcing one style across the entire repository:

- `lib/` favors `flutter_bloc`, `formz`, `get_it`, and feature folders.
- `mapness/` favors Riverpod, hooks, AutoRoute, Freezed, and providers.
- `urbi_map/` is a Flutter plugin with Dart plus native Android/iOS implementations.

Do not hand-edit generated files such as `*.g.dart`, `*.freezed.dart`, `*.gen.dart`, `mapness/lib/l10n/generated/**`, `mapness/lib/app/auto_route/app_routes.gr.dart`, or the Pigeon outputs under `urbi_map/`.

Before proposing commits or PR changes, respect the real hook rules from `.lefthook`, especially the conventional commit rule for `mapness/` changes and the branch naming constraints used by the push hook.

Never commit secrets from `.env.*`, SDK keys, signing assets, or copied credentials from scripts.
