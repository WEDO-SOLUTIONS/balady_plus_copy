# Balady+ Tracking Plan (PostHog)

Single source of truth for every event the app sends to PostHog Cloud EU through the
`BaladyAnalytics` facade (`mapness/lib/features/balady_analytics/`).
An event not listed here does not get added to code; an event added to code is added
here in the same PR.

## North Star

**Weekly unique users who performed a core action:** `search_result_selected`
OR `route_built` OR `navigation_started` — "found a place, previewed a route, or drove".
`route_built` is included deliberately: a noticeable share of users build a route as a
reference (check time/distance) without starting guidance — that is successful usage too.

## Principles

- **Event names are immutable.** PostHog cannot rename events retroactively — a name in
  this file is fixed forever. Convention: `object_action`, snake_case, English
  (`navigation_started`, not `NavStart`).
- **Properties** — snake_case, JSON primitives. Numeric metrics (duration, distance) are
  numbers, not strings: Trends computes avg/median/p90 only over numeric properties.
  No `$` prefix (reserved by PostHog).
- **Fewer is better.** Every event is billed and counts toward quota. An event is added
  when there is a question it answers — never "just in case".
- **Identity:** users are anonymous by default — PostHog keeps a stable per-install
  distinct_id, which is sufficient for DAU/MAU/retention/funnels/cohorts.
  `identify(backendUserId)` only after a real SSO login, `reset()` on logout — and
  **only** on explicit logout: `reset()` mints a fresh anonymous distinct_id, so calling
  it on cold start (e.g. `identify(null)` when no session is restored) counts every app
  launch as a new user. On login PostHog merges the current anonymous person into the
  identified one, so pre-login events of that install follow the user; anonymous ids
  minted by earlier resets stay behind as separate persons.
  Never `identify()` with a device ID: same numbers at 4x the price.
- **Session properties on every event** (attached by the facade, not per call site):
  - `$screen_name` — the current route, updated by the navigation observers even while
    the `$screen` event stream is off (Phase 1.5). Deliberate use of PostHog's reserved
    name: it fills the "URL / Screen" column in Activity and gives any event a
    per-screen filter/breakdown at zero extra event volume.
  - `is_authenticated` — `true` after `identify()` with a real user, `false` after
    logout and by default at startup (may briefly read `false` for a logged-in user
    until session restore runs; person-level `$is_identified` is the authoritative
    logged-in signal for user counts).
- **PII:** search text is sent as typed, only in canonical form — lowercase, trimmed,
  collapsed whitespace, capped at 100 chars. That is not distortion but a prerequisite
  for an honest tag cloud: otherwise "Mecca", "mecca " and "MECCA" count as three
  different queries. Exact user/route coordinates are never sent; city/district
  granularity is enough.

## What PostHog provides with zero events (do not reinvent)

- **Time-of-day distribution** — every event has a timestamp; Trends supports hourly
  granularity and hour-of-day breakdown, retroactively, for any event.
- **OS and devices** — `$os`, `$os_version`, `$device_type`, model are sent by the SDK
  automatically; distribution is a one-click breakdown.
- **User geography** — GeoIP country/city are attached automatically (by IP; for
  navigation our `origin_city`/`destination_city` from the route are more accurate).
- **Periods, DAU/MAU for any metric** — total/unique toggle + date range on any insight.

## What PostHog does not do (and what we do instead)

- **Crashes, ANR, performance, APM** — stay in **Sentry**. PostHog Error Tracking
  receives our `$exception` events (handled-exception counters, grouping) but does not
  replace native stack symbolication or resource monitoring. No duplication.
- **No autocapture for Flutter** — "every button for free" is impossible; taps are
  tracked only via deliberate events (`feature_used` and feature-specific ones).
- **No out-of-the-box screen time for mobile** — approximated from the `$screen`
  sequence with a HogQL insight (Phase 1.5); precise per-screen timing events only for
  a few key screens if the approximation is not enough.

## Automatic events (no code)

| Event | Source | Purpose |
|---|---|---|
| `Application Opened` / `Application Backgrounded` | posthog_flutter lifecycle | Base activity signal: DAU/MAU, stickiness, retention |
| `$exception` | SDK autocapture + `BaladyAnalytics.error()` | Crash reporting — see below |

### Crash reporting

