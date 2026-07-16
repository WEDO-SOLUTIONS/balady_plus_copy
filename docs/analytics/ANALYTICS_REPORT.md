# Balady+ analytics — what, where, why

> **UPDATE 2026-07-14:** stream B (UXCam) has been fully removed from the code; all of its
> events have been migrated to the internal `BaladyAnalytics` facade
> (`mapness/lib/features/balady_analytics/`, see the README there and
> `docs/analytics/DEVOPS_BRIEF.md`). The UXCam sections below are kept as a
> historical event map.

> A report on the entire analytics/telemetry system of the **Balady+** Flutter superapp.
> Compiled from the code on the `development` branch (the `mapness/` module + the root
> host shell `lib/`). The entry point was the
> `mapness/lib/features/app_analytics/` feature, but, as expected, analytics
> in the app is **split across several independent streams** — the full map is below.

---

## 0. TL;DR — stream map

The app hosts **8 coexisting analytics/telemetry systems**, grouped into
several streams. They are _not_ unified under a single facade: only two of them
(Insider + BytePlus) go through the shared `appAnalyticsProvider`, the rest are
called directly from feature code.

| # | Stream | Package / SDK | Purpose (why) | Entry point | ≈ call sites |
|---|-------|-------------|--------------------|-------------|----------------|
| A1 | **Insider** | `flutter_insider` | CRM / push / geofencing + basic product events | `appAnalyticsProvider` (composite) | 38 (shared facade) |
| A2 | **BytePlus / DataFinder** | `rangers_applog_flutter_plugin` | Search behavior analytics (ByteDance), 9 search events + basics | `appAnalyticsProvider` (composite) | 38 (shared facade) + 20 DataFinder |
| B | **UXCam** | `flutter_uxcam` | Session recording, screen tags, custom events, exception reporting | `Metrics` (`urbi_metrics.dart`) + `routes_observer` | ≈145 (`Metrics.*`) + 13 |
| C | **Mixpanel** | `mixpanel_flutter` | Operation timing/latency (network, search, auth) | global `mixpanel?` | ≈44 |
| D | **Urbi Analytics** | `urbi_analytics` (`balady-metrics.urbi.ae`) | Urbi's own metrics backend: screens + custom events + AdvancedMetrics sink | `urbiAnalyticsProvider` | ≈48 |
| E | **AdvancedMetrics** | `urbi_metrics_utils.dart` (singleton) | Tech telemetry: startup, battery, GPS loss, search response time, route calculation | `AdvancedMetrics.instance` → sends via (D) | ≈19 |
| F | **Adjust** | `adjust_sdk` (`advert_metrics.dart`) | Marketing / ad conversion attribution | `advertMetricsProvider` | ≈31 |
| G | **BSS** | in-house `BssService` → Balady backend | Server-side stream of UI events (POI, search, deeplink), batched every 5 s | `BssService.instance` | ≈43 (27 files) |
| H | **Host shell** | `firebase_analytics`, `sentry_flutter`/`sentry_dio`, `firebase_messaging`, `firebase_remote_config` | Firebase Analytics + Sentry (crashes/errors) at the root `lib/` level | root `lib/main.dart`, `lib/app/...` | — |

> **Firebase Crashlytics** is declared as a dependency override (`pubspec.yaml`) but
> is **never initialized or used** in the code — a "dormant" dependency.
> Systems like Amplitude, Segment, AppsFlyer, Countly, PostHog, AppMetrica,
> Braze, CleverTap, OneSignal, HMS Analytics are **not** present in the repository.

**How this splits into streams conceptually:**

- **Product analytics (what the user does):** Insider + BytePlus (via
  `appAnalyticsProvider`), BSS, Urbi Analytics.
- **Behavior/search (in detail):** BytePlus/DataFinder (9 events), BSS.
- **Tech telemetry/performance:** AdvancedMetrics (+ Urbi Analytics as sink),
  Mixpanel (timings), UXCam (session recording).
- **Marketing/attribution:** Adjust.
- **Crashes/errors:** Sentry (+ UXCam `reportExceptionEvent`).

---

