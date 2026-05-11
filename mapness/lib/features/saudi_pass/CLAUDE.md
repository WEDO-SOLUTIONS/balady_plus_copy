# saudi_pass feature

Displays offers (discounts and promotions) on the map and in a list. Offers are fetched from the Balady Business Saudi Pass API.

## Directory structure

```
saudi_pass/
├── async_iterable/   — utilities for paginated offer loading
├── functions/        — helpers (amount formatting, category SVGs, text highlighting)
├── notifiers/        — ViewNotifier classes (category, city, sorting dialogs, etc.)
├── pages/            — AutoRoute pages (thin wrappers over views)
├── providers/        — Riverpod providers (business logic, map integration)
├── repo/             — DTOs, API request/response bodies, repository, interceptors
├── views/            — composite UI widgets (no routing)
└── widgets/          — atomic/reusable widgets
```

## Network layer

Two Dio instances, both `keepAlive`:

| Provider | Variable | Base URL | Purpose |
|---|---|---|---|
| `saudiPassDioProviderV1` | `_dioV1` | `{env.saudiPassApi}v1/…` | lookups, images, feedback |
| `saudiPassDioProviderV2` | `_dioV2` | `{env.saudiPassApi}v2/…` | promotions, preferences |

Repository: `SaudiPassRepository` — obtained via `saudiPassRepositoryProvider`.

Interceptors on both instances:
- `AuthTokenInterceptor` — JWT token
- `VerifyingKeyInterceptor` — appends `verifyingKEY` (HMAC hash of URL + method) for requests without `Authorization`
- `DioCacheManager` — HTTP cache
- `RetryInterceptor` — 2 retry attempts

## Key entities

- **`Offer`** (`promotions_body.dart`) — a promotion or coupon. Fields: `id`, `type` (vouchers | coupons), `provider`, `location`, `typeDetails` (code/amount/discount), `favorite`, `redeemed`.
- **`Lookups`** (`lookups_body.dart`) — reference data: `cities`, `categories`, `recommendedTypes`, `genders`, `ageRanges`.
- **`Promotions`** — paginated list of `Offer` with `PagingStatus`.
- **`Preferences`** — user preferences (cities, categories, types).

## Providers

| Provider | Type | Purpose |
|---|---|---|
| `showMapOffersProvider` | `keepAlive Notifier<List<Offer>>` | Primary map provider. State = list of offers currently on the map. |
| `saudiPassRepositoryProvider` | `AsyncNotifier<SaudiPassRepository>` | Singleton repository |
| `get_all_lookups_provider` | — | Cached reference data |
| `offer_details_provider` | — | Single offer details |
| `offer_favorites_provider` | — | Favourite offers |
| `profile_preferences_provider` | — | User preferences |

## Map — ShowMapOffers

`ShowMapOffers` manages two `MapObjectManager` instances:

- **`mapObjectManager`** (injected from `OffersOnMapWidget` via `initObjectManager`) — small offer POI markers and clusters.
- **`selectPinMapObjectManager`** (`MapObjectManagerSettings.selectedMarker()`) — separate layer for the selected-offer pin.

The two managers live on different layers so the selected pin renders **above** small offer markers and clusters without being clustered itself.

### showMarker — critical invariants

```dart
Future<void> showMarker(Marker marker, BaladyAppThemes theme)
```

Sequence:
1. `_showHiddenMarkerIfPresent()` — restores any previously hidden marker.
2. `markerByGeoPoint(position)` — looks up an existing offer marker at the new pin's exact lat/lng.
3. If found:
   - Icon is replaced with the "big" version **only if** the marker's icon is the default (`Markers.defaultPinNew`). If an explicit icon was passed, it is **not** overwritten.
   - The found marker is hidden via `_hideMarker(marker)` (visibility=false) and stored as `_hiddenMarker`.
4. `mapObjectManager.removeAllMarkers()` then `selectPinMapObjectManager.removeAllMarkers()` then `selectPinMapObjectManager.addMarker(marker)`.

**BALADY-3570 — why the icon guard matters:** small offer icon (`places_new/<theme>/ic_offers.svg`) and large offer pin (`places_big_new/<theme>/ic_offers_pin.svg`) have different *filenames*, not just different folders. `String.toBigIcon()` (in `shared/extensions/marker_icons_ext.dart`) only rewrites `places_new/` → `places_big_new/`, so blindly applying it to an explicit `icOffersPin` would yield `places_big_new/<theme>/ic_offers.svg` — a non-existent asset — and trigger `PlatformException(Error loading asset for marker)`.

