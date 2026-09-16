# Ardah — concept & delivery plan (rhythm game)

Status: **concept**, no code written yet. Owner: TBD. Jira: TBD.
Companion reading: [tifo-brd-v2-reference.md](tifo-brd-v2-reference.md),
[../mapness/lib/features/tifo/AGENTS.md](../mapness/lib/features/tifo/AGENTS.md),
[../mapness/lib/features/tifo/penalty/PENALTY_GAME.md](../mapness/lib/features/tifo/penalty/PENALTY_GAME.md).

---

## 1. What it is

**Al-Ardah** (العرضة) — the Saudi ceremonial sword dance: two facing rows of
performers, drummers (`zeer`/`takhmir`) between them, a chanted poem, swords
raised on the beat. It is a *national heritage performance*, not a folk game —
tone matters (see §11 Risks).

The game is a **rhythm / timing game**: the player keeps the row in sync with
the drums. This is the second standalone game in Balady+ after TIFO, and the
first one that is **not** tied to the map — it is a self-contained fullscreen
experience launched from a seasonal entry point (Founding Day 22 Feb, National
Day 23 Sep, cultural city events).

Deliberate contrast with TIFO:

| | TIFO | Ardah |
|---|---|---|
| Surface | map overlay + mini-game | fullscreen only |
| Session | long, territorial, social | 60–120 s runs |
| Backend | required (buildings/districts/clubs) | optional — P0/P1 fully local |
| Seasonality | permanent | event-gated (`CityEventDateRange`) |

---

## 2. Core loop

```
entry hero → (tutorial once) → chart select → calibration (first run only)
  → 60–120 s run → result + grade → retry / leaderboard → back
```

### Mechanics

- **Lanes.** 3 lanes = the three drum voices (deep `zeer`, mid, hand-clap).
  Notes travel toward a judgment line synced to the actual audio track.
- **Note types.**
  - `tap` — single hit on the beat.
  - `hold` — sword **raise**: press on the downbeat, release on the accent.
  - `flourish` — swipe across the chorus accent (the sword twirl), one per
    section, worth a large bonus.
- **Judgment windows** (tunable, starting values): `perfect ±45 ms`,
  `good ±90 ms`, `late/early ±140 ms`, beyond that `miss`.
- **Sync meter** replaces "lives": misses drain it, perfects refill it. At zero
  the row "breaks formation" → run ends early. Never shown as a personal
  failure — the framing is *the row loses sync*, not *you lose* (§11).
- **Scoring.** `note score × combo multiplier` (×1 → ×2 → ×3 → ×4 at 10/25/50
  combo) + flourish bonus. Result screen shows **accuracy %** and a grade
  (`S / A / B / C`), plus max combo. Accuracy, not raw score, is the number we
  put on the leaderboard — it is BPM-independent and cheat-resistant.
- **Difficulty.** Per chart: `easy / normal / hard` variants of the same track
  (note density only, never speed changes mid-run).

### What it is NOT (scope guard)

No free-form dance capture, no camera/AR, no pose detection, no multiplayer
sync. All three are plausible v2 ideas and all three are 10× the cost.

---

## 3. Screens

| # | Screen | Notes |
|---|---|---|
| 1 | Entry hero | Stories-style, same shape as `tifo/entry_screen.dart`. Shown once per session. |
| 2 | Tutorial | 3 static frames (tap / hold / flourish) + one guided run on a 20 s chart. Gate flag persisted in Hive — reuse the TIFO lesson: mark it **as soon as the tour is shown**, not on completion. |
| 3 | Chart select | Track cards: title, difficulty, best grade, locked/unlocked. |
| 4 | Calibration | Audio-offset wizard — tap along to 8 bare beats, store median delta per device. First run only, re-openable from settings. **Non-negotiable**, see §7. |
| 5 | Gameplay | Flame surface + Flutter HUD overlay (score, combo, sync meter, pause). |
| 6 | Pause | Resume / restart / quit. Must hard-pause the audio clock. |
| 7 | Result | Grade, accuracy, max combo, best-run delta, retry CTA. Same one-hero-per-outcome pattern as `penalty_result_screen.dart` is an option if design bakes art. |
| 8 | Leaderboard | P1: local best runs. P2: server, scoped to the event. |

