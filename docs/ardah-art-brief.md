# Ardah — art production brief

For the illustrator, 2D animator or image-generation pipeline producing the
visual assets for the Ardah rhythm game.

The engine already exists and runs: [`ardah_web/`](../ardah_web/). Everything
in it is currently **drawn in code as a placeholder** — this brief describes the
artwork that replaces it. Every coordinate below is taken from the running
layout, so assets built to this spec drop in without redesign.

Related: [`ardah-concept.md`](ardah-concept.md) (what the game is, why it ships
as a mini-app), [`../ardah_web/README.md`](../ardah_web/README.md) (how to run
the prototype and see exactly what each asset replaces).

---

## 1. Non-negotiables, read first

**Ardah (العرضة) is ceremonial heritage, not folklore decoration.** It carries
national identity. The art must read as dignified performance.

- Performers are adult men in correct dress: white thobe, red-and-white shemagh
  with a black agal, crossed leather bandolier with a metal medallion, plain
  dark shoes.
- Sabres are held **ceremonially** — raised, still, never mid-combat, never
  crossed as weapons in an aggressive way, never pointed at a person.
- No caricature, no exaggerated features, no comedic proportions, no dancing
  poses that mock the form.
- **Do not reproduce the Saudi national flag or the state emblem.** The flag
  carries the shahada and is not decoration. The green banners in the scene are
  *event banners* with an ornamental palm-and-sabres motif, clearly distinct
  from the state emblem. If in doubt, send the banner art for review before
  finishing it.
- No women depicted in the performing row (the Ardah row is traditionally male);
  the crowd, if ever added, is a separate question for the client.

**Approval gate:** banner art, performer designs and the fort must be reviewed
and signed off by the client's cultural/comms side **before** full production.
Deliver those three as sketches first (§8, milestone A).

No text of any kind may be baked into artwork — every string is localised into
Arabic and English at runtime, and the layout flips to RTL.

---

## 2. The scene, and what the engine does with it

Portrait phone, design viewport **390 × 844 pt**. Deliver at **@3x
(1170 × 2532 px)**; the engine downscales. Exact geometry at design size:

| Landmark | y (pt) | Notes |
|---|---|---|
| Top of screen | 0 | HUD overlays the top ~92 pt — keep it visually calm |
| Horizon line | 243 | Fort base sits just below it |
| Stage floor / row's feet | 405 | 48 % of the screen height |
| Runway far edge | 420 | half-width **36 pt** (it is nearly a point) |
| Judgment line | 726 | half-width **179 pt** |
| Keycap row | 789 | three keycaps, lane-coloured |

The runway is a live perspective projection, not a picture: distance `z` shrinks
linearly with time and screen position is `y = vp + C/z`. **Do not paint the
runway into the backdrop** — it is drawn per frame and must stay separate.

The vanishing point sits *behind* the row (y ≈ 343), so notes rise out from
between the performers. Keep the area between the row's feet and y = 420 free of
busy detail: the runway's far end fades into it.

Musical tempo is **96 BPM** → beat 625 ms, bar 2500 ms. Every looping animation
must be authored to a whole number of beats so it locks to the music (§5).

---

## 3. Asset list

Formats: **PNG-24 with alpha** as master; also deliver **WebP q85** (the engine
prefers it, PNG is the fallback). No JPEG for anything with transparency.
Nothing wider than **2048 px** in a single file — low-end Android decodes large
textures badly; split instead.

### 3.1 Backdrop — static, one plate per layer

Painted for the region **above y = 405** (@3x: 1170 × 1215 px), extended 40 pt
below so parallax never reveals an edge.

| ID | Content | Size @3x | Alpha | Budget |
|---|---|---|---|---|
| `bg_sky` | Night sky, stars, crescent moon upper right, warm haze on the horizon | 1170 × 900 | no | 250 KB |
| `bg_fort` | Diriyah-style mud-brick fort: crenellated towers, arched lit windows, a tall lit gate, low steps | 1170 × 560 | yes | 300 KB |
| `bg_palms_l` / `bg_palms_r` | Palm clusters framing each edge, 3 depths | 420 × 640 each | yes | 150 KB ea. |
| `bg_plaza` | Polished tiled plaza receding to the horizon, warm reflections | 1170 × 700 | no | 250 KB |
| `bg_banner_a` / `bg_banner_b` | Green event banner on a gilded pole, two lengths | 200 × 480 | yes | 80 KB ea. |