## 1. The core — the `app_analytics` feature (the one pointed at)

Location: `mapness/lib/features/app_analytics/`.

This is the **only stream with a shared facade**. Every call goes through a single
Riverpod provider that "fans out" the event across backends:

```
ref.read(appAnalyticsProvider)              ← called by feature code
        │
        ▼
_CompositeAnalytics  (app_analytics.dart)   ← router/splitter
        ├── AppAnalyticsInsiderImpl         ← Insider  (basic events only)
        └── AppAnalyticsBytePlusImpl        ← BytePlus (basics + 9 DataFinder)
```

### 1.1 Architecture (two capability interfaces)

The file `app_analytics_repository.dart` declares **two** interfaces:

| Interface | Implemented by | Events |
|-----------|-----------|---------|
| `AppAnalyticsRepository` | Insider **and** BytePlus | basic (navigation, onboarding, …) |
| `DataFinderAnalyticsRepository` | BytePlus **only** | the 9 DataFinder search events |

`AppAnalyticsApi` combines both. For DataFinder events the composite does
`whereType<DataFinderAnalyticsRepository>()` — i.e. those 9 events reach
**only** BytePlus; Insider never sees them. To add a new sink
(e.g. BSS) without touching call sites, its impl just needs to also
implement `DataFinderAnalyticsRepository`.

**Key files:**

| File | Purpose |
|------|-----------|
| `app_analytics_repository.dart` | Both interfaces — signatures of all events |
| `app_analytics.dart` | `AppAnalytics` provider + `_CompositeAnalytics` (fan-out) + `setUserInfo` logic |
| `data/app_analytics_insider_impl.dart` | Insider impl (`tagEvent().build()`) |
| `data/app_analytics_byteplus_impl.dart` | BytePlus impl (`onEventV3`) + dry-run on simulator |
| `models/datafinder_models.dart` | Payload models, enums, UUID generator, `DataFinderOrigin.resolve` (8 `event_source` values) |
| `models/datafinder_mappers.dart` | `DirectoryObjectMessage`/`SuggestMessage` → `DataFinderPoi` |
| `datafinder_source_tracker.dart` | Stores the "origin" of the current journey (Map/Explore/Routes/FreeRoam) |
| `README.md` | Detailed engineering guide (the primary source on DataFinder) |

### 1.2 Stream A1 — Insider (`flutter_insider`)

- **Why:** engagement platform — push notifications, deeplinks, geofencing,
  plus receiving basic product events.
- **Initialization:** `entry_point.dart` → `initInsider()` (lines 811-845):
  `FlutterInsider.Instance.init('baladyapp', 'group.movingViolations', callback)`,
  then `setActiveForegroundPushView()` and `registerWithQuietPermission(false)`.
- **Geofence after consent:** `enableInsiderGeofenceAfterConsent()`
  (`entry_point.dart:1483`) — enables location collection and geofence tracking.
- **Identification:** `setUserInfo` → `user.login(identifiers)` with email/locale/
  custom attributes (device_id, device_os, app_version).
- **Receives basic events only** (see the catalog in §1.4); no DataFinder events.
- **iOS:** pods `InsiderMobile`, `InsiderHybrid`, `InsiderMobileAdvancedNotification`;
  URL schemes `insiderbaladyapp` / `insiderbaladyappuat`.
  **Android:** maven `mobilesdk.useinsider.com/android`.

### 1.3 Stream A2 — BytePlus / DataFinder (`rangers_applog_flutter_plugin`)

- **Why:** ByteDance behavioral analytics (the **DataFinder** project). The main
  goal of phase two is detailed tracking of search/POI behavior per the
  "Balady User Behavior Tracking Metrics — BRD V0.1" spec.
- **Initialization:** `entry_point.dart` → `_initBytePlus(envType)` (line 1453),
  called from `setupMapness()`:
  ```dart
  RangersApplogFlutterPlugin.initRangersAppLog(
    appId,        // from RemoteConfig / .env.<flavor>
    channel,      // BYTEPLUS_CHANNEL
    true,         // enableAb
    false,        // enableEncrypt
    !isProduction,// enableLog (verbose on stg/dev, quiet on prod)
    'https://balady.finder-snssdk.bytepluses.com',
  );
  ```
  A `_bytePlusInitialized` guard flag prevents double SDK initialization
  (the engine may reattach). If `BYTEPLUS_APP_ID` is empty, init is skipped.