---

## 4. Code layout

This describes **option A** (the game written in Dart/Flame and embedded in the
app). If the spike picks the HTML mini-app of §6, this layout is replaced by
§6.5 — read both before starting.

Two layers, split for the reasons in §5: a **standalone package** holding the
game itself, and a thin **host feature** inside `mapness` that wires it into
the app. The structural fix TIFO wants is applied from day one — the game is
split into files (`penalty_game.dart` is 7 607 lines in one file, a known
cleanup).

```
ardah_game/                      # workspace package — no mapness/uikit/SSO deps
  lib/
    ardah_game.dart              # public entry: ArdahGameApp(config, backends)
    game/
      ardah_game_widget.dart     # FlameGame: components + input, no tuning consts
      ardah_conductor.dart       # the audio clock (§7) — the heart of the game
      ardah_judge.dart           # windows, combo, sync meter, scoring
      ardah_note_component.dart
      ardah_hud.dart             # Flutter overlay, not Flame text
      ardah_tuning.dart          # every magic number, one file
    data/
      ardah_chart.dart           # chart model + JSON parsing + validation
      ardah_models.dart          # run result, grade, leaderboard entry
    ports/
      ardah_audio_backend.dart   # interface — the host injects the engine
      ardah_score_store.dart     # interface — Hive on the host side
      ardah_analytics_sink.dart  # interface
      ardah_l10n.dart            # interface — strings passed in, not looked up
  example/                       # standalone app: the latency lab (§5.3)
  test/                          # conductor + judge, pure Dart, fake clock

mapness/lib/features/ardah/      # host feature — everything app-specific
  AGENTS.md                      # feature context, written with the first PR
  ardah_entry_screen.dart        # screen 1
  ardah_chart_select_screen.dart # screen 3
  ardah_calibration_screen.dart  # screen 4
  ardah_result_screen.dart       # screen 7
  ardah_leaderboard_sheet.dart   # screen 8
  ardah_journey.dart             # gate walk: tutorial → calibration → play
  ardah_flow_provider.dart       # one-shot Hive flags (tutorial/entry/calibration)
  ardah_surface.dart             # copy of TifoSurface — route-visibility guard
  adapters/
    ardah_audio_backend_impl.dart # engine → routed through the session owner (§5.2)
    ardah_score_store_impl.dart   # Hive: best runs, calibration offset
    ardah_analytics_impl.dart     # balady_analytics
    ardah_l10n_impl.dart          # arb strings → the package's interface
  data/ardah_api.dart            # P2 only
  providers/
    ardah_session_provider.dart
    ardah_charts_provider.dart
  ui/ardah_theme.dart            # tokens from Figma, Golos via balady_uikit
```

Plus one piece that is **not** Ardah's and benefits the whole app:
`mapness/lib/shared/audio/app_audio_session.dart` — the single audio-session
owner from §5.2.2, which TIFO and the radio also move onto.

Assets: `mapness/assets/ardah/{audio,charts,sprites,backgrounds}` registered in
`mapness/pubspec.yaml`. New asset dirs need a **full rebuild** — hot reload will
not pick them up (same footgun as TIFO).

### Entry point & gating

- Seasonal window like Founding Day / Leap: add `ardahDateRange` to
  `CityEventDateRange` in `mapness/lib/shared/config/environment_config.dart`
  (+ a bundled default), read it through `dgisEnvironmentProvider`, and add a
  debug override provider modelled on
  `mapness/lib/features/founding_day/founding_day_debug.dart`.
- Surface: a dashboard/city-event tile. No map layer, no map control — Ardah
  does not touch `MapObjectManager` at all.
- Navigation: fullscreen `MaterialPageRoute` push (what TIFO does for its game
  screens — TIFO has **no** entries in `app_routes.dart`). If we want deep
  links later, `@RoutePage` + `just prebuild` codegen.