Deliver the fort, palms and banners **as separate layers**, not flattened: the
engine parallaxes them and dims them behind menus.

### 3.2 Fire

| ID | Content | Spec |
|---|---|---|
| `fx_brazier_base` | Bowl on a stand, unlit | 120 × 200 @3x, alpha |
| `fx_flame` | Flame loop, **16 frames**, seamless | sheet 4 × 4, cell 160 × 220 |
| `fx_flame_glow` | Soft radial glow, additive | 512 × 512, greyscale + alpha |

Flames are drawn additively over the glow. Author the loop at 12 fps
(16 frames ≈ 1.33 s) — deliberately not a beat multiple, so fires never look
mechanically synced to the drums.

### 3.3 Performers — the expensive part

Five per side, mirrored, drawn at **scale 0.70 (far) → 1.12 (near)** of a base
figure **78 pt tall** at design size. At @3x the near figure is ≈ 262 px tall;
author at **400 px tall** to leave headroom.

**Preferred delivery: one rigged character** (Spine, DragonBones or Rive), with
three costume/beard variants so ten figures do not read as clones. States:

| State | Length | Notes |
|---|---|---|
| `idle` | 2 bars (5.0 s) | Slow weight shift, sabre held high and steady |
| `raise` | 1 beat (625 ms) | Sabre lifts to the ceremonial vertical, holds, settles |
| `flourish` | 1 bar (2.5 s) | Whole row's celebration, triggered on the chorus accent |
| `settle` | 1 beat | Return to idle from any state |

**Fallback delivery: sprite sheets** at 12 fps — `idle` 24 frames, `raise` 8,
`flourish` 30, plus a mirrored set or a note that mirroring is safe (it is, if
the bandolier is symmetrical). Anchor every frame at the **feet centre**, same
canvas size per state, no per-frame cropping.

Contact shadow ships **separately** (`perf_shadow`, 200 × 60, soft) — the engine
places it on the floor and fades it with depth.

### 3.4 Musicians

| ID | Content | Spec |
|---|---|---|
| `mus_tabl` | Seated tabl player on a stool, drum across the lap | idle 2 bars + `hit` 1 beat |
| `mus_oud` | Seated oud player on a stool | idle 2 bars + `pluck` 1 beat |
| `prop_carpet` | Red patterned carpet in perspective | 900 × 260 @3x, alpha |

Both musicians are triggered by the real drum track: the tabl player is struck
on every deep-drum event, the oud player on the mid-drum. Author `hit` as a
single-beat accent that reads at a glance.

### 3.5 Runway

| ID | Content | Spec |
|---|---|---|
| `track_deck` | Dark deck surface, **vertically tileable** | 512 × 512, seamless top/bottom |
| `track_rail` | Ornamented gold rail, **vertically tileable**, Najdi diamond motif | 128 × 512, alpha, seamless |
| `track_line` | Lane divider, 1 pt wide, soft | 8 × 512, alpha |
| `track_judge` | The judgment bar: bright gold, glowing | 1024 × 96, alpha |

The rail is stretched in perspective by the engine, so author it **straight and
vertical** — do not pre-distort. The motif should survive being squeezed to a
third of its width at the far end.

### 3.6 Notes and effects

| ID | Content | Spec |
|---|---|---|
| `note_tabl` | Gold ingot (TABL lane) | 256 × 256, alpha |
| `note_swords` | Cut blue jewel (SWORDS lane) | 256 × 256 |
| `note_tar` | Struck gold coin with a crescent (TAR lane) | 256 × 256 |
| `note_hold` | Ribbon body, **vertically tileable**, one per lane colour | 128 × 256 |
| `note_flourish` | Banner with crossed sabres, stretched across all lanes | 1024 × 128 |
| `fx_burst` | Radiating strike flash, 12 frames | sheet 4 × 3, cell 320 × 320 |
| `fx_spark` | Single spark particle | 32 × 32 |

