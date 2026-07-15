# BE-252 — Navigation cursor picker

**Status:** shipped in `feat/BE-184/change_navigation_vehicle` (2026-Q3)
**JIRA:** [BE-252 — FE - Change Navigation Vehicle](https://wedosolutions-sa.atlassian.net/browse/BE-252)
**Design:** [Figma frame 2076-1419](https://www.figma.com/design/wT7UNN1Pz6UJgMuKwx6xuA/Navigation-Icon-3D?node-id=2076-1419)

## What it is

Adds a *Navigator customization → Cursors* screen where the user picks
which 3D car model the 2GIS SDK draws during turn-by-turn navigation.
Eight choices — one bundled default (`Classic Cursor`) and seven models
that download on demand from OCI Object Storage:

| Design name       | Enum id           | CDN filename          |
| ----------------- | ----------------- | --------------------- |
| Classic Cursor    | `classic`         | *(bundled)*           |
| CEO Rubber Ducky  | `ceo_rubber_ducky`| `ceo_rubber_ducky.glb`|
| The Boss          | `the_boss`        | `the_boss.glb`        |
| Jetpack           | `jetpack`         | `jetpack.glb`         |
| Jeep              | `jeep`            | `jeep.glb`            |
| Jetsons           | `jetsons`         | `jetsons.glb`         |
| Sadu              | `sadu`            | `sadu.glb`            |
| Sadu Bus          | `sadu_bus`        | `sadu_bus.glb`        |

Selecting any non-classic cursor pipes bytes through
[BE-184's dynamic style repack pipeline](../../mapness/lib/features/dynamic_style/dynamic_style_service.dart)
which rewrites `zmap/vidoc/models/day_LIGHT_THEME_CAR_MODEL.glb` and
`.../night_DARK_THEME_CAR_MODEL.glb` inside `styles.2gis` at runtime and
reloads the map. Selecting `Classic Cursor` calls `resetToBundled()` and
the bundled style ships again.

## Architecture

```
NavigationCursor (enum)
  |
  |  cdnFileName?  thumbnailAsset  title(context)
  v
CursorDownloader (Riverpod keepAlive)
  |
  |  download() -> dio -> tmp -> GLB magic check -> rename -> File
  |  isDownloaded() -> File.stat
  |  downloadedIds() -> Set<String>
  v
NavigationCursorController (Riverpod keepAlive, sync Notifier)
  |
  |  state: {active, downloadedIds, inProgress, lastError}
  |  build(): SharedPreferences + Future.microtask(_reconcileWithDisk)
  |  select(cursor): download -> applyOverrides (or resetToBundled)
  v
CursorsPageContent (ConsumerWidget)
  |
  |  Your cursors  = classic + downloaded, tap = select
  |  Available     = the rest, tap = download+select
  |  spinner while inProgress, snackbar on lastError
  |
NavigatorSettings row (Consumer)
  |
  |  actionText = active.title(context)
```

Key files:

- [`mapness/lib/features/navigation_cursor/navigation_cursor.dart`](../../mapness/lib/features/navigation_cursor/navigation_cursor.dart)
  — enum + Localazy title extension + `kCursorCdnBaseUrl` constant.
- [`mapness/lib/features/navigation_cursor/cursor_downloader.dart`](../../mapness/lib/features/navigation_cursor/cursor_downloader.dart)
  — download service with 20s connect timeout, GLB magic validation,
  in-flight coalescing.
- [`mapness/lib/features/navigation_cursor/navigation_cursor_controller.dart`](../../mapness/lib/features/navigation_cursor/navigation_cursor_controller.dart)
  — Riverpod notifier; sync `build()` for zero-loader picker open, disk
  reconcile off the build stack.
- [`mapness/lib/pages/navigator_settings/pages/cursors_page/`](../../mapness/lib/pages/navigator_settings/pages/cursors_page/)
  — auto_route `CursorsRoute` + picker UI.

## CDN layout

- Region: `me-jeddah-1`
- Namespace: `axownvq9lhmx`
- Bucket: `balady-plus-assets`
- Prefix: `cursors/`

Two PARs (Pre-Authenticated Requests), both expire `2027-07-06`:

- **Read-only PAR** — bundled with every build as `kCursorCdnBaseUrl` in
  [`navigation_cursor.dart`](../../mapness/lib/features/navigation_cursor/navigation_cursor.dart).
  Listing is disabled on this one, so leaking it exposes only the seven
  known GLBs. Rotate before the expiry date.
- **Write PAR** — never in git. Kept in Aleksandr's inbox / OCI Console.
  See [`scripts/cdn/`](../../scripts/cdn/) for CRUD helpers that read it
  from `BALADY_CURSORS_WRITE_PAR`.

Thumbnails (`assets/icons/cursors/thumb_*.png`) and the trailing SVGs
(`ic_checkmark.svg`, `ic_download.svg`) ship inside the APK — the design
team can only change them via a release.

## Persistence

Two `SharedPreferences` keys via
[`MapnessConstants`](../../mapness/lib/shared/constants/constants.dart):

- `activeNavigationCursor` — id of the last-applied cursor, restored on
  cold start. Falls back to `classic` if the id is unknown or its GLB is
  no longer on disk.
- `downloadedNavigationCursors` — `List<String>` of ids that have a GLB
  on disk, so the picker can render "Your cursors" instantly without
  awaiting the disk scan.

Actual bytes live in `<app-support>/cursors/<id>.glb` — Application
Support, not Documents (not backed up to iCloud, not user-visible).

## Localazy strings

All strings are in `mapness/lib/l10n/app_en.arb` and `app_ar.arb`,
managed via Localazy CLI (`localazy download` after edits). Full list:

| Key                              | EN                     | AR              |
| -------------------------------- | ---------------------- | --------------- |
| `cursors`                        | Cursors                | المؤشرات        |
| `cursorsAvailable`               | Available              | متاح            |
| `cursorsNavigatorCustomization`  | Navigator customization| تخصيص الملّاح   |
| `selectNavigatorType`            | Select navigator type  | اختر نوع الملّاح |
| `yourCursors`                    | Your cursors           | مؤشراتك         |
| `cursorTitleClassicCursor`       | Classic Cursor         | المؤشر الكلاسيكي |
| `cursorTitleCEORubberDucky`      | CEO Rubber Ducky       | البطة المطاطية   |
| `cursorTitleTheBoss`             | The Boss               | المدير          |
| `cursorTitleJetpack`             | Jetpack                | حقيبة نفاثة      |
| `cursorTitleJeep`                | Jeep                   | جيب             |
| `cursorTitleJetsons`             | Jetsons                | جيتسونز          |
| `cursorTitleSadu`                | Sadu                   | سدو             |
| `cursorTitleSaduBus`             | Sadu Bus               | حافلة السدو      |

## Failure modes

- **Offline mid-download.** `dio.download().timeout(20s)` throws
  `TimeoutException`; controller logs `select: FAILED …`, sets
  `lastError`, spinner clears, snackbar shows the message. Row stays in
  Available with the download icon so the user can retry.
- **Corrupted download.** Post-GET check reads the first 4 bytes and
  refuses anything that isn't the glTF magic `glTF` (`67 6C 54 46`).
  Tmp file is deleted before the exception propagates.
- **App data cleared.** `_reconcileWithDisk` in the controller trims the
  in-memory `downloadedIds` to what's actually on disk and rolls the
  active cursor back to `classic` if its GLB vanished. New prefs are
  written so subsequent boots are consistent.
- **Model rotated on CDN under the same filename.** Currently a no-op
  from the app's perspective — see below.

## Known follow-ups

- **Cache invalidation.** Right now `CursorDownloader.isDownloaded()`
  keys on filename only, so overwriting `sadu.glb` on the bucket does
  *not* propagate to installed apps. Options considered:
  1. Rename on every update (bump `cdnFileName` in the enum + ship).
  2. Firebase Remote Config manifest with per-cursor version integers.
  3. HEAD-check ETags on picker open.
  We picked (1) for now — see the CDN scripts' `rename.sh`.
- **BE-184 debug pane.** [`dynamic_style_debug.dart`](../../mapness/lib/features/dynamic_style/dynamic_style_debug.dart)
  still references `assets/maps/styles/user_models/*.glb` which no
  longer ship in the bundle (moved to CDN). Debug preset will throw
  `PlatformException` from `rootBundle.load`. Not user-facing; the
  BE-184 owner can either delete debug presets or wire them to the same
  downloader.
- **AR translations.** Suggested via Claude, confirmed by product but
  not yet reviewed by a native SA-Arabic proofreader. Fine for QA but
  flag for the localization team before public release.

## QA checklist

- [ ] Picker opens with no loading spinner (sync `build()`).
- [ ] Selecting a bundled `classic` while another cursor is active
  swaps back and repack succeeds.
- [ ] Selecting a not-yet-downloaded cursor shows the spinner, then
  the map recreates with the new model within ~3s on WiFi.
- [ ] Airplane mode → tap a downloadable cursor → snackbar within 20s,
  row remains tappable.
- [ ] Kill/restart preserves the active cursor and downloaded set.
- [ ] Wipe app data → picker opens on classic, previously-downloaded
  entries no longer in "Your cursors".
- [ ] Arabic locale renders all headings + row titles in AR.
- [ ] Rapid successive taps on different cursors do not race the
  in-flight download coalescing (only one at a time; UI blocks tap on
  the busy row).
