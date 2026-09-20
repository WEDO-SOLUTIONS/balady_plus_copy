# TIFO — agent context

Territory-capture game on the Balady+ map: buildings are claimed by beating a
penalty-shootout score, districts are tinted by the leading club. BRD digest
lives in `docs/tifo-brd-v2-reference.md` (repo root; supersedes the v1.2
digest — gate order is now tutorial-first, result screen is win/lose with no
scoreline). Jira: BE-233, branch `feat/BE-233/tifo`.
Penalty-game deep dive (state, mechanics, sprite pipeline, history):
[penalty/PENALTY_GAME.md](penalty/PENALTY_GAME.md). The mini-game itself
lives in `penalty/` — everything else in this folder is the map/BRD layer.

## Backend

- Base URL is **pinned to staging** for every app environment (prod included):
  `kTifoBaseUrl` in `data/tifo_api.dart` → `https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/tifo`.
  When the backend ships to prod, re-point that constant (or re-derive from
  `dgisEnvironmentProvider` — the old code is in git history).
- Bearer resolution (`resolveTifoConfig`, per request):
  1. debug override — **only** when the `tifoDebugModeProvider` master switch
     is on (debug panel → "Override system config");
  2. system SSO token (`tokenProvider`) when signed in;
  3. `tifo-guest-<deviceId>` fallback (`deviceInfoProvider`) when signed out.
- The backend 401s on ANY request without a bearer, including read-only
  `/buildings` — but BRD US-01 requires browse without login, hence the guest
  fallback. Staging treats the bearer as an **opaque user id**: any string
  works, identity = the string. Consequences: guest progress does not carry
  over after sign-in; an SSO token refresh would also mint a "new user" on
  staging.
- Endpoints: `/buildings?bbox`, `POST /buildings/by-ids` (≤500), `/districts`,
  `/districts/summary`, `/leaderboards?scope=clubs`, `/config`, `/me`,
  `/clubs`, `/clubs/select`, `/buildings/{id}/play/start`,
  `POST /buildings/{id}/play`.
- Play submit `events` shape is `{kick: <1-based index>, result: 'goal'|'miss'}`
  — anything else gets the session **voided** server-side.
- `TifoApi` owns a private `Dio`, so its traffic does NOT appear in the app's
  http logger. All TIFO diagnostics go through `logger.log` with a `[tifo]` /
  `[tifo-map]` prefix — grep the console for that.

## Map layer (`tifo_buildings_map_layer.dart`)

- Zoom LOD, three tiers: region silhouette ≤ 9, district mosaic 10–15,
  buildings ≥ 16. Those are the DEFAULTS of `TifoLodZoomThresholds`
  (`data/tifo_debug_lod_zoom.dart`) — the debug panel ("Map LOD zoom levels")
  moves the two switch points at runtime, in memory, and the class keeps the
  tiers ordered and non-overlapping. NB: the thresholds are compared against
  `visibleRectEvent.zoom`, which reads ~1 lower than
  `getCameraPosition().zoom`, so buildings open at a camera zoom of ~17 — any
  `moveCamera` meant to land in buildings mode has to account for that (see
  `district_sheet.dart`). Full breakdown of every zoom value the layer keys
  off: [ZOOM_LEVELS.md](ZOOM_LEVELS.md).
- Buildings **accumulate**: polygons are never removed on pan, only added and
  pointwise-recolored (owner change via 20 s poller `tifo_buildings_poller.dart`
  → `POST /buildings/by-ids`). Hard cap `_maxRendered = 2000`.
- The shared dgis `MapObjectManager` uses generalization
  (`logicalPixel=100, maxZoom=18` in the native plugin) — below zoom 18 nearby
  polygons get spatially thinned. That is why "not all polygons show" at
  street zoom; fixing it means a plugin change (lower logicalPixel or a
  non-generalized manager), not a Dart-side change.
