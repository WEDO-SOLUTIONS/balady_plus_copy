# TIFO penalty game — state & development history

Deep-dive companion to [../AGENTS.md](../AGENTS.md). The mini-game lives in
this `penalty/` folder: `penalty_game.dart` (~6 800 lines, one file by
design — it started as a sandbox and grew; splitting it is a known
cleanup), `penalty_entry_screen.dart`, `penalty_result_screen.dart`, plus
`assets/tifo/`.

## What it is

A Flame-based penalty shootout: swipe to shoot, an animated goalkeeper tries
to save. The session ends after `missesAllowed` misses (from `/config`,
default 3); goals are the score. It is the *capture mechanic* of TIFO — beat
the building's saved score and the building flips to your club.

## Current architecture (`penalty_game.dart`)

One file, four playable views behind a debug toolbar (`_PenaltyView`:
`perspective | topDown | miniGame | styles`). **`perspective` is the
production game**; the others are kept as prototypes:

- `PenaltyGame` (line ~1017) — the production perspective game.
  `FlameGame` with `TapCallbacks, DragCallbacks`.
- `TopDownPenaltyGame` (~274) — earlier top-down prototype, simpler physics.
- `MiniFootballGame` (~5057) + `StylesGalleryWidget` (~4464) — a stylized
  mini-game prototype with 6 art themes (`MiniGameStyle`: cyber, stadium,
  flat, comic, pixel, lowPoly). Exploration artifacts.

### Perspective game internals

World is metric, Z into the screen:
`_goalZ = 23`, `_goalHalfWidth = 4.5`, `_goalHeight = 2.923`,
`_ballStartZ = -0.95`, `_ballRadius = 0.32`, `_gravity = -9.8`.
The camera projection was calibrated by hand against the background photo
(`assets/tifo/backgrounds/stadium_goal_background.jpg`): goal-post/crossbar
pixel coordinates were measured off the image and the schematic hitbox was
aligned to them (there is a `_drawGoalHitbox` debug overlay to re-check).
The photo's perspective squishes the far half of the box — comments around
lines ~1039/2342 document the mapping.

**Shot input**: drag = aim (`_targetFromCanvas`), release = shoot
(`_shootFromSwipe` → `_shootAtTarget`). Flight time solved from the target,
vertical velocity derived from `flightTime` and gravity, plus random curve
(`_curve = (rand-0.5) * 0.55 * power`) and spin.

**Keeper AI** (the part that took the most tuning):
- Aim error: keeper dives to `flightTarget.x * 0.72 + keeperError`,
  `keeperError ∈ ±1.05` — he *roughly* reads the shot but can guess wrong.
- Side: `|targetX| < 1.0 → center` (no dive, standing reach only), else
  left/right (`_KeeperSide`).
- Dive style by target height (`_chooseKeeperDive`): `<0.95 → low`,
  `>1.82 → high`, in between — weighted random (`_KeeperDive.low/mid/high`).
- **Reaction delay**: the dive clock starts only after the ball has covered
  40 % of its flight (`_reactionDelayFraction = 0.4`, computed per shot).
  Before that the keeper holds idle — kills the "psychic keeper" feel.
- **Dynamic hitbox** (`_resolveShot`): reach grows from standing
  (`standReachX = 0.42`) to the dive style's full extension
  (low 0.95 / mid 0.78 / high 0.62) with the same `easeOutCubic` ramp and
  the same delayed clock as the *drawn* dive — a fast shot that arrives
  before the keeper visibly gets there is NOT saved. This fixed the
  "invisible wall" complaints from early playtests.
- RNG is seeded (`Random(8)` / `Random(17)`) — deterministic sessions, handy
  for reproducing bugs.

**Scoring loop**: `_shotHistory` accumulates `_ShotState`s
(goal/saved/missed — both saved and missed count as misses). On the
`missesAllowed`-th miss the game calls `onComplete` exactly once with
`TifoShootoutOutcome{goals, misses, events}` where `events` is the per-kick
log in the backend shape `{kick: 1-based, result: 'goal'|'miss'}`
(anything else gets the play session voided server-side — this bit us once:
the original `{index, outcome, atMs}` shape silently voided every session).

### Rendering models

No Flame `SpriteComponent`s — the actors are custom canvas painters:

- `_StrikerModel` (~2430) — run-up + kick, frames from `sprites/striker_v2/`
  (+ 3 legacy poses `striker_ready/windup/kick.png`).
- `_GoalkeeperModel` (~2748) — the big one. `_KeeperMotion` state machine
  (idle → dive/low/mid/high per side → save_recover / missed_reaction /
  conceded), sprite sheets in `sprites/goalkeeper_v2/`
  (`ready_sheet.png`, `dive_{low,mid,high}_left_sheet.png`,
  `save_recover_sheet.png`, `missed_reaction_sheet.png`,
  `conceded_sheet.png`; right dives are mirrored). `_KeeperAtlas` /
  `_SpriteSheet` slice the sheets.