- **Pause the map** before the run: the dgis surface behind a fullscreen Flame
  game is pure battery/memory cost on low-end devices.

### Existing infra we get for free

SSO (`tokenProvider`), Hive (`shared/providers/hive.dart`), l10n
(`mapness/lib/l10n/app_*.arb` — **managed by Localazy**, arb files are not in
git; add keys through the Localazy flow), `balady_uikit`, logger, analytics.

---

## 5. Packaging & audio ownership

Asked directly: *can we ship Ardah as a separately pluggable module so we have
no sound problems?* Short answer: **packaging is worth doing, but it is not
what fixes the sound.** The two need to be decided separately.

This section describes the in-app (Dart/Flame) path and the audio facts that
hold regardless of path; §6 covers the HTML mini-app alternative, which removes
most — not all — of what follows.

### 5.1 The sound problem is process-global, not architectural

iOS `AVAudioSession` is per **process**; Android audio focus is per **app**. A
separate Dart package does not get its own audio session — splitting the code
changes ownership, not the OS.

And this app already has a loaded audio stack:

- `just_audio_background` is a process-wide singleton, initialised by the MBC
  radio feature (`stream_audio/services/audio_service.dart`, `JustAudioBackground.init`).
- The radio configures the app-wide session by hand — `playback` category with
  `mixWithOthers | allowBluetooth` — plus a native coordination bridge
  (`ios/Runner/AudioCoordinationManager.swift`, channel
  `com.balady.audio_coordination`) that keeps radio and 2GIS navigation voice
  from killing each other. The comments there are explicit that the wrong flag
  combination "kills our audio session".

TIFO already walked into every consequence of this (see `penalty_game.dart`
`_startAmbience` and PENALTY_GAME.md §Audio):

1. Every `AudioSource` must carry a `MediaItem` tag, because
   `just_audio_background` asserts it app-wide — `setAsset()` without a tag
   throws, gets swallowed, and reads to the user as **silent "no sound"**.
2. A second `AudioPlayer` for SFX throws *"supports only a single player"* on
   iOS — hence TIFO's one shared SFX player. A rhythm game wants many
   concurrent short voices, so this limit is fatal for us, not inconvenient.
3. On entry, TIFO calls `AudioSession.configure(AudioSessionConfiguration.music())`,
   **overwriting the radio's hand-tuned configuration**, and nothing restores
   it on exit. That is a live cross-feature bug today, not a future risk.

Building Ardah on `just_audio` reproduces all three. This is the real "проблема
со звуками", and no amount of module boundaries removes it.

### 5.2 What actually fixes it — three independent decisions

1. **Do not use `just_audio` for the game.** Candidates for the spike:
   `flutter_soloud` (its own mixer, sample-accurate position, many concurrent
   voices — the natural fit for a rhythm game) or `flame_audio` / `audioplayers`
   (simpler, pooled SFX, less control). Whichever wins, it must be verified
   *with the radio running*, because every engine ultimately touches the same
   process-global session — which is why point 2 is not optional.
2. **One audio-session owner in the app.** A new
   `mapness/lib/shared/audio/app_audio_session.dart` becomes the only place
   allowed to call `AudioSession.configure`. Features request a named profile
   (`radioPlayback`, `gameplay`, `navigationVoice`); the coordinator applies it,
   refcounts holders, and **restores the previous profile on release**.
   Retro-fit TIFO onto it in the same PR — that closes the existing bug in
   §5.1(3) instead of adding a second offender.
3. **An explicit "radio is playing, a game starts" policy.** Duck the radio,
   pause it with resume-on-exit, or let it play and mute the game's music?
   Product decision (§12). Navigation voice is not a choice: it always wins —
   it is safety-relevant.

### 5.3 What separate packaging IS good for

Ship Ardah as a workspace package `ardah_game/` that does **not** depend on
`mapness`, `balady_uikit` or the SSO stack. Everything host-specific enters
through interfaces the package declares — `ArdahAudioBackend`,
`ArdahScoreStore`, `ArdahAnalyticsSink`, `ArdahL10n` — and `ardah_game/example/`
is a standalone Flutter app that runs the game and nothing else.