Requested by stakeholders because the team has no working access to Elastic or Sentry.
Duplicating existing tooling was accepted deliberately: this channel is one we own.
It is not theoretical duplication today — `SentryFlutter.init` is commented out in
`lib/main_prod.dart`, `main_stg.dart` and `main_pre.dart`, so `Sentry.captureException`
in `LogsViewModel` is a no-op on those flavors, and UXCam's crash handler reports into
an account nobody can open. Before this, prod crashes reached no one.

Captured automatically by the SDK (`errorTrackingConfig` in `PosthogBaladyAnalyticsSink`):
Flutter framework errors, `PlatformDispatcher` errors, isolate errors, and native
crashes (persisted to disk, delivered on next launch). Autocapture **chains** the
existing `FlutterError.onError` instead of replacing it, so the legacy log pipeline is
untouched. Zone errors are reported explicitly from `unhandledExceptionBaladyLogs` —
`runZonedGuarded` cannot be hooked by the SDK.

Not covered: Android native C/C++ (NDK) crashes — a crash inside the map SDK's native
layer will not appear. Apple native capture is upstream-experimental. Release stack
traces stay unreadable until CI uploads dSYMs (iOS) and R8 mappings (Android).

Alerting (configured in the PostHog UI, no code): occurrences group into an **issue**,
and an issue carries its own user/session counts — that is the aggregation asked for
("send once, but say it affects 100 devices"). Alerts fire on issue created/reopened,
or on a spike above an issue's historical baseline; destinations are Slack, Discord,
Teams and HTTP webhooks. Volume-based thresholds are also available as trend alerts on
an insight over `$exception` (delivered by email).

## Phase 1 — core

Answers: how many people use the app; what they search for and whether they find it;
how they use the navigator and free roam; stories reach; service open rate.

### Search

| Event | Properties | When |
|---|---|---|
| `search_performed` | `query` (canonical), `source` (`map`, `landing`, `navi`), `results_count` | Query executed (after debounce, not per keystroke) |
| `search_result_selected` | `query`, `rank` (position in results, 1-based), `result_type` (`poi`, `address`, `category`, `history`) | Result tapped |

Metrics: **top queries** (breakdown by `query`; word cloud — external visualization over
the API), **search success rate** = selected / performed, **zero-results rate** =
performed(results_count=0) / performed.

### Navigator

| Event | Properties | When |
|---|---|---|
| `route_built` | `transport_mode` (`car`, `pedestrian`, `transit`, …), `origin_city`, `destination_city`, `district` (destination district — only from `address.drilldown` of the already-loaded search/POI object, see `make_address.dart`; null for an arbitrary map point, no reverse-geocode calls for analytics), `distance_m`, `distance_bucket` (`<1km`, `1-5km`, `5-20km`, `>20km`), `alternatives_count` | Route built and shown |
| `route_failed` | `transport_mode`, `reason` | Route build failed |
| `navigation_started` | `transport_mode`, `distance_bucket`, `head_unit` (`none`, `carplay`, `android_auto`) | User started guidance |
| `navigation_completed` | `transport_mode`, `end_reason` (`arrived` — auto-detected / `manual_stop` — user ended near destination), `duration_sec`, `distance_m`, `eta_error_sec` (actual − predicted), `reroutes_count` | Trip finished. Manual stop counts as completed when progress ≥ 90% OR remaining ≤ min(200 m, 20% of route length) — the relative threshold covers short trips |
| `navigation_cancelled` | `transport_mode`, `progress_pct`, `duration_sec` | Guidance abandoned before the completed threshold |
| `free_roam_started` | `source` (`dashboard`, `autostart`, `carplay`) | `FreeRoamRoute` pushed — free roam entered |
| `carplay_connected` / `android_auto_connected` | — | Head unit connected |

Metrics: funnel `search → route_built → navigation_started → navigation_completed`;
started/completed route counts (split by `end_reason`); **avg/median trip duration and
length** (`duration_sec`, `distance_m`); time-of-day and cities of navigation usage;
**navigator MAU**; ETA quality (`eta_error_sec`).
**"Free roam only" cohort**: has `free_roam_started`, no `navigation_started` — built in
the UI, needs no events. Free roam duration is Phase 2 (`duration_sec` on
`FreeRoamRoute` page dispose; boundaries are explicit, no timers needed).

### Stories (stakeholder showcase)

| Event | Properties | When |
|---|---|---|
| `story_viewed` | `story_id`, `completed` (bool) | Story opened; `completed` on watch-through |
| `story_cta_tapped` | `story_id`, `target` (service/screen the CTA leads to) | CTA tapped |