- **App ID per flavor** (`.env.<flavor>` → `BYTEPLUS_APP_ID`):
  `prod` → `10000002` (project "Balady"); `stg`/`pre`/`dev` → `10000000`
  ("Balady Staging Test"). This keeps pre-prod and below from polluting prod analytics.
- **All events:** via `RangersApplogFlutterPlugin.onEventV3(name, params)`.
- **Identification:** `setUserUniqueId(userId)` — `userId = sub` (SSO subject, a single
  id for both phone-OTP and national-id logins), fallback `idNo`; `null` = **logout**
  (important: the call is not guarded by a null-check, otherwise the previous user
  would "stay logged in").
- **Screen auto-tracking is DISABLED deliberately:** `RangersApplogNavigationObserver`
  is **not** registered (`entry_point.dart:126-132`) — its element-tree traversal
  breaks nested `auto_route` tab navigators (red screen). All DataFinder
  events are sent explicitly from the search/POI flows.
- **iOS:** pod `RangersAppLog 6.17.7-iOS26-xc-rc2` (a single XCFramework — both simulator
  and device).

**Dry-run on simulator (important):** BytePlus only shows data from real
devices. Hence `app_analytics_byteplus_impl.dart` has an auto-gate:
- **simulator/emulator** → events are **only logged** (`[DataFinder][DRY-RUN] …`),
  not sent;
- **real device** → events are sent (`[DataFinder] …`).

Detection is via `device_info_plus` `isPhysicalDevice` (resolved once at
startup; dry-run until resolved — the safe default). Manual override:
`_forceDryRun = true`.

### 1.4 Catalog of basic events (Insider + BytePlus) and where they are called

All go through `ref.read(appAnalyticsProvider).<method>()`. They are sent **to both Insider and
BytePlus** simultaneously. BytePlus event names in parentheses (`onEventV3`).

| Facade method | BytePlus event | Where called (trigger) |
|--------------|------------------|--------------------------|
| `onboardingFlowStarted` | `onboarding_flow_started` | `guards/onboard_route_guard.dart:17` — entering onboarding |
| `onboardingFlowSkipped` | `onboarding_flow_skipped` | `stories_fullscreen.dart:93`, `story_frame_widget.dart:333` — skipping stories |
| `onboardingFlowCompleted` | `onboarding_stories_completed` | `stories_fullscreen.dart:98,131`, `story_frame_widget.dart:331` — end of stories |
| `navigationSearch` | `navigation_search` | `navi_search_content.dart:80` — searching for a destination |
| `navigationStarted` | `navigation_started` | `routing_info.dart:510` — tapping "GO" |
| `navigationHalfWay` | `navigation_half_way` | `path_nav_eta.dart:60` — more than 50% of the route covered |
| `navigationCompleted` | `navigation_completed` | `path_nav_page.dart:662` — arrival |
| `userMovementDetected` | `user_movement_detected` | ⚠️ **never called** (method exists, 0 call sites) |
| `categorySelected` | `category_selected` | `entry_point.dart:1206` (deeplink), `map_quick_filters.dart:95` — quick filter selection |
| `serviceSectionVisited` | `service_section_visited` | `bottom_menu_page.dart:98` — "Services" tab |
| `quickActionSelected` | `quick_action_used` | `dashboard_actions.dart` (parking/qibla/quran/athkar/free-roam/my-location/snap-send/road-event) + deeplinks in `entry_point.dart` (~10 sites) |
| `appIconQuickActionSelected` | `app_icon_quick_action_used` | `app_icon_quick_action_handler.dart:323` — app icon shortcut |
| `carPlayConnected` | `carplay_connected` | `car_enable_free_roam.dart:28` — CarPlay/Android Auto connection |
| `poiContributionUsed` | `contribution_used` | `submit_feedback.dart:78` — submitting a POI contribution |
| `isNavigationUser` | `is_navigation_user` | `path_nav_page.dart:262` — first navigation completion |
| `deviceTypeDetected` | `device_type_detected` | `entry_point.dart:212` — at app startup |
| `networkConnectionType` | `network_type_detected` | `entry_point.dart:293,295` — mobile/wifi at startup |
| `transportModeSelected` | `transport_mode_selected` | `routing_info.dart:441` — transport type selection + GO |
| `setUserInfo` | profile + `setUserUniqueId` | from `AppAnalytics.build()` — on every login/logout/account switch |

