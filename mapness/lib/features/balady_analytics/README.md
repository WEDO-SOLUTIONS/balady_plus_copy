# BaladyAnalytics — Balady+ first-party analytics

A facade for collecting product and technical events into **our own** self-hosted
backend (target stack — PostHog self-hosted, see `docs/analytics/DEVOPS_BRIEF.md`).
It was introduced while ripping out the dead UXCam: all ~200 former UXCam calls
(screen tags, custom events, exceptions, identity) now flow here.

## Usage

```dart
import 'package:mapness/features/balady_analytics/balady_analytics.dart';

BaladyAnalytics.instance.track('poi_share', properties: {'poi_id': id});
BaladyAnalytics.instance.screen('/map/search');
BaladyAnalytics.instance.error(e, stack);
BaladyAnalytics.instance.identify(userId: sub, traits: {...}); // null = logout
```

Inside `mapness`, keep using the existing `Metrics` wrapper
(`shared/lib/urbi_metrics.dart`) — it already writes to the facade. In the host
shell, use `CommonFunctions.sendAnalyticsEvent[WithProperties]`.

## Kill switch (modes)

`BALADY_ANALYTICS_MODE` in `.env.<flavor>` (compile-time):

| Mode | Legacy streams (Insider, BytePlus, Mixpanel, Urbi, Adjust, BSS) | Our pipeline |
|---|---|---|
| `legacy` | work as before | facade events are dropped |
| `dual` | work as before | facade events are sent to us |
| `ours` | still work for now (not yet folded into the facade) | facade events are sent to us |

Currently `prod` = `legacy`, all other flavors = `dual`.

## Transport

For now it is `LoggingBaladyAnalyticsSink`: in debug it prints events to the log
(`[BaladyAnalytics] ...`), in release it is a no-op — **nothing is sent anywhere**.
The production transport (PostHog `capture` batch) is wired up by swapping the sink in
`BaladyAnalytics.configure(...)` — call sites remain untouched.

## Legacy stream migration plan (next steps)

1. ~~UXCam~~ — removed, events retargeted to the facade (this PR).
2. Mixpanel (timings) → `track` with `duration_ms`.
3. Urbi Analytics + AdvancedMetrics → facade (same backend of ours, just switch the endpoint).
4. Insider/BytePlus product events → facade via an additional receiver
   through the existing `appAnalyticsProvider` (implement `AppAnalyticsRepository`).
5. BSS **stays as is** — an important server-side stream for search/map;
   eventually the facade may mirror its events into our backend.
6. Adjust (attribution) and Sentry (crashes) — out of scope for the facade.
