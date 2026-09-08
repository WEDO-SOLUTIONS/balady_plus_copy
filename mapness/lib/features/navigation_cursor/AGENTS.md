# AGENTS.md — navigation_cursor

Instructions for agents editing this directory. See
[`docs/features/BE-252-navigation-cursors.md`](../../../../docs/features/BE-252-navigation-cursors.md)
for the full feature writeup — this file only captures the constraints
that shape edits inside `navigation_cursor/`.

## Ground truth

- `NavigationCursor` enum is the **single source of truth** for the
  catalog. Every new cursor needs: `id` (kebab-case, never renamed),
  `cdnFileName` (or `null` for bundled), `thumbnailAsset`, an entry in
  `NavigationCursorL10n.title()` (compile-time exhaustive switch), and
  a matching Localazy key `cursorTitle<PascalCase>`.
- The `id` field is a persistence key. Once shipped, do NOT rename it —
  users who saved that cursor as active would fall back to `classic` on
  next boot.
- Local cache filenames are derived from `id`, not `cdnFileName`, so
  renaming a GLB on the CDN does not touch existing installs. If you
  need to force refresh, rename the enum id **and** ship — but that's a
  breaking change for persisted state; prefer a version manifest.

## Style-swap pipeline

Selecting a cursor pushes its GLB bytes straight to the live map:
`DgisMapController.setNavigationCursorModel(bytes)` → native
`MyLocationMapObject.setModelData` (2GIS SDK 12.8). No style repack, no
`Map.close()`, no MapView recreate — the route, maneuvers, camera and
follow mode are never touched, which is what closed the white-flash bug
(BALADY-3772). Downloaded cursors ship one mesh for both appearances.

Classic is not downloaded: its day/night meshes are read out of the
bundled style archive on demand and cached in memory —

- `zmap/vidoc/models/day_LIGHT_THEME_CAR_MODEL.glb`
- `zmap/vidoc/models/night_DARK_THEME_CAR_MODEL.glb`

exposed as `kNavigationCursorCarModelPaths` (index 0 = day, 1 = night).
Do not hardcode them; read the constant.

The model is not part of the style any more, so it has to be re-applied
whenever a map (re)initialises and whenever day/night flips:
`DgisController` calls `NavigationCursorController.applyActive(controller)`
in both places. `select()` also handles "no live map yet" by persisting
the choice — `applyActive` picks it up on the next map init.

`features/dynamic_style/` (repack/store/debug switcher) is unrelated to
cursors now and remains BE-184's territory.

## Controller lifecycle rules

- `NavigationCursorController` is a **sync** `Notifier`, not
  `AsyncNotifier`. `build()` returns immediately with an optimistic
  state derived from SharedPreferences; the disk scan runs off the
  build stack via `Future.microtask(_reconcileWithDisk)`. Do not
  convert it to async — the picker used to show a permanent spinner
  when a background await inside `build()` hung.
- `select()` writes state twice: once to flip `inProgress` immediately,
  once when download+apply finishes (or fails). Always await both
  transitions in tests, not just the outer `select` call.
- `CursorDownloader` coalesces in-flight downloads by
  `NavigationCursor` key. Do not clear `_inFlight` from anywhere else.
- The download uses `dio.download(...).timeout(Duration(seconds: 20))`.
  Without the outer timeout the future never rejects when DNS fails on
  a mobile device — do not remove it.

## CDN string

`kCursorCdnBaseUrl` is the OCI read-only PAR baked into the app. It's
public by design (listing disabled on the read PAR, only known
filenames are reachable), but keep it in this single constant so
rotation is a one-line change. Do NOT embed the write PAR anywhere in
this directory or elsewhere in the repo — it goes into
`~/.config/balady/cdn.env` or shell env only. See
[`scripts/cdn/`](../../../../scripts/cdn/).

## Localazy

All titles are managed in Localazy. Edit `mapness/lib/l10n/app_*.arb`
locally only for review builds; the source of truth is the Localazy
project, sync via `localazy download` from the repo root. Keys used by
this feature are all under the `cursor*` / `yourCursors` /
`selectNavigatorType` namespace — see the feature doc for the full
table.

## Testing this feature

- `fvm dart format -l 120 lib/features/navigation_cursor`
- `fvm flutter analyze --no-pub lib/features/navigation_cursor`
- Codegen: after touching `@Riverpod` annotations, run
  `fvm dart run build_runner build --delete-conflicting-outputs` from
  `mapness/`. The controller uses `@Riverpod(keepAlive: true)`; the
  provider must survive route pops so the picker doesn't rebuild from
  scratch when the user backs out and returns.
- For end-to-end verification, drive the picker on a real device
  (offline + online) — the in-emulator run showed why the connect
  timeout was necessary.
