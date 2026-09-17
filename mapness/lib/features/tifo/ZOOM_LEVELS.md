# TIFO — Zoom Levels

TIFO renders its city-wide football layer as three level-of-detail tiers,
switched purely by map camera zoom. This document lists every zoom value the
current code actually keys off, and the places where the zoom used in code
diverges from the zoom in the product spec.

Since `feat(BALADY-3964): add tifo debug zoom` the two switch points are no
longer hardcoded: they live in `TifoLodZoomThresholds`
(`data/tifo_debug_lod_zoom.dart`) and QA can move them at runtime from the
debug panel. **The defaults reproduce the constants the layer used to
hardcode** (`_districtClusterMaxZoom = 11`, `_buildingMinZoom = 15`), so
everything below reads as before unless a slider has been dragged.

## LOD tiers

| Tier / zoom (default) | Behavior | Threshold |
| --- | --- | --- |
| **Cluster**<br>`0 < zoom ≤ 11` | Zoomed far out. TIFO paints a single bundled region-outline polygon (`kTifoRegionPolygons` — 25 polygons, 2252 vertices, 3 holes), tinted in the season leader's color. District borders aren't legible at this scale, so the silhouette carries the same information a ~413-polygon mosaic would — and needs no `GET /districts` round-trip, since the outline ships bundled with the app. Panning inside this tier is a no-op: one silhouette covers the whole region. | `TifoLodZoomThresholds.clusterMaxZoom` (default `11`) |
| **Districts**<br>`11 < zoom < 15` | Mid range. Each of the ~413 districts is drawn as its own polygon, tinted by that district's currently-leading club, and the region outline is drawn over the mosaic as a border. Geometry is simplified onto a shared coordinate grid at this tier and refined on zoom-in — a district never re-coarsens once drawn. Districts outside the visible rect (+35% padding) are culled. | the band between the two thresholds — `_lodFor()`'s fallback branch |
| **Buildings**<br>`zoom ≥ 15` | Street level. Individual buildings render colored by their current owner club and become tappable — this is the tier the actual mini-game is played at. Buildings are fetched per bbox, accumulate across pans, and are capped at `_maxRendered = 2000` (viewport-aware eviction). | `TifoLodZoomThresholds.buildingMinZoom` (default `15`, derived) |

`zoom == 0` is a fourth case, not a tier: it means the camera has never
reported a position (see `enable()`), and `_lodFor()` deliberately treats it
as **districts**, not as "fully zoomed out" — painting the entire city one
color off that guess would be a worse first frame.

## Runtime-tunable thresholds (BALADY-3964)

`TifoLodZoomThresholds` models the three tiers as **one ordered axis with two
free boundaries**:

| Field | Default | Meaning |
| --- | --- | --- |
| `clusterMaxZoom` | `11` | Last zoom that still paints the region silhouette. |
| `districtMaxZoom` | `14` | Last zoom that still paints the district mosaic. |
| `buildingMinZoom` | `15` | First zoom that paints buildings. **Derived, never stored:** always `districtMaxZoom + tierGap`, so no zoom band can belong to two tiers at once. |

Slider bounds and invariants:

| Constant | Value | Meaning |
| --- | --- | --- |
| `minZoom` | `2` | Lowest zoom the sliders may hand out. |
| `maxZoom` | `20` | Highest zoom the sliders may hand out. |
| `tierGap` | `1` | Minimum width of a tier, and the gap kept between neighbouring boundaries. |
| `maxClusterMaxZoom` | `18` | `maxZoom - 2 * tierGap` — widest cluster ceiling that still leaves a districts tier and a buildings tier above it. |

Every setter re-derives the whole triple through `_normalized()`, so dragging
one boundary past a neighbour **pushes** that neighbour instead of letting two
tiers overlap; the slider being dragged keeps its value. Out-of-range values
are clamped, never overlapped. Covered by
`mapness/test/tifo_debug_lod_zoom_test.dart`.

Where to find it: debug overlay → TIFO panel → **"Map LOD zoom levels"**
(three whole-zoom-level sliders + "Reset to defaults"). The TIFO map layer
toggle's subtitle shows the live ranges. State is an in-memory `Notifier`, so
it is **not persisted** — an app restart is back on the defaults.

The layer caches the thresholds in a field (`_lodZooms`) rather than reading
the provider inside `_lodFor()`, because the tier is asked for on the viewport
stream and from teardown paths. Moving a threshold changes which tier the
*current* camera belongs to without any camera event firing, so the layer
listens to the provider and repaints through `_refreshLodTier()` →
`_applyForViewport()` — the same path a pinch takes, including retiring the
outgoing tier. `_zoom` is deliberately not re-seeded from `getCameraPosition()`
there, to avoid mixing the two zoom scales (see below).

## Known discrepancies