> ≈36 call sites for basic events in total. The most frequent — `quickActionSelected`.

### 1.5 The 9 DataFinder events (BytePlus only) and where they are called

| Event | Facade method | Where called (trigger) |
|---------|--------------|--------------------------|
| `search_box_click` | `searchBoxClick` | `map_search_bar.dart:170`, `routing_search_bar.dart:79` — search field focus |
| `search_box_input` | `searchBoxInput` | `map_search_bar.dart:271`, `routing_search_bar.dart:125` (Manual); `map_search_history.dart:39`, `navi_search_history.dart:40` (History) |
| `search_button_click` | `searchButtonClick` | `map_search_bar.dart:335`, `routing_search_bar.dart:141` — keyboard search button |
| `quick_search_click` | `quickSearchClick` | `search.dart:407` (landing chips), `map_search_content_v2.dart:280` (sheet chips) |
| `favorite_add` | `favoriteAdd` | `poi_favorite_dialog.dart:69` — adding to favorites (Home/Work/List) |
| `suggestion_exposure` | `suggestionExposure` | `search.dart:877` — suggestion list shown (per item!) |
| `suggestion_click` | `suggestionClick` | `search.dart:856` (notifier) ← `suggest_item.dart:108` (tap) |
| `search_results_exposure` | `searchResultsExposure` | `search.dart:924` — results shown + pagination (per item!) |
| `search_results_click` | `searchResultsClick` | `search.dart:842` (notifier) ← `map_search_results.dart:115`, `navi_search_results.dart:114`, `routing_search_results.dart:121` |

**⚠️ Exposure events are PER ITEM, not arrays.** Per the BRD, "10 displayed
items → 10 separate events". The loop lives in `app_analytics_byteplus_impl.dart`
(the BytePlus dashboard cannot parse arrays). 20 results → 20
`search_results_exposure` events, each with its own `poi_*` plus the shared context. Pagination:
`poi_rank` continues across pages (page 1 → 1-20, page 2 → 21-40), `request_id`
and `search_session_id` are reused.

**Enum values** (`datafinder_models.dart`):
- `operation_type`: `Manual` · `History`
- `trigger_method`: `Keyboard`
- `favorite_type`: `Home` · `Work` · `Not Specified`
- `search_type`: `Manual` · `Quick search` · `Click suggestion` · `History` · `Search in this area`
- `click_action`: `View POI Details` · `Initiate Navigation` · `Share POI` · `Add to Favorites`
- `event_source` (8): `Map-Main Page` · `Map-Direction-Path Changing` · `Explore-Main Page` · `Explore-Free Roam` · `Explore-Direction` · `Explore-Direction-Path Changing` · `Routes-Main Page` · `Routes-Path Changing`

### 1.6 `event_source` — origin tracking (8 values)

Balady is **a single map screen with overlay controllers**, so `event_source`
is **not** a route — it is **the surface where the journey started**, combined with
the live navigation state.

**1) The origin is "stamped"** on entering a surface
(`datafinder_source_tracker.dart` → `stampOrigin`):

| Origin | Where it is stamped |
|--------|----------------|
| `map` | `map_tap_handler_provider.dart:184` — tapping a POI on the map |
| `explore` | `bottom_menu_page.dart:68` (Explore tab) + `map_search_sheet.dart:103` (opening search); **default** |
| `routes` | `bottom_menu_page.dart:70` — Routes tab |
| `freeRoam` | `free_roam_page.dart:67` — entering Free Roam |