Real wins, in order of value:

1. **A latency lab.** Timing work happens in `example/`, where there is no
   radio, no map, no SSO — and a `flutter run` takes seconds instead of a full
   superapp build. Nothing else on this list matters as much.
2. **The audio backend becomes swappable.** `example/` injects the raw engine;
   the superapp injects an implementation that goes through the session
   coordinator (§5.2.2). Changing engines later never touches game code.
3. **Testability.** Conductor and judge stay pure Dart — unit-testable against
   a fake clock, no device needed.
4. **An exit ramp.** If the superapp's audio constraints turn out to be fatal,
   the same package ships as a standalone app with no rewrite.

Honest limits, so nobody is surprised later:

- The package's native plugins still link into the superapp binary, and pub
  still resolves **one app-wide dependency graph**. A version conflict between
  the game's engine and `just_audio` / `audio_session` is still possible —
  check it in the spike, do not assume it away.
- Green in `example/` says nothing about behaviour with the radio playing.
  **Every audio change is re-verified inside the superapp**, on both platforms,
  with radio active and with navigation voice active.
- Genuine OS-level isolation exists only in a separate binary (standalone app
  or add-to-app). If the spike says the superapp cannot host a rhythm game's
  audio, that is the fallback — and this packaging is what makes it cheap.

### 5.4 Spike — do this before P0 (3–5 days, both paths)

Build the **same metronome-and-tap test twice** — once in Dart/Flame
(`ardah_game/example/`), once as a plain HTML page (§6) — and measure both on
the same devices. The extra days are cheap next to rebuilding the game.

1. Standalone: measure real round-trip latency on a low-end Android and an
   iPhone. Record the **median and the spread** — constant offset is
   calibratable, jitter is not.
2. Embedded in the superapp **with the radio playing**: does the game get sound
   at all; does the radio survive; does navigation voice still interrupt
   correctly; what happens on backgrounding, on an incoming call, and on the
   iOS mute switch. For the HTML path also check `AudioContext` suspend/resume
   and sustained frame pacing inside the WebView on a low-end Android.
3. Output: latency median and spread per device per path, conflicts found, and
   a path + engine recommendation. This is the go/no-go gate for the concept.

---

## 6. Delivery option B: an HTML mini-app

Asked directly: *what if the game is just a separate HTML?* This turns out to
be the strongest option on the table, because the superapp **already ships a
production mini-app engine** — we would be using an existing channel, not
inventing one.

### 6.1 The channel already exists

`lib/mini_apps_engine/` + `lib/super_app_js_bridge/`:

- A versioned archive per `serviceKey` is downloaded, extracted, and served
  from a **local HTTP server** (`server/CustomInAppLocalhostServer.dart`, shelf)
  on a deterministic per-app port with unsafe-port avoidance
  (`helper/port_helper.dart`), then loaded as `http://localhost:<port>/`.
- The WebView is `webview_flutter` with a **dsbridge** JS bridge, and WKWebView
  is already created with `allowsInlineMediaPlayback: true` and
  `mediaTypesRequiringUserAction: {}` — inline autoplay works out of the box.
- The bridge already exposes SSO tokens, user profile, location, camera, file
  picker, share, analytics (`trackEvent` / `trackLogs`), navigation back into
  the superapp, calendar, permissions, deep links and `downloadAndExtractInAssets`.
- After the first download the game runs from localhost — **offline by
  construction**, which is exactly what a crowded Founding Day event needs.

### 6.2 What this fixes outright

1. **The whole of §5.1 disappears from the game's side.** No
   `just_audio_background`, no mandatory `MediaItem` tags, no iOS
   "supports only a single player" limit. WebAudio gives many concurrent
   voices for free — the thing a rhythm game actually needs.
2. **A better clock than the Flutter stack offers.** `AudioContext.currentTime`
   is a sample-accurate audio clock, and notes are scheduled ahead with
   `source.start(when)` instead of chased with a polled position. The
   conductor of §7 becomes simpler *and* more accurate.