Notes are seen slightly from above and scale from ~16 px (far) to ~120 px
(near), so detail must survive heavy downscaling: strong silhouette, one clear
highlight, no fine engraving.

### 3.7 UI

| ID | Content | Spec |
|---|---|---|
| `ui_plaque` | Gold-framed signboard for the title, **9-slice** | 720 × 280, insets 90/60/90/60 |
| `ui_btn_gold` | Primary button plate, **9-slice** | 480 × 120, insets 60/40/60/40 |
| `ui_btn_dark` | Secondary button, **9-slice** | 480 × 120, same insets |
| `ui_chip` | Pill for metadata, **9-slice** | 300 × 80, insets 40/30/40/30 |
| `ui_key_tabl` / `_swords` / `_tar` | Keycaps, lane-coloured | 160 × 120 each |
| `ui_meter_frame` / `ui_meter_fill` | Crowd meter, 9-slice | 600 × 48 |
| `ui_score_plate` | Score frame, 9-slice | 480 × 96 |

Every 9-slice asset must have **flat, stretchable middles**: no gradient that
runs along the stretched axis, or it will band when scaled.

---

## 4. Light, colour and palette

One warm key light **from below and in front** — the braziers and the lit gate.
A cool rim from the moon, **upper right**. That combination is what makes the
white thobes read against a night sky, and every asset must obey it: a figure
lit from the top-left will look pasted on.

Current in-engine palette, and the target for the artwork:

| Role | Hex |
|---|---|
| Gold, primary | `#E7B44C` |
| Gold, highlight | `#FFD978` / `#FFF6DD` |
| Gold, shadow | `#8A6A22` |
| Banner green | `#0E6B3C` |
| Deep green (panels) | `#07281A` |
| Night sky, top → horizon | `#081226` → `#102B4E` → `#4A3A44` |
| Mud brick | `#9A6E45` → `#4A3220` |
| Firelight | `#FFF0BE` → `#F8A93F` → `#C64A1A` |
| Thobe white | `#FFFCF4` → `#B49B7E` (lit from below) |
| Shemagh red | `#D9534F` |
| TABL lane | `#F2B33D` |
| SWORDS lane | `#3AA3E8` |
| TAR lane | `#F5D779` |

Deviate from these only deliberately, and tell us — the engine's own drawing
(effects, glows, HUD) uses them and would then need re-tuning.

---

## 5. Animation rules

- Every loop is a whole number of **625 ms beats**. A 1.9 s idle will visibly
  drift against the music; 2.5 s will not.
- Author at **12 fps** for sheets. Higher frame rates cost download and memory
  and buy little at this figure size.
- Loops must be seamless: last frame flows into first with no pop.
- The `raise` accent must have its **peak on frame 2–3**, not in the middle:
  the player hits the beat and the sabre must answer immediately, not 300 ms
  later.
- Nothing in the artwork may animate the HUD area (top 92 pt) or the runway.

---

## 6. Budget and delivery

**Total initial download: 4 MB hard ceiling**, 2.5 MB preferred. The game is
distributed as a mini-app archive that players download on site at an event,
often on a congested network. If the art cannot fit, we split: backdrop and UI
in the base archive, performer animation fetched on first run.

```
ardah-art/
  backdrop/      bg_*.png + .webp
  performers/    rig (.json + atlas) or sheets/ + preview.mp4
  musicians/
  runway/
  notes/
  fx/
  ui/
  source/        layered originals (PSD/AI/Procreate/Blender)
  CONTACT.md     who made what, licence terms
```

- Naming exactly as the IDs in §3. Lowercase, underscores, no spaces.
- Sprite sheets ship with a **TexturePacker-style JSON** (frame rects, pivots).
- Layered sources are part of the delivery, not optional — retiming and recolour
  happen later and must not need the vendor back.
- Licence: full transfer to the client for use in the Balady+ app and its
  promotion. Any third-party element (font, brush, model, generated component)
  must be listed in `CONTACT.md` with its licence.