**2) It is resolved** via `DataFinderOrigin.resolve(inNavigation, pathChanging)`
(`datafinder_models.dart`, read in `search.dart:157,167`): origin ×
active `PathNavRoute` × active `RoutingRoutes`/`RouteDetails` → one of the 8
values. For example: a map journey stays `Map-Main Page` all the way through Directions→Go→Search
(only editing an already drawn route → `Map-Direction-Path Changing`);
an explore journey becomes `Explore-Direction` when navigation starts.

**3) Out-of-band events** (`favorite_add` from a dialog outside search scope) read the
same origin via `searchProvider(map).dataFinderEventSource` — a favorite added from the map
= `Map-Main Page`, from Routes/Direction search = inherits the surface.

The invariant is pinned by the test
`test/features/app_analytics/datafinder_origin_resolve_test.dart`.

### 1.7 Correlators (client-side UUIDs)

The 2GIS SDK does not expose a server request id, so they are generated in the `Search`
notifier (`DataFinderIds.uuid()`, `datafinder_models.dart`):

- `request_id` — new on **every SDK call** (`search.dart:316,405,472,553`).
- `suggestion_session_id` — one per suggestion session, set on the first
  keystroke (`search.dart:315`).
- `search_session_id` — one per search, new on page 1, does **not** change across pagination
  (`search.dart:404,471,552`).

The `suggestion_exposure↔suggestion_click` and `search_results_exposure↔click`
pairs are linked by a matching session id. The `_searchFromHistory` /
`_searchFromQuickFilter` flags determine `search_type`.

`DataFinderPoi` is built by shared mappers (`datafinder_mappers.dart`):
`directoryObjectMessage.toDataFinderPoi(...)` / `suggestMessage.toDataFinderPoi(...)`;
`poi_type` — the 2GIS object type string (`branch`, `street`, …; `unknown` → `place`),
`poi_distance` — km rounded to 2 decimal places (minimum 0.01).

### 1.8 Tests and documentation
- `test/features/app_analytics/datafinder_origin_resolve_test.dart` — the 8 `event_source` values.
- `test/features/app_analytics/datafinder_poi_json_test.dart` — POI serialization.
- `mapness/lib/features/app_analytics/README.md` — the full engineering guide.
- `docs/datafinder_event_examples.md` — payload examples per event (v1.1, BRD order).

---

## 2. Other telemetry streams (outside `appAnalyticsProvider`)

### 2.1 UXCam (`flutter_uxcam`) — session recording + the largest event stream

- **Why:** session recording, screen tags, custom events, exception reporting.
- **Initialization:** `entry_point.dart` → inside `initMixpanel()` (lines 711-727):
  `FlutterUxcam.startWithConfiguration(FlutterUxConfig(... userAppKey: '2w1otnta9bvvhzo' ...))`
  (crash handling, multi-session record; network log in debug only). An init failure
  is not critical — the app keeps running.
- **The `Metrics` wrapper** (`mapness/lib/shared/lib/urbi_metrics.dart`): static
  `Metrics.logEvent` / `logEventAdvanced` → `FlutterUxcam.logEvent[WithProperties]`,
  `Metrics.logException` → `FlutterUxcam.reportExceptionEvent`. This is the **most frequently used**
  channel: ≈145 `Metrics.*` calls across all of `mapness/lib`.
- **Screen tags:** `routes_observer.dart` — `FlutterUxcam.tagScreenName(path)` on
  every push/tab switch (SDK auto-tags are off, tags are set manually).
- **Direct events:** `CommonFunctions.sendUXCamEvent(...)` (e.g. SnapAndSend,
  `entry_point.dart:1188`).
- 📄 **The full list of all 145 UXCam events** (by tag, with names and `file:line`) —
  in the separate file [`ANALYTICS_UXCAM_EVENTS.md`](ANALYTICS_UXCAM_EVENTS.md).

### 2.2 Mixpanel (`mixpanel_flutter`) — operation timings

- **Why:** measuring latency/success of operations (network, search, auth, cache).
  The `timeEvent('X')` … `await track('X')` pattern around async operations.
