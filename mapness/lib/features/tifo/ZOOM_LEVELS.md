# TIFO — Zoom Levels

TIFO renders its city-wide football layer as three level-of-detail tiers,
switched purely by map camera zoom. This document records the zoom thresholds
currently set in the code.

## LOD tiers

| Tier / zoom | What is shown |
| --- | --- |
| **Cluster**<br>`0 < zoom ≤ 11` | The whole region is painted as one outline polygon, tinted in the season leader's colour. District borders are not legible at this scale. |
| **Districts**<br>`11 < zoom < 15` | Each district is drawn as its own polygon, tinted by the club currently leading that district. |
| **Buildings**<br>`zoom ≥ 15` | Individual buildings are coloured by their owner club and become tappable — this is the tier the mini-game is played at. |

## All zoom values

| Zoom | Meaning |
| --- | --- |
| `0` | No camera position reported yet — treated as the districts tier, not as fully zoomed out. |
| `≤ 11` | Cluster tier ceiling — one region-wide polygon. |
| `12–14` | Districts tier. |
| `≥ 15` | Buildings tier floor — the street-level threshold in the app. |
| `16` | Buildings threshold as documented in the product spec (API v2.4 §3); not reached in the app. |
| `16.5` | Camera target when a district card's "zoom in" action opens the buildings tier. |

The zoom values above are the ones the map layer reads from its visible-area
stream, which reports roughly one level lower than the camera's own zoom. That
is why the buildings tier starts at 15 and not at the 16 documented in the
product spec.

## Source

- branch: `feat/BALADY-3964/tifo-debug-zoom`
- `mapness/lib/features/tifo/tifo_buildings_map_layer.dart`
- `mapness/lib/features/tifo/data/tifo_debug_lod_zoom.dart`
- `mapness/lib/features/tifo/district_sheet.dart`
