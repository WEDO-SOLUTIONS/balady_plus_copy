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

- **`mapObjectManager`** (injected from `OffersOnMapWidget`) — small offer POI markers and clusters.
- **`selectPinMapObjectManager`** (`MapObjectManagerSettings.selectedMarker()`) — separate layer for the selected-offer pin.

### showMarker — critical invariant

```dart
Future<void> showMarker(Marker marker, BaladyAppThemes theme)
```

When a marker is found at the same geo-position (`markerByGeoPoint`), the icon is replaced with the "big" version **only if** the marker's icon is the default (`Markers.defaultPinNew`). If an explicit icon was passed, it is **not** overwritten.

**Why this matters:** small offer icons (`places_new/…/ic_offers.svg`) and large offer icons (`places_big_new/…/ic_offers_pin.svg`) have different file names. `toBigIcon()` only replaces the directory path, so overwriting an explicitly-set icon (`icOffersPin`) would produce a non-existent asset path and cause `PlatformException(Error loading asset for marker)`.

### Marker icons

| State | Icon (light) | Icon (dark) |
|---|---|---|
| Small offer POI | `placesNew.light.icOffers` | `placesNew.dark.icOffers` |
| Offer cluster | `placesNew.light.icOffersClusteringMarker` | `placesNew.dark.icOffersClusteringMarkerDark` |
| Selected offer pin | `placesBigNew.light.icOffersPin` | `placesBigNew.dark.icOffersPin` |

Selected pin marker id constant: `offerPoiPinId = 'offer_poi_pin_id'`.

## OffersOnMapWidget

The map widget for offers. Entry points:

- `_onClusterTap` — cluster tap: if zoom > 16, shows pin and list; otherwise animates the camera to fit all markers.
- `_onTapMarker` — POI tap: shows pin (`icOffersPin`) via `showMarker`, then sets `_notifierOffers.value = [item]`.
- `_setupVisibleRectListener` — 1-second debounce, refreshes offers based on the visible map rect.

The offer list below the map is driven by `ValueNotifier<List<Offer>> _notifierOffers`.

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