---

## 7. Acceptance checklist

An asset is accepted when:

1. It sits correctly at the coordinates in §2 with **no repositioning in code**.
2. Its lighting matches §4 — warm from below, cool rim upper right.
3. Transparent assets have **no baked background halo** (check against both the
   night sky and a flat magenta).
4. It survives downscaling to @1x without turning to mush.
5. Tileable assets tile with **no visible seam** across four repeats.
6. 9-slice assets stretch to 3× their width with no banding or corner distortion.
7. Loops hold sync over 30 repeats against a 96 BPM click.
8. Total archive is inside the §6 budget.
9. Cultural review (§1) has signed off on performers, banners and the fort.
10. It renders at **60 fps on the agreed low-end Android device** inside the
    superapp WebView — the final gate, and the only one that cannot be judged
    from a picture.

---

## 8. Milestones

| | Deliverable | Gate |
|---|---|---|
| **A** | Sketches: one performer, the banner, the fort silhouette | Cultural review sign-off before any production |
| **B** | Full still frame of the stage at @3x, composed to §2 geometry | Client approves the look; we drop it in as a flat backdrop and screenshot the real game |
| **C** | Backdrop layers + UI + notes | Playable with final static art |
| **D** | Performer rig/sheets + musicians + effects | Feature-complete art |
| **E** | Optimisation pass to the §6 budget | Ship |

Milestone B is worth insisting on: a single still, dropped into the running
game, tells us more about the final look than any number of separate assets —
and it is the cheapest point at which to change direction.

---

## Appendix A — what slicing the concept still actually produced

Before commissioning anything we cut the concept image itself into assets
(`ardah_web/assets/`, script `ardah_web/assets/extract.py`) to see where the
line falls. The result is the empirical case for §3's layered delivery:

**Cut cleanly, and now running in the prototype** — the stage backdrop
(rectangular crop, title plaque painted out), the three note objects and the
three keycaps (keyed against the dark deck: distance-from-background alpha,
colour unmultiplied so edges keep no halo, largest connected blob kept, a shape
mask to drop a touching neighbour). **180 KB in WebP for the set**, which is
2 % of the §6 budget — file size is not the constraint anyone should be
optimising against here.

**Cut, but unusable** — the title plaque. Its text is baked in as English
pixels, so it cannot localise. This is §1's "no text in artwork" rule,
demonstrated rather than asserted.

**Not cuttable at all** — the performers, the musicians and the fires. They sit
against the fort rather than a flat background and they overlap one another, so
no keying gets them out; a real segmentation pass would still leave them as
single frozen poses. They stay baked into the backdrop, and the consequence is
visible in the running prototype: **in art mode the stage does not move.** No
idle sway, no sabre raise on a hit, no drummer answering the track.

So the split to insist on when commissioning: the backdrop may arrive as a
finished still, but **performers and musicians must arrive as separate,
transparent, animatable elements** (§3.3) — a rig, or at minimum sprite states.
Everything the game does with the row depends on it, and no amount of
post-processing recovers it from a flat render.

## Appendix B — if the art is generated rather than drawn

The concept image this brief descends from was produced this way, and it works,
provided the pipeline is disciplined:

- **Produce a style anchor first** — one approved image — and condition
  everything else on it (image reference / style reference / same seed family).
  Consistency across assets is the failure mode, not quality of any one image.
- Generate each element **in isolation on a flat background** (magenta or pure
  black), then cut it out — not as a crop from a composed scene, which drags
  the wrong perspective and lighting along with it.
- State the camera in every prompt: *eye level, slight low angle, portrait
  orientation, subject centred, full figure, feet visible*.
- State the light in every prompt: *warm firelight from below and in front, cool
  moonlight rim from the upper right, night*.
- Generated output cannot animate. Either the rig is built by an animator over
  generated stills, or the performers stay still and the motion lives in the
  effects — decide this before commissioning, because it changes §3.3 entirely.
- Everything in §1 still applies, and generated imagery needs **more** review,
  not less: models routinely get dress details, the emblem and the number of
  fingers wrong.
