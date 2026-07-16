> [English](ANALYTICS_MIGRATION_PLAN.md) · [Русский](ANALYTICS_MIGRATION_PLAN.ru.md) · [العربية](ANALYTICS_MIGRATION_PLAN.ar.md)

# Balady+ analytics migration plan onto the `BaladyAnalytics` facade

> Status: living document. The branch `feat/BALADY-0000/posthog-infra-experiment` implements
> phase 1 (the PostHog experiment + the first legacy stream under the umbrella).
> Legacy-system map — `ANALYTICS_REPORT.md`; server side — `infra/analytics/README.md`;
> facade engineering guide — `mapness/lib/features/balady_analytics/README.md`.

## Target picture

One interface for the whole app — `BaladyAnalytics.instance` — plus named channels:

```
feature code ──► BaladyAnalytics.track(name, properties, channels: {...})
                        │
        ┌───────────────┼───────────────────────────────┐
        ▼               ▼                               ▼
   ours (PostHog)   urbi (balady-metrics.urbi.ae)   insider / byteplus / mixpanel / bss
   gated by           BaladyAnalyticsChannel.urbi     future channels (adapters
   BALADY_ANALYTICS_MODE  (already implemented)       on top of existing SDKs)
```

Principles:

- **Call sites talk only to the facade.** Direct legacy-SDK calls from features are tech debt
  that shrinks to zero over the phases below.
- **A channel = a `BaladyAnalyticsSink` adapter** on top of an existing SDK/client.
  Adding a channel never touches call sites; removing a legacy system = removing its adapter.
- **The `BALADY_ANALYTICS_MODE` mode** (`legacy` | `dual` | `ours`) gates only the `ours` channel.
  Legacy channels are production streams — they keep flowing until their phase is closed.
- **Retiring legacy = switching a channel off**, not refactoring hundreds of call sites.

## Stream inventory and phases

| Phase | Stream | What it carries | Where it is called today | What to do |
|---|---|---|---|---|
| 1 ✅ | **Urbi Analytics / AdvancedMetrics** | search metrics (`Search::*`, `search_duration`), `mapInteraction`, screen views | `urbiAnalyticsProvider` (~50 sites in mapness) | The `urbi` channel + `UrbiBaladyAnalyticsSink` are ready; `trackWithPrint` and all `stopSearchResponse` calls already go through the facade. Migrate the remaining direct `.track(...)` calls to `BaladyAnalytics.instance.track(..., channels: {ours, urbi})` as the code is touched. Do NOT mirror `screen()` — `RoutesObserver` already sends to both systems. |
| 2 | **Mixpanel** (`timeEvent`/`track` timings) | search operation durations | `mapness/lib/entry_point.dart` (init), `search.dart` and others (`mixpanel?.timeEvent`) | Measure with a `Stopwatch` and send `track('...', properties: {'duration_ms': ...})` to `ours`; add a `mixpanel` channel only if the stream itself must be preserved. Then remove the SDK. |
| 3 | **Insider + BytePlus (RangersAppLog)** | product events of the host shell | `CommonFunctions.sendAnalyticsEvent[WithProperties]` (host shell), `appAnalyticsProvider` | Implement `AppAnalyticsRepository` adapters as the `insider` and `byteplus` channels; switch `CommonFunctions.sendAnalyticsEvent*` to the facade with `channels: {ours, insider, byteplus}`. Call sites stay untouched — they already go through `CommonFunctions`. |
| 4 | **BSS** | server-side search/map stream (important for the backend) | `BssService.instance` | The stream keeps living independently. The facade may duplicate its events into `ours` via a `bss` adapter channel; BSS itself is not switched off. |
| 5 | Final | — | — | prod moves to `dual`, then `ours`; legacy channels are switched off one by one (adapter + SDK removal). |
| — | **Adjust** (attribution), **Sentry** (crashes) | — | — | Out of the facade's scope, leave untouched. |

## How a single stream is migrated (checklist)

1. Write an adapter `XxxBaladyAnalyticsSink implements BaladyAnalyticsSink` on top of the existing SDK.
2. Add a value to `BaladyAnalyticsChannel`, register the adapter in `entry_point.dart`
   (`registerChannel`) next to `configure()`.
3. Switch the stream's entry points (the wrapper/service, not every call site) to
   `BaladyAnalytics.instance.track(..., channels: {ours, xxx})`.
4. Verify in PostHog (the event arrived in `ours`) and in the legacy system (the stream is unchanged).
5. Once the legacy system is no longer needed: remove the channel from the `channels` sets, delete the adapter and the SDK.

## Known incidental fixes (done in phase 1)

- `stopSearchResponse` was passing the query text and the search type into swapped fields
  (`search_query_type` contained the user's text) — fixed in `urbi_metrics_utils.dart`.
- Search events were not reaching the facade at all (they went only to Urbi) — now mirrored.

## PII rules for the `ours` channel

- `distinct_id` — only a hash of the SSO `sub`; never use the national ID in the clear.
- Session replay stays off until a dedicated PII review.
- `APIError` carries `Headers`/`QueryString` — when moving it onto the facade, trim/deny-list them
  (they may contain tokens).