- `enable()` retries the bbox up to 6×250 ms because the map often can't
  report its visible area right after start — without it the first render
  waits for a manual pan.

## First-launch journey (wired in `widgets/landing/tifo_control.dart`)

⚽ tap → entry popup → CTA → layer on → gate walk (BRD FR-04: route to the
first unmet step; Close(X) leaves the map untouched):

- `entry_screen.dart` — stories hero (Figma node 286:20818), asset
  `assets/tifo/backgrounds/entry_hero.jpg`. Shown once per session
  (`hasSeenEntry`, in-memory).
- The gate walk (`tifo_journey.dart`, also behind the pill and building
  "Challenge"): **login → tutorial started → team selected** (FR-03), each
  step re-read from `tifoSessionProvider` after it runs. Login opens the
  host flow (`tifo_login.dart`) and stops the walk while `isGuest` stays
  true (staging lazily registers a profile for the guest bearer, so the
  profile alone can't tell — see `resolveTifoConfig`). The tutorial gate
  pushes the guided tour, then marks the device (Hive) and server flags
  **right after the tour is shown — regardless of whether the user finished
  it or closed/skipped it** (BR-02: starting the tutorial clears the gate
  forever, complete or skip; only a genuine session loss — crash,
  disconnect, force-quit, BR-06 — leaves it unmet, and that path never
  reaches the persistence call at all since the process dies mid-await).
  Previously this only persisted after a full completion, so skipping
  re-triggered the tour on every later play attempt — fixed 2026-08-04.
- `tutorial/tifo_guided_tutorial.dart` — **four**-screen tour (Figma 848:9497
  standings tooltip → 848:9982 penalty preview → 848:10725 intro sheet →
  879:10224 support), cut down from the earlier 13-step sequence
  (589:85440 → 721:126548) which walked every sheet. Transparent route: steps
  with no background show the live map behind a `ModalBarrier`; the rest are
  static replicas from `tutorial/tifo_tutorial_demos.dart` (canned data, no
  backend calls). The replicas the four screens no longer use
  (`TifoDemoDistrictSheet`, `TifoDemoBuildingSheet`, `TifoDemoPenaltyHud`,
  `TifoDemoProfile`, `TifoDemoTeamSelect`) are kept on purpose — design has
  re-cut this sequence twice already.
- Support screen (tour step 4, `TifoDemoSupport`) is what the ⚽ "?" control
  opens (`initialStep: TifoGuidedTutorial.lastStep`). Its **"Replay tutorial"**
  CTA rendered permanently disabled up to build 3.30.1 (876) because the
  replica passed no `onPressed`; it now calls
  `TifoFlowController.resetTutorial()` (clears the Hive `tutorialCompleted` /
  `tutorialOffered` flags + in-memory `hasSeenTutorial`) and rewinds the route
  to screen 1. When that replayed run ends — finished or skipped — the tour
  re-stamps `markTutorialCompletedOnDevice()`, otherwise the cleared device
  flag would re-gate the player into the tour on the next play attempt (or
  right after a sign-in, which mints a fresh profile on staging). The server
  flag is not reset: `/tutorial/complete` is one-way, there is no undo
  endpoint — fixed 2026-08-18.
- `TifoJoinPill` ("Dominate with your team →", node 589:85824) renders
  whenever the TIFO layer is on **and** the player hasn't cleared every play
  gate yet (`!TifoSessionState.isPlayReady`, i.e. `nextStep != ready`) — it
  targets any not-play-ready session, not just the first-ever launch.
  Previously this was gated by a one-shot persisted `hasLaunched` Hive flag
  (`TifoFlowController.markGameLaunched`), so it silently stopped appearing
  after the very first session even for a player who still hadn't picked a
  team — fixed 2026-08-10.
- Legacy: `tifo_tutorial_sheet.dart` (intro sheet, no longer auto-offered —
  the journey owns the tutorial gate; `consumeTutorialOffer` and its Hive
  flag are orphaned), fullscreen `tifo_tutorial.dart` + debug
  `tifo_ball_button.dart` — deletion candidates.

## Analytics

All TIFO analytics goes through `TifoEvents`
(`mapness/lib/features/balady_analytics/events/tifo_events.dart`) — never call
`BaladyAnalytics.instance.track` directly from TIFO code. The event set is exactly
the six of Event Spec v1 (`tifo_activated`, `tifo_tutorial_outcome`,
`tifo_entry_outcome`, `tifo_surface_viewed`, `tifo_blocked`, `tifo_play_exit`) and is
documented in `docs/analytics-tracking-plan.md` ("Phase 2 — TIFO"); an event added to
code is added to the tracking plan in the same PR. Event names are immutable — PostHog
cannot rename retroactively. `tifo_blocked(error)` also covers silent tier-load
failures, and `tifo_play_exit` carries the server `outcome` on completed games. No
`identify` calls from TIFO. No raw timings —
`api_ms`/`render_ms` are bucketed inside `TifoEvents`, never sent as numbers. No
coordinates, no building names, no TIFO-side user id. Caps (1/lifetime,
once-per-surface-per-session, 30 s debounce on `tifo_blocked`, one `tifo_play_exit`
per game) are enforced inside `TifoEvents`, not at call sites. `$screen` events are
off app-wide, so a TIFO surface that matters for product decisions needs an explicit
`tifo_surface_viewed` — it will not show up for free. The spec's `TifoSurface` name
collides with the existing `tifo_surface.dart` (the visible-route snapshot used by
the play gate); a file that needs both imports `tifo_surface.dart` with a prefix
(`as route`, see `tifo_journey.dart`) or `tifo_events.dart` with `show` (see
`tifo_control.dart`).

## Design system (`ui/tifo_theme.dart`)

- Tokens from Figma file `4e6yzc8zSDvJpMsTuthX8n` (the "Tifo (Copy)"
  `H4Dv…` file hits MCP rate limits on the Starter plan — use the original).
- Font: Golos, shipped in `balady_uikit` — every `TextStyle` needs
  `fontFamily: 'Golos', package: 'balady_uikit'` (TifoText does this).
- `TifoPrimaryButton` matches design node 398:8792: h48, radius 16, green glow
  `0 4 10 rgba(22,163,74,0.3)` (off while disabled), 16 px trailing arrow.
- Design shows 5 anonymized teams (Blue/Yellow/Black/Red/Sand); the backend
  serves 4 named clubs (al-hilal/al-nassr/al-riyadh/al-shabab). Demo palette
  constants live in `tutorial/tifo_tutorial_demos.dart`; live club colors come
  from `/clubs`.

## Workflow gotchas

- `custom_lint` plugin is broken in this repo: to analyze, temporarily strip
  `plugins:\n    - custom_lint` from `mapness/analysis_options.yaml`, run
  `/Users/ve/fvm/versions/<ver>/bin/dart analyze`, then **restore the exact
  original file** (`git checkout -- mapness/analysis_options.yaml` is the
  safest restore — a stale backup once corrupted it).
- Always `fvm dart format -l 120`.
- New assets/files require a full `flutter run` rebuild — hot reload won't
  pick them up.
- 274 pre-existing style infos live in older TIFO files (`penalty_game.dart`,
  `tifo_tutorial.dart`); don't chase them when analyzing new work.

## Known issues / follow-ups

- Entry hero art is a low-res export — request a proper asset from design.
- RenderFlex overflow ~74–105 px on small screens in one of the new sheets.
- Tutorial copy for frames 02–04 reused from old step texts — verify against
  the mocks.
- dgis `PlatformException(ObjectTapError)` spam on map taps — plugin-side,
  unrelated to the polygon layer.
- Polygon thinning below zoom 18 (see Map layer above) — needs a plugin call
  if full density is required.
- Team id slug vs camelCase mismatch between design and backend — reconcile
  with Jiad/Ibrahim.
