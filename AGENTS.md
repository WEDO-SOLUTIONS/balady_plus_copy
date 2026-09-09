# AGENTS.md

Guidelines for AI coding agents working in this repository (Balady+ Flutter superapp).

## Tooling

- **Flutter / Dart:** pinned via [FVM](https://fvm.app/) — see `.fvm/fvm_config.json` (currently `3.38.5`). Always invoke `fvm flutter ...` and `fvm dart ...`, never the system `flutter` / `dart`.
- **Formatter:** `fvm dart format -l 120 --fix <files>` — line width is **120**, not the Dart default 80. Lefthook applies this automatically on staged Dart files.
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

## Session Context: Navigation, Favourites, Performance

The current work session focused on production-only freezes/jank where the UI disappeared and only the native map stayed visible, plus related Riverpod lifecycle errors and favourites persistence issues.

Detailed context is also split into nearest subtree agent files so future edits pick up feature-specific instructions automatically:

- `mapness/lib/features/favourites/AGENTS.md`
- `mapness/lib/widgets/favourites/AGENTS.md`
- `mapness/lib/shared/lib/auth/AGENTS.md`
- `mapness/lib/pages/landing/AGENTS.md`
- `mapness/lib/widgets/landing/AGENTS.md`
- `mapness/lib/pages/path_nav/AGENTS.md`
- `mapness/lib/features/routing/AGENTS.md`
- `mapness/lib/shared/providers/map/AGENTS.md`
- `mapness/lib/features/ai_summary/AGENTS.md`
- `mapness/lib/features/satellite/AGENTS.md`
- `urbi_map/AGENTS.md`
- `mapness/lib/features/friends_on_map/AGENTS.md`

- Do **not** build a new APK unless the user explicitly asks. The user asked to avoid accidental production APK rebuilds during diagnosis.
- Prefer validating this class of issues in `profile`/`release`, not only `debug`: debug timing can hide router/sheet/auth races.
- Several fixes are intentionally defensive against Riverpod async lifecycle races: check `ref.mounted`/request identity after async gaps, avoid provider writes after dispose, and avoid using `ref` synchronously inside `onDispose` callbacks.
- For provider disposal callbacks that need to mutate other providers, defer the mutation outside the lifecycle callback (for example via `Future.microtask`) instead of calling `ref.read`/state changes directly inside `onDispose`.
- Path navigation fixes in this session targeted stale/partial native navigation state, nullable navigation event subscriptions, mounted checks after async gaps, and ensuring `PathNavPageInitAction.startNavigation` starts native navigation instead of accidentally falling into restore logic.
- Dashboard/map-only freeze investigation identified route/sheet lifecycle races around `LandingPage`, `AutoTabsRouter`, `Drive back home`, `Contribute`, and `PathNavRoute`. Keep the landing subtree mounted when it is merely covered by another route; use `Offstage`/`IgnorePointer`/`TickerMode` instead of returning `SizedBox.shrink()` for covered routes.
- Auth-gated actions should await their async callback. Avoid fire-and-forget navigation callbacks after login because auth invalidations, favourites writes, sheet hiding, and route pushes can otherwise interleave.
- Favourites search selection should await `addItem`/`setHome`/`setWork` before popping the search route. This preserves Hive cache/add-sync ordering and prevents route navigation from racing against provider updates.
- Favourites are now treated as local-first: read Hive cache before auth/remote fetch, persist pending add/delete sync before network calls, keep pending sync on network/invalid-response failures, and do not overwrite non-empty local cache with an empty remote response while sync is pending.
- AI Summary header layout was adjusted for long English/Arabic labels: use constrained `AutoSizeText`/ellipsis in the title and keep the badge compact with `Flexible`, not a full-width `Expanded` gap.
- Indoor floor-plan display is controlled through the `urbi_map` bridge method `setIndoorFloorPlansEnabled`. `DgisController` disables floor plans at map initialization and enables them when visible-rect zoom reaches the configured near-max threshold.
- Satellite base-map ([BE-243](https://wedosolutions-sa.atlassian.net/browse/BE-243)) is a separate `toggleSatellite` bridge in `urbi_map` (not the weather heatmap bridge). The Dart provider is `@Riverpod(keepAlive: true)` because layers-sheet close would otherwise auto-dispose it and the UI would desync from the native raster source on reopen. Tile URL + token live in Firebase Remote Config under `satellite_config` with a bundled default; `{TOKEN}` is substituted Dart-side. See `mapness/lib/features/satellite/AGENTS.md`.
- Friends on Map (BE-213, branch `feat/BE-213/friends-on-map`) is a new feature. Part A (Foundations: activation, permissions, position reporting, global pause, deactivation — BRD S-01/S-02/S-03/S-05/S-06) is done, reached from Profile → Friends on Map, backend mocked. Scope, priority tiers and rationale are tracked in a published roadmap artifact, linked and summarized in `mapness/lib/features/friends_on_map/AGENTS.md`; read that file before starting Part B (friend graph).

Useful verification commands from this session:

```bash
rtk fvm dart format -l 120 <dart-files>
rtk fvm flutter analyze --no-pub <dart-files>
```

Note: in the pinned Dart toolchain used in this session, `dart format --fix` is not available; use `dart format -l 120` unless the toolchain changes.