Metrics: reach (unique users), completion rate, funnel
`story_viewed → story_cta_tapped → service_opened(source=story)`.
**Limitation:** in-mini-app purchase conversion is invisible to us — requires events
from the mini-app team or their backend export. Communicated to stakeholders.

### Services / mini-apps

| Event | Properties | When |
|---|---|---|
| `service_opened` | `service_id`, `source` (`services_tab`, `story`, `search`, `quick_action`) | Mini-app opened |
| `service_closed` | `service_id`, `duration_sec` | Webview closed |

Internal mini-app events are not forwarded (JS bridge forwarding — silenced).

### Session properties (attached to every event)

`$app_version`, `$os` etc. are sent by the SDK. Via `setSessionProperty` we add:
`environment` (flavor — duplicates the per-project split, saves us if a key is misused),
`app_language`.

## Phase 1.5 — screen tracking (deferred: ~80% of event volume)

| Event | Source |
|---|---|
| `$screen` | `BaladyAnalyticsNavigatorObserver` / auto_route observer / bottom sheet dialogs |

Deferred deliberately: `$screen` dominates quota (~80%) while the dependent
"time on screen" metric (HogQL over the `$screen` sequence) is not a current priority.
The facade's `screen()` currently drops events (documented no-op); re-enabling is a
one-line change, ideally with a screen allowlist to control volume.

**Volume estimate at ~300k MAU:** ~50k DAU × ~1.5 sessions × ~10 screens ≈ 20–25M
`$screen`/mo; with lifecycle and product events ≈ **25–30M events/mo**, almost all
anonymous (cheap tier) — roughly $800–1500/mo per the PostHog calculator. Without
`$screen` (Phase 1 scope) the total is ~3–5M events/mo. Set the project billing limit
from these figures, refine after the first month.

## Phase 2 — engagement and transit (transit deadline: before Ramadan 2027, ahead of Hajj)

| Event | Properties |
|---|---|
| `poi_card_opened` | `source` (`map_tap`, `search`, `story`, `favourites`), `category` |
| `poi_action` | `action` (`route`, `call`, `share`, `favourite`, `website`), `category` |
| `favourite_added` | `type` (`home`, `work`, `other`) |
| `layer_toggled` | `layer` (`weather`, `metro`, `lifestyle`, …), `enabled` |
| `feature_used` | `feature` (`radio`, `kiblah`, `weather`, `parking`, …), `duration_sec` (for long-running: radio listening time etc.) |
| `free_roam_ended` | `duration_sec` (on `FreeRoamRoute` page dispose) |
| `transit_route_viewed` | `transit_type` (`metro`, `bus`, `shuttle`), `city` |
| `bus_departures_viewed` | `city` |

Metrics: pin-to-action rate, share of searches ending in a route, long-tail feature
usage, transit readiness for the Hajj season.

## Phase 3 — candidates (added when a question appears)

`share_eta_used`, `feedback_submitted`, quick actions, precise time on key screens
(screen-leave event), mini-app event allowlist (if purchase conversion is ever needed).

## Dashboards (built manually in the prod project)

1. **Activity** — DAU/WAU/MAU, Stickiness, Retention, Lifecycle; breakdown by OS,
   device, city (GeoIP); hourly activity distribution.
2. **Search** — volume, success rate, zero-results rate, top-queries table
   (+ tag cloud via external visualization).
3. **Navigator** — funnel, started/completed (breakdown by `end_reason`), completion
   rate, navigator MAU, avg/median duration and distance, time-of-day and cities,
   `eta_error_sec`, "free roam only" cohort.
4. **Stories and services** — reach, completion, funnel story → CTA → service_opened,
   service opens, time inside mini-apps.
5. **App sections** (Phase 1.5) — HogQL insight: approximate time on screen from the
   `$screen` sequence.

## UXCam-legacy cleanup

- Blind helpers `logEventDefault` / `logEventWithData` / `sendEvent` in
  `lib/app/core/utils/common_functions.dart`: stop forwarding to PostHog. Other
  destinations of those helpers (Firebase Analytics) keep working — only the
  BaladyAnalytics/PostHog mirror is removed; events from that file do not migrate.
- Mini-app event auto-forwarding in `lib/super_app_js_bridge/js_bridge_listener.dart` —
  silenced (`service_opened`/`service_closed` are sent from the Flutter side).
- `AppAnalyticsRepository` mirror into BaladyAnalytics — removed; navigation event
  semantics migrated here (Phase 1). Legacy urbi/BytePlus streams keep flowing through
  their own channel until their own migration phase ends.