- **Initialization:** `entry_point.dart` → `initMixpanel()` (lines 696-704),
  token `2d045d85e25087812e92c62b84d6fbc3`, `trackAutomaticEvents: true`. A global
  `Mixpanel? mixpanel` variable (nullable — if init failed, `mixpanel?.` calls are
  no-ops).
- **Where:** ≈44 sites — `search.dart` (fetchSuggest/quickSearch/searchByText/
  searchByQuery), `auth_provider.dart` (doAuth/logOut/reset), `favourite_cache.dart`,
  `weather_remote_datasource.dart`, `stories_repo.dart`, `profile_image_provider.dart`,
  `iwish_entity.dart`, `qr_license_repository.dart`.
- On logout — `mixpanel?.reset()`.

### 2.3 Urbi Analytics (`urbi_analytics`) — in-house metrics backend

- **Why:** product metrics into the Urbi/Balady backend.
  `createClient(Configuration('balady-metrics.urbi.ae/metrics-api'))`.
- **Provider:** `urbiAnalyticsProvider` (`shared/providers/urbi_analytics.dart`),
  `keepAlive`. API: `.track(event, properties)`, `.screen(path)`, `.trackWithPrint(...)`.
- **Where (≈48):** `routes_observer.dart` (`.screen()` on every screen),
  `entry_point.dart:1204` (quickFilterSearch), `app_icon_quick_action_handler.dart`,
  `thermal_monitor.dart`, `search.dart` (emptySuggestResult/suggestResult etc.),
  and as the **sink (`track`)** for AdvancedMetrics (§2.4).
- The native bridge `_HostFlutterApi.analyticsTrack` (`entry_point.dart:1600`) also
  sends to `analyticsClient.track` with `{'app_run': ...}`.

### 2.4 AdvancedMetrics (`urbi_metrics_utils.dart`) — tech telemetry

- **Why:** app health/performance. A singleton with its own
  `sessionId` (uuid). Metrics: startup time, battery usage, GPS loss/recovery,
  search response time, route calculation, load time.
- **Where it sends:** via the `track:` callback = `ref.read(urbiAnalyticsProvider).track`,
  i.e. effectively stream **(D) Urbi Analytics**.
- **Where (≈19):** `entry_point.dart` (`stopMeasureStartup`, `sendPreviousSessionBatteryUsage`,
  `startMeasureBattery`), `path_nav_message.dart` (lost/restore GPS),
  `search.dart` (`startSearchResponse`/`stopSearchResponse`).

### 2.5 Adjust (`adjust_sdk`) — marketing/attribution

- **Why:** ad conversion attribution (advert metrics).
- **Provider:** `advertMetricsProvider` (`features/advert_metrics/advert_metrics.dart`);
  `Adjust.trackEvent(AdjustEvent(token))`.
- **Tokens:** the `AdvertMetricsKeys` enum → short Adjust tokens (e.g.
  `exploreLandingEngagement → 'g1f5nk'`, `poiSubmitted → 'vkqfwl'`). There is an
  `isUniquePerSession` flag (checks the `sessionId` from AdvancedMetrics via `sharedPrefs`).
- **Where (≈31):** landing engagement (`map_tap_handler_provider.dart:227`), search
  (`entry_point.dart:1207`), POI submission (`search_results.dart`, stories,
  `submit_feedback.dart`), routes (`path_nav_page.dart` — halfway/completed/unique).
- **Android:** pods `com.adjust.sdk:adjust-android(+meta-referrer,+oaid)`.

### 2.6 BSS (`BssService`) — in-house server-side stream of UI events

- **Why:** a structured stream of user events into the Balady backend
  (BSS). `BssRequest` format (eventType, actionType, uiElement, payload).
- **Implementation:** `shared/providers/analytic/bss_service.dart` — a singleton with
  a **queue and batch dispatch every 5 s** (`_sendInterval`, `_eventStack`,
  `Timer.periodic`). Initialized with `Dio`, `BssCommon`, and a visible-area stream.
- **Where (≈43 calls in 27 files):** especially dense in POI cards
  (`pages/poi_card/*`, `poi_content_sliver.dart`), search (`suggest_item.dart`,
  `search_results.dart`), deeplink-initiated search (`entry_point.dart:1214`).

