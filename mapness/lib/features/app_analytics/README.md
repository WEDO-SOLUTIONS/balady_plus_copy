# DataFinder (BytePlus) Analytics — Engineer's Guide

Everything you need to understand, use, run, and test the BytePlus / DataFinder
user-behaviour tracking in Balady+. One document — no other md files needed.

- **Feature:** track user search/POI behaviour (US 47240, "Search Engine SDK
  Integration Phase 2") and report it to ByteDance's DataFinder dashboard.
- **Spec:** `Balady User Behavior Tracking Metrics - BRD V0.1`.
- **Branch:** `feature/search_data_finder_sdk`.

---

## 1. Architecture (how it works)

Every analytics call goes through ONE Riverpod provider, which fans out to the
backends that support it. Feature code never imports an SDK.

```
ref.read(appAnalyticsProvider)            ← you call this
        │
        ▼
_CompositeAnalytics  (app_analytics.dart) ← splitter / router
        ├── AppAnalyticsInsiderImpl       ← Insider SDK   (base events only)
        └── AppAnalyticsBytePlusImpl       ← BytePlus SDK  (base + DataFinder events)
```

**Shareable design — two capability interfaces:**

| Interface | Implemented by | Events |
|-----------|----------------|--------|
| `AppAnalyticsRepository` | Insider **and** BytePlus | the original nav/onboarding events |
| `DataFinderAnalyticsRepository` | **BytePlus only** | the 9 DataFinder search events |

The composite checks `impl is DataFinderAnalyticsRepository` and routes the
9 search events **only** to BytePlus. Insider never receives them. To add a new
destination later (e.g. BSS) with different keys, just have its impl also
implement `DataFinderAnalyticsRepository` — no caller changes.

**Key files** (all under `mapness/lib/features/app_analytics/`):

| File | Purpose |
|------|---------|
| `app_analytics_repository.dart` | Both interfaces — all event signatures |
| `app_analytics.dart` | Riverpod provider + `_CompositeAnalytics` fan-out |
| `data/app_analytics_byteplus_impl.dart` | BytePlus impl (`onEventV3`) + dry-run logic |
| `data/app_analytics_insider_impl.dart` | Insider impl |
| `models/datafinder_models.dart` | Shared payload models, enums, UUID gen |
| `models/datafinder_mappers.dart` | `DirectoryObjectMessage`/`SuggestMessage` → `DataFinderPoi` |
| `lib/entry_point.dart` | SDK init (`setupMapness`) + `MapnessBytePlusObserver` |

---

## 2. The 9 DataFinder events (covered & verified)

All 9 match BRD V0.1 exactly; every attribute + value variation was tested live.

| Event | Fires from | Key attributes |
|-------|-----------|----------------|
| `search_box_click` | search bar focus | event_source, is_first_click |
| `search_box_input` | typing / history tap | operation_type (Manual/History), input_text |
| `search_button_click` | keyboard search key | event_source, trigger_method (Keyboard), search_text |
| `quick_search_click` | quick-filter chip | event_source, search_text (the query) |
| `favorite_add` | Add-to-Favorites dialog | event_source, favorite_type (Home/Work/Not Specified), poi_id, poi_name |
| `suggestion_exposure` | suggestion list shown | search_param, suggestion_session_id, request_id, search_text, per-item suggestion_* |
| `suggestion_click` | tap a suggestion | + suggestion_type, suggestion_name, suggestion_rank, poi_* |
| `search_results_exposure` | results list shown | search_param, search_session_id, request_id, search_text, event_source, search_type, per-item poi_* |
| `search_results_click` | tap a result / its buttons | + click_action, poi_* |

### Enumerated values
- **operation_type:** `Manual` · `History`
- **trigger_method:** `Keyboard`
- **favorite_type:** `Home` · `Work` · `Not Specified`
- **search_type:** `Manual` · `Quick search` · `Click suggestion` · `History` · `Search in this area`
- **click_action:** `View POI Details` · `Initiate Navigation` · `Share POI` · `Add to Favorites`
- **event_source (8):** `Map-Main Page` · `Map-Direction-Path Changing` · `Explore-Main Page` · `Explore-Free Roam` · `Explore-Direction` · `Explore-Direction-Path Changing` · `Routes-Main Page` · `Routes-Path Changing`

### Where each event fires (call sites)
- Search box (`search_box_click/input`, `search_button_click`): `pages/map_search/ui/map_search_bar.dart`
- Quick search (`quick_search_click`): inside `Search.quickSearch()` in `features/search/providers/search.dart`
- Suggestion/results exposure + click reporting: orchestrated by `features/search/providers/search.dart`
- Suggestion tap (`suggestion_click`): `features/search/ui/suggest_item.dart`
- Result tap + action buttons (`search_results_click`): `pages/{map_search,navi_search,routing}/ui/*_search_results.dart`
- History tap (`operation_type: History`, `search_type: History`): `pages/{map_search,navi_search}/ui/*_search_history.dart`
- Favourite add (`favorite_add`): `features/poi_card/widgets/poi_favorite_dialog.dart`

### Correlators (client-generated, per ByteDance)
The 2GIS SDK exposes no server request id, so we generate UUIDs in the `Search`
notifier: `request_id` (per SDK call), `suggestion_session_id` (per suggest
session), `search_session_id` (per search; new at page 1, not on pagination).
`suggestion_exposure`↔`suggestion_click` and `search_results_exposure`↔`click`
link via the matching session id.

### Known limits (raised with ByteDance)
- The app has a single map surface → `Map-Main Page` vs `Explore-Main Page`
  cannot be split; we report `Explore-Main Page`. `Explore-Free Roam` is not
  separately detected. `event_source` is route-based.
- `favorite_add` only sends `poi_id` + `poi_name` (addr/type/distance are not
  stored on a saved favourite — backend fills from `poi_id`).
- `search_param` carries `suggest_type=object` (the default suggestor mode).

---

## 3. How to USE (send a DataFinder event)

```dart
// Get the service (it is the provider's state, NOT .notifier):
final analytics = ref.read(appAnalyticsProvider);

// Base event (goes to Insider + BytePlus):
analytics.navigationStarted(originLocation: 'Riyadh', destinationLocation: 'Jeddah', ...);

// DataFinder event (goes to BytePlus only):
analytics.searchResultsClick(
  eventSource: DataFinderSourcePage.exploreMainPage,
  requestId: requestId,
  sessionId: sessionId,
  searchText: 'mall',
  clickAction: DataFinderClickAction.viewPoiDetails,
  poi: item.toDataFinderPoi(rank: 1, myLat: lat, myLon: lon),
);
```

Build POI data with the shared mapper:
```dart
final poi = directoryObjectMessage.toDataFinderPoi(rank: index + 1, myLat: lat, myLon: lon);
final poi = suggestMessage.toDataFinderPoi(rank: index + 1, myLat: lat, myLon: lon);
```

### Adding a brand-new DataFinder event
1. Add the signature to `DataFinderAnalyticsRepository` in `app_analytics_repository.dart`.
2. Implement it in `AppAnalyticsBytePlusImpl` via `_send('event_name', {...})`.
3. Add the fan-out in `_CompositeAnalytics` (loop over `_dataFinderImpls`).
4. Call it from your feature via `ref.read(appAnalyticsProvider)`.

---

## 4. How to RUN

```bash
cd mapness

# Simulator (staging)
fvm flutter run --flavor stg -t lib/main_stg.dart

# Real device (production)
fvm flutter run --flavor prod -t lib/main_prod.dart
```

On startup you'll see the BytePlus init log in the Xcode/console output.

### iOS pod note (simulator vs device)
RangersAppLog ships device-only and simulator-only native slices. We use a
single **XCFramework** (`RangersAppLog 6.17.7-iOS26-xc-rc2` in `ios/Podfile`)
that bundles **both** slices, so one `pod install` works on simulator (stg/dev)
**and** real device (pre/prod). No scheme-based swapping needed.

---

## 5. Simulator vs Physical Device — sending behaviour ⚠️ IMPORTANT

The SDK runs on the simulator, but BytePlus only shows **real-device** data on
the dashboard. So sending is **auto-gated** in `app_analytics_byteplus_impl.dart`:

| Where you run | What happens |
|---------------|--------------|
| **iOS Simulator / Android emulator** | Events are **logged locally only**, NOT sent. Console shows `[DataFinder][DRY-RUN] ...`. Dashboard stays clean. |
| **Physical device** | Events are **sent** to BytePlus. Console shows `[DataFinder] ...` (no DRY-RUN). Visible on the dashboard. |

Detection uses `device_info_plus` `isPhysicalDevice`, resolved once at startup.
Before it resolves, we dry-run (safe default).

**Manual override** (force dry-run even on a real device, for local testing):
in `app_analytics_byteplus_impl.dart` set `_forceDryRun = true`. Leave it
`false` for normal behaviour.

> So: you can run on the simulator freely — nothing pollutes the dashboard.
> Real data only flows from physical devices.

---

## 6. How to TEST locally

1. Run on the **simulator** (auto dry-run — nothing is sent).
2. Watch the console for lines starting with `[DataFinder]`:
   ```
   [DataFinder][DRY-RUN] search_results_click -> {"event_source":"...","click_action":"View POI Details",...}
   ```
3. Trigger each flow and check the payload against §2.

### Test checklist (all verified ✅)
| Action | Expect |
|--------|--------|
| Tap search box | `search_box_click` (is_first_click true→false on re-tap) |
| Type text | `search_box_input` (Manual) + `suggestion_exposure` |
| Tap a suggestion | `suggestion_click` (session links to exposure) |
| Press keyboard search | `search_button_click` (Keyboard) + `search_results_exposure` (Manual) |
| Tap a result card | `search_results_click` (View POI Details) |
| Tap Directions/Share/Bookmark on a result | `search_results_click` (Initiate Navigation / Share POI / Add to Favorites) |
| Tap a quick-filter chip | `quick_search_click` + exposure (Quick search) |
| Tap a history item | `search_box_input` (History) + exposure (History) |
| Add to favourites (Home/Work/plain) | `favorite_add` (Home / Work / Not Specified) |
| Search from navigation flow | event_source = `Explore-Direction` |

Verified across all three search surfaces: **map**, **navi**, **routing**.

> Note on simulator: distances are huge and `location=` is San Francisco — that's
> the simulator's fake GPS, not a bug. Real devices report correct KSA values.

---

## 7. BytePlus console (verify real-device data)

| | |
|---|---|
| **URL** | https://balady.finder.bytepluses.com/ |
| **Admin** | `admin` |
| **Initial password** | `dP#YpGyvkm71Qoob8%iP` |

After login → **DataFinder**. To verify events (from a **real device**):
1. **Analysis Tools → Event Analysis** → search the event name (~15 min delay).
2. **Analysis Tools → User Details** → enter the device UUID → check `events`.

### App ID per flavor
`.env.stg` / `.env.dev` → `BYTEPLUS_APP_ID=10000000` (Balady Staging Test APP).
`.env.pre` / `.env.prod` → prod App ID from **Project Center → Details** (pending registration).

### Official docs
- Integration: https://docs.byteplus.com/en/docs/data-intelligence/Flutter_SDK_integration
- API reference: https://docs.byteplus.com/en/docs/data-intelligence/Flutter_SDK_API_Description

---

## 8. SDK initialization (already done — reference)

In `setupMapness()` (`entry_point.dart`), before any widget builds:
```dart
RangersApplogFlutterPlugin.initRangersAppLog(
  appId, channel,
  false,         // enableAb
  false,         // enableEncrypt
  !isProduction, // enableLog
  null,          // host (default endpoint)
);
```
`MapnessBytePlusObserver` is registered in `MaterialApp.navigatorObservers` and
auto-tracks every route as a page view — no per-screen code.

---

## 9. Open questions for ByteDance (pending)
1. `event_source`: single-map app can't split `Map-Main Page` vs `Explore-Main Page`; `Explore-Free Roam` not detected — acceptable to collapse to `Explore-Main Page`?
2. `favorite_add`: backend fills `poi_addr`/`poi_type`/`poi_distance` from `poi_id`?
3. `suggest_type=object` — correct value for the suggest `search_param`?
4. Production App ID — needs registration in the BytePlus console, then add to `.env.pre`/`.env.prod`.