3. **Over-the-air updates.** Charts, audio, tuning — even the whole game —
   ship without a store release. For a date-gated event game this is the
   strongest single argument: a broken chart is fixed the same day, not in the
   next release train.
4. **No new Flutter dependencies, no new native plugins**, and none of the
   shared-pub-graph risk listed in §5.3.
5. **Parallel team and reuse.** Web developers build it off the Flutter release
   train, and the same build can run on a campaign page or a shared link.

### 6.3 What it does NOT fix, and what it adds

1. **The iOS session is still process-global.** WKWebView audio plays under the
   app's `AVAudioSession`, so the radio's category still decides whether the
   game is audible; an interruption (call, navigation voice) suspends the
   `AudioContext`, and the page must `resume()` on `statechange` /
   `visibilitychange`. The session owner of §5.2.2 shrinks — it does not vanish.
2. **Output latency is usually worse in a WebView than native**, most of all on
   Android, where WebAudio does not get the low-latency audio path. Calibration
   absorbs a *constant* offset; it cannot absorb **jitter**. Jitter is the
   make-or-break measurement of the spike.
3. **Input latency and frame pacing.** Touch → JS adds delay, and on Android the
   WebView is a platform view composited into Flutter. Mitigations belong in the
   brief from day one: canvas rendering (never DOM nodes per note),
   `requestAnimationFrame`, `touch-action: none` with pointer events, a
   fullscreen WebView with no Flutter widgets layered on top, and no layout
   work mid-run.
4. **No haptics.** The Vibration API is unavailable in WKWebView and the bridge
   has no `vibrate` method today. Adding one is trivial — but it is a *native*
   change, so the "updates without a release" property has a boundary worth
   knowing.
5. **First-run download at the event.** The engine downloads a versioned zip
   with progress; audio is the heavy part. Budget the size, allow retry, and
   consider pre-bundling the Founding Day chart.
6. **Governance.** Bridge capabilities are gated by
   `checkAppRequirement(serviceKey, …)`, but every method in
   `js_bridge_listener.dart` currently hardcodes `serviceKey = "municipalservice"`
   with the real per-app value commented out — so any mini-app is evaluated
   against the municipal permission set rather than its own. Ardah needs **none**
   of those capabilities (keep its bridge surface empty), but this should be
   raised with the mini-apps owners on its own merits.

### 6.4 Flame in-app vs HTML mini-app

| | Flame in `mapness` | HTML mini-app |
|---|---|---|
| Audio stack | fights `just_audio_background` (§5.1) | own WebAudio context |
| Clock quality | polled position + interpolation | sample-accurate, schedule-ahead |
| Concurrent SFX | 1 player on iOS without a new engine | unlimited |
| Output latency | native path, best case | WebView path, usually worse |
| Input / frame risk | low (Flame on a Flutter surface) | **the main risk** (platform view) |
| Update without release | no | yes |
| Offline | yes (bundled assets) | yes (after first download) |
| Haptics | yes (`vibration`) | needs a new bridge method |
| App size | grows the APK | stays out of the binary |
| Team | Flutter devs, on the release train | web devs, in parallel |
| Reuse outside the app | none | campaign page, shared link |
| Delivery channel | to be built | **already in production** |

**Recommendation: default to the HTML mini-app, keep Flame as the fallback,
and let the spike decide** — the same metronome, both paths, the same devices.
Running the spike twice costs a couple of extra days; guessing wrong costs a
rebuilt game.

### 6.5 What changes in the plan if HTML wins

- The `ardah_game` package of §4 becomes a **web project** instead of a Dart
  one. The ports idea survives in spirit: the game talks to a thin adapter
  layer, which is either a stub (standalone page) or the dsbridge JS bridge
  (inside the superapp).
