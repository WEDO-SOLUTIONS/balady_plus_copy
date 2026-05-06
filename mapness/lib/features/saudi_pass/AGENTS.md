# AGENTS.md for `saudi_pass`

Read `mapness/AGENTS.md` first. These instructions apply to the offers feature
(`mapness/lib/features/saudi_pass/`).

## Feature Overview

This feature implements the Tadalal Offers list with two tabs:

- **By Preference** — for logged-in users, applies their saved preferences.
- **All Offers** — for any user, with a manual filters layer.

The feature is fully implemented in this directory. There is no offers code
under `lib/`. State management uses Riverpod (per the `mapness/` package
convention). Do not try to migrate this feature to Bloc.

## Key Files Map

| Layer | File | Purpose |
|---|---|---|
| API client | `repo/saudi_pass_repository.dart` | Talks to `/promotions`, `/preferences`, `/lookups`. `getPromotions(...)` builds the request. |
| Pagination | `async_iterable/offers_chunked_async_iterable.dart` | Chunked offers loader. Two constructors: default (All Offers) and `.byPrefs` (By Preference). |
| State (base) | `notifiers/offers_view_notifier.dart` | Abstract `OffersViewNotifier` — common logic for both tabs and Favorites. |
| State (screen) | `notifiers/offers_screen_view_notifier.dart` | Tab switching + builds `PrefsOffersViewNotifier`. |
| State (filters) | `notifiers/offers_filters_view_notifier.dart` | All Offers filters incl. manual `tapCity()`. |
| State (preferences tab) | `notifiers/prefs_offers_view_notifier.dart` | By Preference offers list. |
| Map view | `providers/show_map_offers_provider.dart` | Renders offers on map; must not re-fetch preferences (US-03). |
| Location | `../../shared/providers/location.dart` | GPS via Geolocator/HMS, KSA-bounding fallback to Riyadh coords. |
| Reverse geocoding | `providers/saudi_pass_city_by_location_riverpod.dart` | 2GIS Geocoder → city id. Falls back to `kRiyadhCityId`. |
| Preferences (read) | `providers/get_profile_preferences_provider.dart` | API GET `/preferences`. |
| City resolver (US-01) | `services/city_resolver/by_preference_city_resolver_provider.dart` | Single source of truth for By Preference city resolution. |

## City Resolution Rules

Both tabs send a single `city` parameter to `/promotions`. The resolution
priority differs per tab. Source: BRD "Offers Lists Enhancements" (Confluence
page 511246338) and Jira BALADY-188.

### By Preference (US-01)

Priority: `Preference City → Current Location City → Riyadh`.

- If the user has a city set in `/preferences` and that city is present in
  `lookups.cities`, use it.
- Else if location services are enabled and reverse geocoding returns a city
  that is present in `lookups.cities`, use that city.
- Else fall back to Riyadh (`kRiyadhCityId`).

Source of truth:
`services/city_resolver/by_preference_city_resolver_provider.dart`.
All By Preference call-sites MUST go through this provider; do not re-implement
the priority chain elsewhere.

### All Offers (US-02 — implemented in a separate branch)

Priority: `Current Location City → Preference City → Riyadh`.

### Map View (US-03 — implemented in a separate branch)

The Offers Map MUST inherit the active filtering / preference context from the
list it was launched from. Do not call `getPreferences()` inside the map
provider; the active filters must be passed from the originating notifier.

## Assumptions

These hold until clarified by the BRD author. Mark any new assumption added in
code with an `// ASSUMPTION:` comment so it is easy to find later.

- `location services disabled` is detected via OS permission state plus
  `Permission.location.serviceStatus`. Both `permission denied` and
  `service off` collapse into `disabled`. Permission granted but no GPS fix
  yet is treated as `disabled` until a fix arrives.
- If reverse geocoding returns a city that is not in `lookups.cities`, treat
  it as if a location-derived city is unavailable and fall through to the
  next priority.
- A manual `tapCity()` override in All Offers wins over the resolver until
  the user resets filters. This preserves current behavior.

## Constants

- `kRiyadhCityId = '70030076560739975'` — defined in
  `constants/saudi_pass_constants.dart`. Do not duplicate the literal across
  the codebase.

## Code Generation

After editing Riverpod-annotated files (`@riverpod`, `@Riverpod`), AutoRoute
routes, or Freezed classes, run codegen from the repo root:

```
just codegen
```

Generated artifacts that must NOT be hand-edited:

- `**/*.g.dart`, `**/*.freezed.dart`
- `mapness/lib/app/auto_route/app_routes.gr.dart`

## Tests

Place tests under `mapness/test/features/saudi_pass/`. Mirror the source path.

The City Resolver is the single most valuable place to unit-test in this
feature. Cover BRD acceptance criteria explicitly: one test per `AC-XX`, named
in the test description (for example, `AC-01: uses preference city when
selected`). Add edge cases for "geocoded city not in lookups" and
"`/preferences` failure".

## Common Pitfalls

- `getPromotions` throws if `cityIds` is empty. The resolver MUST guarantee a
  non-empty result. Do not silently swallow the empty case.
- `OffersChunkedAsyncIterable.byPrefs` historically did the
  `Preference → Location` fallback in its constructor. After introducing the
  resolver, the constructor receives an already-resolved city through the
  `resolvedCity` parameter (see `byPreferenceCityResolverProvider`).
- Do not bypass the resolver by reading `locationProvider` or
  `getProfilePreferencesProvider` directly from offers notifiers — keep the
  logic in one place for testability.
- `lookups.cities.first` is NOT a valid Riyadh fallback. Use
  `kRiyadhCityId` and look it up explicitly.