### 2.7 Host shell (root `lib/`) — Firebase Analytics + Sentry

The root `lib/` is the superapp host application wrapping the `mapness` module.
Two more streams live here (per search results; keys not listed):

- **Firebase Analytics** (`firebase_analytics`): `fbAnalytics = FirebaseAnalytics.instance`
  in `lib/app/core/utils/common_functions.dart:73`, event logging at the shell level.
  Firebase Analytics is **not** used inside `mapness` itself — only Firebase
  **Core** (init in `app_config_loader.dart`), **Messaging** (push) and **Remote Config**.
- **Sentry** (`sentry_flutter`, `sentry_dio`): initialized in the root `lib/main.dart`
  (`SentryFlutter.init` wrapper, `SentryScreenshotWidget`, `SentryUserInteractionWidget`),
  DSN on self-hosted `sentry.momah.gov.sa`. Perf tracing is throttled in prod. Plus
  UXCam `reportExceptionEvent` duplicates some of the exceptions.

---

## 3. Matrix: "event → where it goes"

| Event domain | Insider | BytePlus | UXCam | Mixpanel | Urbi | AdvMetrics | Adjust | BSS | Sentry/FBA |
|---------------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Onboarding/stories | ✅ | ✅ | ✅ | | | | ✅ | | |
| Navigation (start/half/complete) | ✅ | ✅ | ✅ | | ✅ | ✅ | ✅ | | |
| Quick filters/categories | ✅ | ✅ | ✅ | | ✅ | ✅ | | ✅ | |
| Search (suggest/results) | | ✅ (DataFinder) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | |
| POI card/actions | | ✅ (favorite/click) | ✅ | | | | ✅ | ✅ | |
| Screens (screen views) | | | ✅ (tag) | auto | ✅ (`.screen`) | | | | (FBA in the shell) |
| Tech telemetry (battery/GPS/startup) | | | | ✅ (timings) | ✅ (sink) | ✅ | | | |
| Crashes/exceptions | | | ✅ (report) | | | | | | ✅ Sentry |
| User identification | ✅ login | ✅ setUserUniqueId | | reset on logout | | | | | |

> "Where it goes" is approximate: some domains are not covered by all the listed
> calls at once; the matrix reflects which systems are involved in a domain
> at all.

---

## 4. Observations and potential risks

1. **Only two systems share a facade.** Insider + BytePlus go through
   `appAnalyticsProvider`. The other 6 streams (UXCam/Mixpanel/Urbi/AdvancedMetrics/
   Adjust/BSS) are called directly and separately — the same action is often
   logged into 3-5 systems in different places (e.g. `_openQuickFilter` in
   `entry_point.dart` sends to Urbi + appAnalytics(categorySelected) + Adjust + BSS at once).
   This is expected for a superapp, but raises the risk of name/semantics drift.
2. **`userMovementDetected` is dead code:** the method is implemented in both impls but
   is **never called** anywhere. A candidate for removal or for wiring up.
3. **Hardcoded keys in the code:** the Mixpanel token and UXCam `userAppKey` are baked into
   `entry_point.dart` (not via `.env`/RemoteConfig, unlike BytePlus). Worth
   unifying onto per-flavor config.
4. **Firebase Crashlytics is a dormant dependency:** declared as an override, but never
   initialized or used. Either wire it up or drop it.
5. **UXCam init inside `initMixpanel()`** — semantically hidden; the method name
   does not reflect that UXCam is also started there.
6. **The BytePlus prod App ID** was previously listed as an open question (registration in
   the BytePlus console) — verify that `.env.prod` actually contains `10000002`
   and the prod channel (see README §9).
7. **Private data in session recordings:** UXCam records screens in full —
   make sure sensitive fields (SSO/national id, favorite addresses)
   are masked (occlusion).

---

*Report generated by automated code traversal; line numbers are accurate as of the time
of writing (`development` branch). The primary source on DataFinder is
`mapness/lib/features/app_analytics/README.md`.*
