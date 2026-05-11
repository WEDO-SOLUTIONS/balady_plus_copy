# AGENTS.md

Guidelines for AI coding agents working in this repository (Balady+ Flutter superapp).

## Tooling

- **Flutter / Dart:** pinned via [FVM](https://fvm.app/) — see `.fvm/fvm_config.json` (currently `3.38.5`). Always invoke `fvm flutter ...` and `fvm dart ...`, never the system `flutter` / `dart`.
- **Formatter:** `fvm dart format -l 120 <files>` — line width is **120**, not the Dart default 80. Lefthook applies this automatically on staged Dart files.
- **Static analysis:** `fvm flutter analyze` from the relevant package directory (usually `mapness/`).
- **Git hooks:** managed by [lefthook](https://github.com/evilmartians/lefthook) (`lefthook.yml`). Do **not** bypass with `--no-verify` unless a human explicitly authorises it.

## Branch naming

Validated by `.lefthook/pre-push/branch-name-validator.sh` (strict on the `urbi-ae/baladi` remote, relaxed elsewhere). Use:

```
<type>/BALADY-<number>/branch_name_here
```

Allowed types: `feat`, `bugfix`, `hotfix`, `test`. The de-facto convention in recently merged PRs on this repo is `fix/BALADY-…/…` (the loose remote permits it). Use only letters, `-`, `_`.

## Commit messages

Validated by `.lefthook/commit-msg/commit-msg-validator.sh` whenever `mapness/` files are staged. Format:

```
<type>(scope?): message
```

Allowed types: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`. Scope is typically the JIRA key, e.g. `fix(BALADY-3580): smooth search panel open on iOS`. Keep the subject line short and imperative.

## Pull requests

- Base branch is the active release branch (currently `release/3.13.0_tfs`).
- Open the PR with `gh pr create --base <release-branch>`.
- Always reference the JIRA key in the title.

## Project shape

- **Main Flutter module:** `mapness/`. Sibling modules: `urbi_map/`, `smart_advisor/`, plus the root workspace `pubspec.yaml`.
- **State management:** Riverpod (`flutter_riverpod` + `riverpod_annotation`, generates `*.g.dart`).
- **Routing:** `auto_route` (generates `*.gr.dart`, e.g. `mapness/lib/app/auto_route/app_routes.gr.dart`).
- **Bottom sheets:** `sheetify` — see `MultiStateSheet` patterns in `mapness/lib/pages/landing/` and `mapness/lib/pages/map_search/`.
- **UI components:** `balady_uikit` (private pub registry `baladyapp-unpub.urbi.ae`).

## Code generation

Run `just prebuild` (or `fvm dart run build_runner build --delete-conflicting-outputs`) when you modify any of:

- `@riverpod` / `@Riverpod` annotated classes,
- `@JsonSerializable`, `@freezed`, etc.,
- `@RoutePage()` annotations on a page class.

Editing the **route list** in `app_routes.dart` (transitions, durations, guards) does **not** require regeneration — the generated `*.gr.dart` only carries `@RoutePage` metadata.

## Safety

- Never edit files in the outer workspace (`../`) — those are workspace-level memory, not project source.
- Never commit secrets (`.env`, signing certs, service-account JSON). The git hooks do not catch every leak.
- Never `git push --force` to a release branch.
