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
tone matters (see §10 Risks).

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
  failure — the framing is *the row loses sync*, not *you lose* (§10).
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
| 4 | Calibration | Audio-offset wizard — tap along to 8 bare beats, store median delta per device. First run only, re-openable from settings. **Non-negotiable**, see §6. |
| 5 | Gameplay | Flame surface + Flutter HUD overlay (score, combo, sync meter, pause). |
| 6 | Pause | Resume / restart / quit. Must hard-pause the audio clock. |
| 7 | Result | Grade, accuracy, max combo, best-run delta, retry CTA. Same one-hero-per-outcome pattern as `penalty_result_screen.dart` is an option if design bakes art. |
| 8 | Leaderboard | P1: local best runs. P2: server, scoped to the event. |

---

## 4. Code layout

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
      ardah_conductor.dart       # the audio clock (§6) — the heart of the game
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
   Product decision (§11). Navigation voice is not a choice: it always wins —
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

### 5.4 Spike — do this before P0 (2–3 days)

1. `ardah_game/example/`: metronome + tap input, measure real round-trip
   latency on a low-end Android and an iPhone.
2. The same build embedded in the superapp **with the radio playing**: does the
   game get sound at all; does the radio survive; does navigation voice still
   interrupt correctly; what happens on backgrounding, on an incoming call, and
   on the iOS mute switch.
3. Output: median latency and spread per device, conflicts found, engine
   recommendation. This is the go/no-go gate for the whole concept.

---

## 6. The one hard technical problem: the audio clock

Every rhythm game lives or dies here. Rules for this codebase:

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

## 7. Backend

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

## 8. Reuse map (concrete)

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

## 9. Phases & rough effort

Engineering only, one developer, excludes art/audio production and analyst time.

| Phase | Content | Estimate |
|---|---|---|
| **S — audio spike** (§5.4) | Package skeleton + `example/` metronome, engine choice, latency measured on real devices, coexistence with radio and navigation voice verified inside the superapp. **Go/no-go gate.** | 2–3 days |
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

## 10. Risks

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
4. **Android audio latency.** Mitigated by calibration (§6) — but if median
   latency on the test fleet is above ~150 ms, widen windows and simplify
   patterns rather than shipping something that feels unresponsive.
5. **App size.** Audio + sprites are heavy. Budget the delta, and put the
   charts/tracks behind on-demand download if the APK grows past the agreed
   ceiling.
6. **Low-end device performance.** Flame over a paused map should be fine; over
   a live map it is not. Pause the map, cap particle effects, profile in
   `profile` mode, not `debug` (repo-wide rule).
7. **RTL.** The gameplay surface stays **LTR in both locales** (explicit
   precedent: `penalty_entry_screen.dart` — game chrome mirrors the physical
   stage, not reading order). All chrome around it is localized normally.
   Arabic copy needs the long-label treatment already applied in `ai_summary`.
8. **Scope creep toward AR/pose detection.** Named in §2 as out of scope on
   purpose.

---

## 11. Open questions for product

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