- `_SoccerBallModel` (~3432) — sprite ball with trail
  (`_recordTrailPoint`).
- `_GlbModel` / `_GlbTriangle` / `_Vec3` (~3699+) — a **software 3D
  renderer** (triangle projection, painter's sort) that loads
  `models/goalkeeper.model.json` / `soccer_ball.model.json` (converted from
  GLB). This was the "3D keeper" experiment; it renders but sprites won on
  look and cost, so the GLB path is dormant — kept because the converter and
  renderer work and may be reused for the ball.

### Audio

`assets/tifo/audio/`: `crowd_ambience_1.mp3` (looped, `_ambiencePlayer`) and
`kick_1.mp3` (+variants) via `_playRandomSfx`. **Gotcha**: one shared
`AudioPlayer` for SFX — instantiating a second one throws
"supports only a single player" on iOS (comment at ~4097).

## Sprite production pipeline (how the art was made)

The keeper/striker art was produced from **video renders supplied by the
user**, converted to sprite frames in-session (the source folders are still
wired as workspace dirs):

- `~/Downloads/вратарь 512 fixed/` → 32 numbered frames 512×512 → copied to
  `sprites/goalkeeper_v2/1.png…32.png` as the master pose set; 4 working
  poses were picked from it (idle = frame 1 etc.).
- `~/Downloads/GSP_save_lower_left 24FPS without light/` → the side-dive
  sequences; frames were background-stripped, cropped, resized and packed
  into horizontal sheet PNGs (`dive_*_sheet.png`) with `sips`/ImageMagick in
  the session shell.
- `~/Downloads/SP_idle/`, `~/Downloads/SP_kick/` → striker sequences →
  `sprites/striker_v2/`.
- `~/Downloads/2nd iteration/` → refinement batch.

Only left dives are shipped; right dives mirror at draw time. Asset weight
is significant: `sprites/` **47 MB** total (12 MB goalkeeper_v2, 12 MB
goalkeeper_motion, 5.3 MB striker_v2) — a compression/pruning pass is a
known TODO before release (goalkeeper_motion may be entirely unused, verify
before deleting).

## Development timeline (from session history)

1. **Top-down prototype** — first playable: flat pitch, sinusoidal keeper,
   swipe shooting. Still in the file as `TopDownPenaltyGame`.
2. **Mini-game + style gallery** — art-direction exploration, 6 themes, went
   to stakeholders as look-and-feel options. Kept as `MiniFootballGame`.
3. **Perspective game** — the chosen direction: photographic stadium
   background, metric world calibrated to the photo, hand-measured goal
   hitbox with a debug overlay.
4. **3D attempt** — GLB goalkeeper via the custom software renderer;
   rejected for look/perf, code retained.
5. **Sprite era** — video-to-sprite pipeline above; `_KeeperMotion` state
   machine; several iterations on dive timing.
6. **Fairness tuning** — reaction delay (40 % of flight), dynamic hitbox
   growth synced to the drawn dive, keeper aim error. These three together
   made the game feel beatable-but-not-trivial.
7. **Backend integration** — `PenaltyApp(onComplete, missesAllowed)` embedded
   from `building_sheet.dart` play flow: `/play/start` → game →
   `POST /play {sessionId, score, events, earlyEnd}`. Events-shape bug found
   live (sessions came back `voided`) and fixed to `{kick, result}`.
8. **Tutorial embedding** — the guided tour (see AGENTS.md) shows static
   demo replicas of the preview/HUD (`tutorial/tifo_tutorial_demos.dart`);
   the real game is untouched by the tour.

## Entry points

- Production: `building_sheet.dart` → Challenge → `/buildings/{id}/play/start`
  → `PenaltyApp(onComplete: …, missesAllowed: config)` → submit outcome.
- `penalty_entry_screen.dart` — the dark "Penalty Challenge" preview screen
  (tokens needed / score to beat / "You get 3 misses" / START), Figma node
  721:126912.
- Debug: the in-game `_PenaltyModeToolbar` switches the four views.

## Known state / TODO

- HUD partially diverges from Figma node 589:85315 (misses ⚽❌❌ / Scored /
  Score to beat panel) — needs a rework pass.
- Win/Loss result screen after submit is a plain dialog (rootNavigatorKey
  showDialog) — the designed result screen was explicitly deferred.
- 47 MB of sprites; `goalkeeper_motion/` likely dead weight.
- `penalty_game.dart` should be split (game / models / prototypes) once the
  design stabilizes.
- Pre-existing analyzer style infos in this file are known noise (see
  AGENTS.md workflow notes).