**`_hiddenMarker` is a dangling reference after `removeAllMarkers`.** Step 4 wipes the cluster manager's marker list, but `_hiddenMarker` still holds the (now-removed) Dart `Marker` object. When `removeMarker(offerPoiPinId)` is later called (close button), `_showHiddenMarkerIfPresent` calls `setMarkerOptions(marker.id, isVisible: true)`. On Android this is null-safe (`markers[id]?.first?.isVisible = ...`); if `_showOffers` re-added a marker with the same id (same offer), the visibility flips on the new marker — which is the intended behavior.

### Marker icons

| State | Icon (light) | Icon (dark) |
|---|---|---|
| Small offer POI | `placesNew.light.icOffers` | `placesNew.dark.icOffers` |
| Offer cluster | `placesNew.light.icOffersClusteringMarker` | `placesNew.dark.icOffersClusteringMarkerDark` |
| Selected offer pin | `placesBigNew.light.icOffersPin` | `placesBigNew.dark.icOffersPin` |

Selected pin marker id constant: `offerPoiPinId = 'offer_poi_pin_id'`.

The cluster icon name has a **`Dark` suffix only in dark mode** (`icOffersClusteringMarkerDark`); light/saudiDay/foundationDay/mekkah all share `icOffersClusteringMarker`.

## OffersOnMapWidget

The map widget for offers. Entry points:

- `_onClusterTap(simpleClusterObject)` — cluster tap: always shows the offer-pin and the offer list for the cluster's offers, regardless of camera zoom. Pin position = `simpleClusterObject.position` (centroid). The list is built by filtering `showMapOffersProvider` state by the IDs in `simpleClusterObject.markers`.
- `_onTapMarker(item, text, options)` — single offer tap: shows pin (`icOffersPin`) via `showMarker`, then sets `_notifierOffers.value = [item]`. Keep the same mounted guards as cluster tap before and after the async `showMarker` call.
- `_setupVisibleRectListener(controller)` — `visibleRectEvents.debounceTime(1s).listen(...)` refreshes offers based on the visible map rect via `switchOffersVisibility`.
- `_showOffers(offers, cameraPosition)` — listener-driven; rebuilds all markers/clusters when state changes. On first call only, animates camera to fit the markers (`_isFirstLoad` guard).

The offer list below the map is driven by `ValueNotifier<List<Offer>> _notifierOffers`. Empty list → `RoutingMapControls` placeholder; non-empty → `OfferListBottomSheetMapWidget`.

### Invariants for tap callbacks

- **Always guard `_notifierOffers.value =` with `if (!mounted) return;` after each `await`.** The widget can be popped while `showMarker` is awaiting platform-channel calls; writing to a disposed `ValueNotifier` throws.
- **Single-marker tap had the same crash mode as cluster tap.** If `_onTapMarker` writes to `_notifierOffers` after `await showMarker(...)` without re-checking `mounted`, the widget can already be disposed and the app will crash on marker tap.
- **Do not animate camera from inside cluster/marker tap handlers.** `cameraPosition.animateToMarkers(simpleClusterObject.markers.toMarkers())` constructs ad-hoc `Marker` objects whose IDs may not be tracked on the native side; the SDK's `calcPosition` can throw on the resulting empty/sparse list (root cause of BALADY-3581). Use camera animation only from `_showOffers` first-load, where markers are guaranteed to be added.
- **Always pass an explicit `icon` when calling `showMarker`** for offer pins — the BALADY-3570 guard relies on `icon != Markers.defaultPinNew` to preserve the explicit path.

### Cluster behavior

Clustering options:
- `_kClusterLogicalPixel = 40` — clustering radius in logical pixels.
- `_kClusterMaxZoom = 20` — clusters are released past this zoom; below it, even widely-separated offers may stay in a single cluster.
- `_kClusterIconSize = 32`.

Two offers at **identical** lat/lng never declustering at any zoom — that's the typical BALADY-3581 reproduction case. The cluster centroid equals each marker's position, so `markerByGeoPoint(centroid)` finds one of them; the BALADY-3570 icon guard handles the rest.

## Offer types

- **vouchers** (`TypeDetails.vouchers`) — voucher; relevant fields: `amount`, `number`
- **coupons** (`TypeDetails.coupons`) — coupon; relevant fields: `ratio`, `maxRatio`, `code`

`offer.code` and `offer.discount` are computed getters that return the correct field based on the offer type.

## getPromotions — notable parameters

- `cityIds` — required; throws `Exception` if empty
- `mapPoint` + `range` — geo filter; if omitted, falls back to current device location via `Helpers.getCurrentLocation()`
- `pageSize: null` — disables pagination (returns all results at once); used for the map view
- Client-side deduplication by `offer.id` happens inside `switchOffersVisibility`

## API response pattern

All responses are wrapped in `MomraBody<T, D>`. Data is extracted via `.dataOrThrow()`. The `location` field in an offer's JSON may arrive as `null` — the client substitutes `{latitude: '0.0', longitude: '0.0'}`.
