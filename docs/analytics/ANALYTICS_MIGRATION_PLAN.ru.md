> [English](ANALYTICS_MIGRATION_PLAN.md) · [Русский](ANALYTICS_MIGRATION_PLAN.ru.md) · [العربية](ANALYTICS_MIGRATION_PLAN.ar.md)

# План миграции аналитики Balady+ под фасад `BaladyAnalytics`

> Статус: живой документ. Ветка `feat/BALADY-0000/posthog-infra-experiment` реализует
> фазу 1 (PostHog-эксперимент + первый легаси-поток под зонтиком).
> Карта легаси-систем — `ANALYTICS_REPORT.md`; серверная часть — `infra/analytics/README.md`;
> инженерный гайд фасада — `mapness/lib/features/balady_analytics/README.md`.

## Целевая картина

Один интерфейс на всё приложение — `BaladyAnalytics.instance` — и именованные каналы:

```
feature code ──► BaladyAnalytics.track(name, properties, channels: {...})
                        │
        ┌───────────────┼───────────────────────────────┐
        ▼               ▼                               ▼
   ours (PostHog)   urbi (balady-metrics.urbi.ae)   insider / byteplus / mixpanel / bss
   гейтится           BaladyAnalyticsChannel.urbi     будущие каналы (адаптеры
   BALADY_ANALYTICS_MODE  (уже реализован)            поверх существующих SDK)
```

Принципы:

- **Call sites говорят только с фасадом.** Прямые вызовы легаси-SDK из фич — техдолг,
  который сводится к нулю по мере фаз ниже.
- **Канал = адаптер `BaladyAnalyticsSink`** поверх существующего SDK/клиента.
  Добавление канала не трогает call sites; удаление легаси-системы = удаление адаптера.
- **Режим `BALADY_ANALYTICS_MODE`** (`legacy` | `dual` | `ours`) гейтит только канал `ours`.
  Легаси-каналы — боевые потоки, они текут всегда, пока их фаза не закрыта.
- **Выпиливание легаси = отключение канала**, а не рефакторинг сотен call sites.

## Инвентарь потоков и фазы

| Фаза | Поток | Что несёт | Где вызывается сегодня | Что делать |
|---|---|---|---|---|
| 1 ✅ | **Urbi Analytics / AdvancedMetrics** | search-метрики (`Search::*`, `search_duration`), `mapInteraction`, screen views | `urbiAnalyticsProvider` (~50 мест в mapness) | Канал `urbi` + `UrbiBaladyAnalyticsSink` готовы; через фасад идут `trackWithPrint` и все `stopSearchResponse`. Остальные прямые `.track(...)`-вызовы переводить на `BaladyAnalytics.instance.track(..., channels: {ours, urbi})` по мере касания кода. `screen()` НЕ зеркалить — `RoutesObserver` уже шлёт в обе системы. |
| 2 | **Mixpanel** (тайминги `timeEvent`/`track`) | длительности операций поиска | `mapness/lib/entry_point.dart` (init), `search.dart` и др. (`mixpanel?.timeEvent`) | Замерять `Stopwatch`-ом и слать `track('...', properties: {'duration_ms': ...})` в `ours`; канал `mixpanel` заводить только если потребуется сохранить сам поток. Затем удалить SDK. |
| 3 | **Insider + BytePlus (RangersAppLog)** | продуктовые события host-оболочки | `CommonFunctions.sendAnalyticsEvent[WithProperties]` (host shell), `appAnalyticsProvider` | Реализовать `AppAnalyticsRepository`-адаптеры как каналы `insider`, `byteplus`; `CommonFunctions.sendAnalyticsEvent*` переключить на фасад с `channels: {ours, insider, byteplus}`. Call sites не трогаются — они уже ходят через `CommonFunctions`. |
| 4 | **BSS** | серверный поток поиска/карты (важен для бэкенда) | `BssService.instance` | Поток остаётся жить независимо. Фасад может дублировать его события в `ours` каналом `bss`-адаптера; сам BSS не отключается. |
| 5 | Финал | — | — | prod переводится в `dual`, затем `ours`; легаси-каналы отключаются по одному (удаление адаптера + SDK). |
| — | **Adjust** (атрибуция), **Sentry** (краши) | — | — | Вне скоупа фасада, не трогаем. |

## Как переносится один поток (чек-лист)

1. Написать адаптер `XxxBaladyAnalyticsSink implements BaladyAnalyticsSink` поверх существующего SDK.
2. Добавить значение в `BaladyAnalyticsChannel`, зарегистрировать адаптер в `entry_point.dart`
   (`registerChannel`) рядом с `configure()`.
3. Точки входа потока (обёртка/сервис, не каждый call site) переключить на
   `BaladyAnalytics.instance.track(..., channels: {ours, xxx})`.
4. Проверить в PostHog (событие пришло в `ours`) и в легаси-системе (поток не изменился).
5. Когда легаси-система больше не нужна: убрать канал из `channels`-наборов, удалить адаптер и SDK.

## Известные попутные фиксы (сделаны в фазе 1)

- `stopSearchResponse` передавал текст запроса и тип поиска в перепутанные поля
  (`search_query_type` содержал текст юзера) — исправлено в `urbi_metrics_utils.dart`.
- События поиска вообще не попадали в фасад (шли только в Urbi) — теперь зеркалятся.

## PII-правила для канала `ours`

- `distinct_id` — только хэш от SSO `sub`, национальный ID в открытую не использовать.
- Session replay выключен до отдельного PII-ревью.
- `APIError` несёт `Headers`/`QueryString` — при переносе на фасад обрезать/дени-листить
  (могут содержать токены).