**The stream reads about one zoom level low.** The product spec (API v2.4 §3)
documents the buildings threshold as zoom 16. The implementation uses zoom 15
instead, because the `visibleRectEvent.zoom` stream this layer listens on reads
roughly one level lower than `getCameraPosition().zoom` — so 16 is effectively
unreachable on that stream, and 15 is the real street-level threshold in
practice. **All threshold values in this document are in
`visibleRectEvent.zoom` units**, including the debug sliders.

**Buildings can share one tap target below zoom 18.** The native `urbi_map`
plugin's `createMapObjectManager` builds every manager with
`MapObjectManager.withGeneralization(logicalPixel = 100f, maxZoom = Zoom(18f))`
(`ObjectTapHandler.kt`). Below zoom 18, polygons close together on screen get
spatially thinned and can collapse into a single tap hitbox — which is also why
"not all polygons show" at street zoom. Fixing it needs a plugin-side change
(a lower `logicalPixel`, per-zoom hitbox sizing, or a non-generalized manager),
not a Dart-side one.

**A stale comment still says 16.** The section header
`// ─── Buildings (zoom >= 16) ───` in `tifo_buildings_map_layer.dart` predates
the move to 15 and contradicts the code below it. Cosmetic only — the class
doc-comment and `_lodFor()` are correct.

## Not keyed off the zoom number

Two things that look zoom-driven but deliberately aren't, because they must not
assume this map's zoom units:

- **District geometry simplification** (`_gridExponent()`): the coordinate-grid
  step is derived from the width of the visible rect against a nominal
  `1600 px` screen at `0.5` px per grid cell, not from the zoom value.
- **Building bbox culling / district culling**: driven by the parsed visible
  rect (`_districtCullPadding = 0.35`), again not by zoom.

## Zoom-driven timings

| Constant | Value | Meaning |
| --- | --- | --- |
| `_panDebounce` | `400 ms` | Viewport debounce while the player stays inside one tier — stops a pan/fling from firing a `GET /buildings?bbox=` per frame. |
| `_tierChangeDebounce` | `80 ms` | Debounce for a viewport event that *changes* the tier. The player is actively waiting on that visual jump, so it must not queue behind `_panDebounce`; non-zero only to coalesce the burst a pinch emits while the zoom oscillates around a threshold. |

## All zoom values

| Zoom | Meaning | Units | Source |
| --- | --- | --- | --- |
| `0` | No camera position reported yet → treated as "districts", not fully zoomed out | `visibleRectEvent` | `_lodFor()` |
| `1` | `tierGap` — minimum tier width and boundary spacing | zoom levels | `TifoLodZoomThresholds.tierGap` |
| `2` | Lowest zoom the debug sliders may hand out | `visibleRectEvent` | `TifoLodZoomThresholds.minZoom` |
| `≤ 11` | Cluster tier ceiling (default) — one region-wide silhouette polygon | `visibleRectEvent` | `TifoLodZoomThresholds.clusterMaxZoom` |
| `12–14` | Districts tier (default) — per-district mosaic | `visibleRectEvent` | between the two thresholds |
| `14` | Last zoom that still shows districts (default) | `visibleRectEvent` | `TifoLodZoomThresholds.districtMaxZoom` |
| `≥ 15` | Buildings tier floor (default, derived) — the real, implemented street-level threshold | `visibleRectEvent` | `TifoLodZoomThresholds.buildingMinZoom` |
| `16` | Buildings threshold as documented in the product spec; not reachable on this stream | camera (spec) | API v2.4 §3 |
| `16.5` | Camera fly-to target when a district sheet's "zoom in" action opens the buildings tier | camera | `district_sheet.dart` |
| `18` | Widest cluster ceiling the sliders allow (`maxZoom - 2 * tierGap`) | `visibleRectEvent` | `TifoLodZoomThresholds.maxClusterMaxZoom` |
| `18` | Native plugin's `maxZoom` for generalization / tap hit-testing — below it, nearby polygons can share a hitbox | camera | `urbi_map` plugin |
| `20` | Highest zoom the debug sliders may hand out | `visibleRectEvent` | `TifoLodZoomThresholds.maxZoom` |

## Source

- branch: `feat/BALADY-3964/tifo-debug-zoom`
- `mapness/lib/features/tifo/data/tifo_debug_lod_zoom.dart`
- `mapness/lib/features/tifo/tifo_buildings_map_layer.dart`
- `mapness/lib/features/tifo/district_sheet.dart`
- `mapness/lib/widgets/debug_overlay/tifo_backend_debug_panel.dart`
- `mapness/test/tifo_debug_lod_zoom_test.dart`
- `urbi_map/dgis_map/android/src/main/kotlin/com/dgis/map/control_handlers/ObjectTapHandler.kt`
- `mapness/lib/features/tifo/AGENTS.md`