- The `mapness` host feature shrinks to an entry tile, the seasonal gate, and a
  mini-app launch by `serviceKey` — no Flame, no audio adapter, no Hive store
  (scores live in the web app's own storage, or on the backend).
- §5's latency lab becomes a plain web page served over localhost — the same
  role, less machinery.
- The audio-session owner (§5.2.2) is still worth doing, both for the §5.1(3)
  TIFO bug and for the `AudioContext` suspend/resume case in §6.3(1).

### 6.6 The prototype in this repo

`ardah_web/` is the HTML path, playable today — the web half of the §5.4 spike
rather than a mock-up. It runs in any browser and inside the mini-app WebView
from the same files, with no build step, no dependencies and no network.

What is already the real thing: the conductor (audio-clock master, 180 ms
schedule-ahead, judge/visual clocks kept separate), the judge (windows, combo,
accuracy, sync meter — pure logic, no canvas), the chart format and its
validator, the calibration wizard, and the input path with queueing correction.
What is placeholder and must not ship: synthesised percussion instead of
licensed audio, drawn silhouettes instead of reviewed artwork, generated charts
instead of authored ones.

It carries the latency lab described in §5.3, so the numbers that decide §6.4
can be collected now: run it in a browser, then in the superapp WebView with
the radio playing, and compare `mean` (calibratable) against `jitter`
(not calibratable). See `ardah_web/README.md`.

---

## 7. The one hard technical problem: the audio clock

Every rhythm game lives or dies here. The rules below are written for the
in-app path; on the HTML path (§6) the same principles apply with better
primitives — `AudioContext.currentTime` *is* the master clock, and notes are
scheduled ahead rather than polled — which is one of that path's main arguments.

Rules for this codebase:

1. **The audio position is the master clock.** Never accumulate Flame's frame
   `dt` — it drifts by tens of ms per minute. `ArdahConductor` samples
   `ArdahAudioBackend.position` and interpolates between samples with a
   `Stopwatch`, re-syncing when the sampled position deviates beyond a
   threshold. How coarse those samples are is an engine property — with
   `just_audio` it is ~200 ms, a dedicated engine reports far tighter — so the
   spike (§5.4) must measure it, and the interpolation must hold regardless.
2. **Per-device offset is mandatory.** Android output latency ranges roughly
   20–200 ms across OEMs. Screen 4 measures it, Hive stores it, the conductor
   subtracts it. Without it the game feels broken on half the fleet, and no
   amount of window-widening fixes it.
3. **The engine is not `just_audio`** — see §5.1 for why (single-player limit
   on iOS, mandatory `MediaItem` tags, global session clobbering). Whatever the
   §5.4 spike picks is reached only through `ArdahAudioBackend`, so the
   conductor never talks to a plugin directly and can be tested against a fake.
   Independently of the engine, hit feedback should lean on **visual + haptic**
   (`vibration ^3.1.5`, already a dependency): the drums are already in the
   track, and every per-note sound we do not play is a latency risk we do not
   take.
4. **Charts are authored against the track, not typed by hand.** Store
   `offsetMs` + `bpm` + note list in JSON; build a tiny in-app debug charting
   overlay (tap along, dump JSON to the log) rather than hand-writing timings.
5. Pause must stop the conductor *and* the player, and re-seek on resume —
   a 3-frame desync after resume reads as a cheat to the player.

Chart format (v1, `assets/ardah/charts/*.json`):

```json
{
  "id": "ardah_najdi_normal",
  "version": 1,
  "audio": "assets/ardah/audio/ardah_najdi.mp3",
  "bpm": 96,
  "offsetMs": 120,
  "difficulty": "normal",
  "notes": [
    { "t": 1250, "lane": 0, "type": "tap" },
    { "t": 1750, "lane": 1, "type": "hold", "durMs": 500 },
    { "t": 4000, "lane": 2, "type": "flourish" }
  ]
}
```

`t` is milliseconds from track start. Parsing validates monotonic `t`, lane
range, and non-overlapping holds per lane — a malformed chart must fail loudly
at load, never mid-run.

---

## 8. Backend

**P0/P1: none.** Runs, best grades and the calibration offset live in Hive. This
is the main reason Ardah can ship faster than TIFO did.

**P2 (optional, only if we want a shared leaderboard):** mirror `tifo_api.dart` —
private `Dio`, `[ardah]`-prefixed logs, bearer = SSO token with a
`ardah-guest-<deviceId>` fallback. Endpoints: `GET /ardah/config` (charts +
tuning), `POST /ardah/runs` (submit a run), `GET /ardah/leaderboards`.

Lessons from TIFO to carry over, written into the contract up front:

- Staging treated the bearer as an **opaque user id** → guest progress could not
  migrate after sign-in, and an SSO refresh minted a "new user". Decide the
  identity model *before* the first endpoint ships.
- TIFO's base URL is still pinned to staging for every environment
  (`kTifoBaseUrl`). Do not repeat that — derive from `dgisEnvironmentProvider`.
- Server-side validation must accept the exact event shape the client sends;
  TIFO silently voided every session over a field-name mismatch.

Anti-cheat, if there is a server leaderboard: submit the full judgment log
(`{t, lane, deltaMs, judgment}`), and let the server re-derive the score against
the chart. Accuracy-based scoring makes this cheap to validate.

---

## 9. Reuse map (concrete)

Option A. On the HTML path only the host-side rows survive (seasonal gating,
entry tile, design tokens) — the game-side rows are replaced by the mini-app
engine itself, which is the point of §6.

| Need | Take from |
|---|---|
| Fullscreen game over the app, entry → game → result flow | `tifo/penalty/penalty_entry_screen.dart`, `penalty_result_screen.dart` |
| FlameGame + Flutter overlay wiring, input handling | `tifo/penalty/penalty_game.dart` (structure only — not the file shape) |
| Gate walk (tutorial/onboarding steps re-read after each step) | `tifo/tifo_journey.dart` |
| One-shot Hive flags + the "mark on show, not on completion" rule | `tifo/tifo_flow_provider.dart` |
| Route-visibility guard across awaits | `tifo/tifo_surface.dart` (copy verbatim, rename) |
| Seasonal date-range gating + debug override | `features/founding_day/`, `features/leap/`, `shared/config/environment_config.dart` |
| Remote-config-driven tunables with a bundled default | `features/satellite/` + `shared/utils/app_config_loader.dart` |
| Design tokens, Golos font via `balady_uikit` | `tifo/ui/tifo_theme.dart` |
| Stories-style entry hero | `tifo/entry_screen.dart` |

**Do not reuse:** the single-giant-file layout, the pinned-to-staging base URL,
and the `Random(8)`-seeded determinism (a rhythm game needs none of it).

---

## 10. Phases & rough effort

Engineering only, one developer, excludes art/audio production and analyst time.
The P0–P2 content below is the same work on either path; only the technology
differs (Flutter/Flame vs. web), and the HTML path can be staffed by web
developers in parallel with the Flutter release train.

| Phase | Content | Estimate |
|---|---|---|
| **S — delivery & audio spike** (§5.4) | The same metronome built both ways, latency median and spread measured on real devices, coexistence with radio and navigation voice verified inside the superapp. Decides path and engine. **Go/no-go gate.** The HTML half already exists (`ardah_web/`, §6.6) — what remains is the device measurements and, if they are ambiguous, the Flame counterpart. | 1–3 days |
| **P0 — playable prototype** (debug flag only) | Conductor + one hand-made chart + tap notes + judgment + placeholder art. Answers the only question that matters: does the timing feel right on real devices? | ~1 week |
| **P1 — vertical slice** | Hold + flourish notes, calibration screen, chart select, result + grade, local best runs, real art for one track, tutorial. | 2–3 weeks |
| **P2 — event-ready** | Seasonal gate + entry tile, Arabic/English l10n, analytics events, 3 charts × 3 difficulties, low-end device pass, accessibility, optional server leaderboard. | 3–4 weeks |

Parallel non-engineering track, and the real critical path: **licensed audio,
Ardah art/animation, and cultural review**. Nothing above ships without them.

Gate between P0 and P1: a playtest on a low-end Android device. If the timing
does not feel right after calibration, the concept changes — do not build P1 on
an unproven conductor.

The audio-session owner (§5.2.2) plus moving TIFO and the radio onto it is a
separate ~2–3 day item. It is worth doing on its own merits — it fixes a live
bug — but Ardah's P1 depends on it, so it cannot slip past that point.

---

## 11. Risks

1. **Cultural sensitivity — the top risk.** Ardah is ceremonial heritage, tied
   to national identity. A "you failed" screen over a heritage performance, a
   cartoonish sword, or a mis-scanned chant is a PR incident, not a bug. Needs
   review with the Ministry of Culture / Balady comms **before** art production,
   and a framing of *keeping the row in sync*, never mockery. Sword animation
   must read as ceremonial, never combat.
2. **Audio licensing.** The track and the chant need explicit rights for use in
   a government app, including store distribution. Commission original
   recordings if licensing is slow.
3. **Collision with the app's existing audio stack** (§5.1). The radio owns a
   process-global session and a native coordination bridge; TIFO already
   overwrites it. Two concrete failure modes to watch: the game is silent while
   the radio plays, or the game's engine leaves the session in a state where
   the radio no longer coexists with navigation voice. The §5.4 spike exists to
   find these before they are expensive; the session owner (§5.2.2) is the fix.
   The HTML path (§6) removes most of this — but not the process-global session
   itself.
4. **WebView input latency and frame pacing** — the price of the HTML path
   (§6.3). A rhythm game needs steady 60 fps and a short touch-to-judgment path,
   and on Android the WebView is a composited platform view. Measured in the
   spike; mitigated by canvas rendering, a fullscreen WebView with nothing
   layered over it, and no layout work mid-run. If it fails on the low-end
   target device, the path falls back to Flame.
5. **Android audio latency.** Mitigated by calibration (§7) — but if median
   latency on the test fleet is above ~150 ms, widen windows and simplify
   patterns rather than shipping something that feels unresponsive.
6. **App size.** Audio + sprites are heavy. Budget the delta, and put the
   charts/tracks behind on-demand download if the APK grows past the agreed
   ceiling.
7. **Low-end device performance.** Flame over a paused map should be fine; over
   a live map it is not. Pause the map, cap particle effects, profile in
   `profile` mode, not `debug` (repo-wide rule).
8. **RTL.** The gameplay surface stays **LTR in both locales** (explicit
   precedent: `penalty_entry_screen.dart` — game chrome mirrors the physical
   stage, not reading order). All chrome around it is localized normally.
   Arabic copy needs the long-label treatment already applied in `ai_summary`.
9. **Scope creep toward AR/pose detection.** Named in §2 as out of scope on
   purpose.

---

## 12. Open questions for product

1. Event window: Founding Day only, National Day too, or always-on?
2. Is a **shared leaderboard** required for v1? It is the single largest
   backend/anti-cheat cost driver.
3. Rewards: purely cosmetic grades, or does Ardah feed the Balady+ rewards /
   token economy that TIFO uses?
4. Audio source: licensed existing recordings or a commissioned original?
5. Does Ardah need a map tie-in at all (e.g. play at Diriyah / cultural POIs),
   or does it stay fully off-map? Off-map is assumed above.
6. Which devices define the minimum bar for the timing playtest?
7. **Radio-vs-game policy** (§5.2.3): when a player starts a run while MBC radio
   is playing — duck the radio, pause it and resume on exit, or keep the radio
   and mute the game's music?
8. Is the audio-session owner (§5.2.2) acceptable as a shared refactor touching
   the radio and TIFO, or must Ardah work around them?
9. **Delivery channel** (§6): is the mini-app engine open to a game — who owns
   the `serviceKey`, the hosting of the archive, and its release process?
10. If HTML wins, who builds it — an internal web team, the Flutter team, or a
    vendor? This decides the schedule far more than the technology does.
11. Should the HTML build also be published outside the app (a campaign page or
    a shared link), or stay in-app only? It is nearly free, but it is a comms
    decision, not an engineering one.
