# BaladyAnalytics — собственная аналитика Balady+

Фасад для сбора продуктовых и технических событий в **наш** self-hosted
бэкенд (целевой стек — PostHog self-hosted, см. `docs/analytics/DEVOPS_BRIEF.md`).
Появился при выпиливании мёртвого UXCam: все ~200 бывших UXCam-вызовов
(теги экранов, кастомные события, исключения, identity) теперь стекаются сюда.

## Как пользоваться

```dart
import 'package:mapness/features/balady_analytics/balady_analytics.dart';

BaladyAnalytics.instance.track('poi_share', properties: {'poi_id': id});
BaladyAnalytics.instance.screen('/map/search');
BaladyAnalytics.instance.error(e, stack);
BaladyAnalytics.instance.identify(userId: sub, traits: {...}); // null = logout
```

В `mapness` продолжайте использовать существующую обёртку `Metrics`
(`shared/lib/urbi_metrics.dart`) — она уже пишет в фасад. В host-оболочке —
`CommonFunctions.sendAnalyticsEvent[WithProperties]`.

## Рубильник (режимы)

`BALADY_ANALYTICS_MODE` в `.env.<flavor>` (compile-time):

| Режим | Legacy-потоки (Insider, BytePlus, Mixpanel, Urbi, Adjust, BSS) | Наш пайплайн |
|---|---|---|
| `legacy` | работают как раньше | события фасада дропаются |
| `dual` | работают как раньше | события фасада уходят к нам |
| `ours` | пока работают (не сведены в фасад) | события фасада уходят к нам |

Сейчас `prod` = `legacy`, остальные флейворы = `dual`.

## Транспорт

Пока `LoggingBaladyAnalyticsSink`: в debug печатает события в лог
(`[BaladyAnalytics] ...`), в release — no-op, **ничего никуда не отправляется**.
Боевой транспорт (PostHog `capture` batch) подключается заменой синка в
`BaladyAnalytics.configure(...)` — call sites не трогаются.

## План миграции legacy-потоков (следующие шаги)

1. ~~UXCam~~ — удалён, события ретаргечены в фасад (этот PR).
2. Mixpanel (тайминги) → `track` с `duration_ms`.
3. Urbi Analytics + AdvancedMetrics → фасад (наш же бэкенд, сменить endpoint).
4. Insider/BytePlus продуктовые события → фасад дополнительным приёмником
   через существующий `appAnalyticsProvider` (реализовать `AppAnalyticsRepository`).
5. BSS **остаётся как есть** — важный серверный поток для поиска/карты;
   в перспективе фасад может дублировать его события в наш бэкенд.
6. Adjust (атрибуция) и Sentry (краши) — вне скоупа фасада.
