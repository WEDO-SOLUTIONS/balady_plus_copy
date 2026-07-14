# Аналитика Balady+ — что, где, зачем

> **UPDATE 2026-07-14:** поток B (UXCam) полностью удалён из кода; все его
> события переведены на внутренний фасад `BaladyAnalytics`
> (`mapness/lib/features/balady_analytics/`, см. README там же и
> `docs/analytics/DEVOPS_BRIEF.md`). Разделы про UXCam ниже сохранены как
> историческая карта событий.

> Отчёт по всей системе аналитики/телеметрии Flutter-супераппа **Balady+**.
> Составлен по коду на ветке `development` (модуль `mapness/` + корневая
> host-оболочка `lib/`). Точкой входа была фича
> `mapness/lib/features/app_analytics/`, но, как и предполагалось, аналитика
> в приложении **разделена на несколько независимых потоков** — ниже полная карта.

---

## 0. TL;DR — карта потоков

В приложении сосуществует **8 систем аналитики/телеметрии**, сгруппированных в
несколько потоков. Они _не_ объединены под одним фасадом: только два из них
(Insider + BytePlus) ходят через общий провайдер `appAnalyticsProvider`, остальные
вызываются напрямую из фич.

| # | Поток | Пакет / SDK | Назначение (зачем) | Точка входа | ≈ мест вызова |
|---|-------|-------------|--------------------|-------------|----------------|
| A1 | **Insider** | `flutter_insider` | CRM / push / геофенсинг + базовые продуктовые события | `appAnalyticsProvider` (композит) | 38 (общий фасад) |
| A2 | **BytePlus / DataFinder** | `rangers_applog_flutter_plugin` | Поведенческая аналитика поиска (ByteDance), 9 search-событий + базовые | `appAnalyticsProvider` (композит) | 38 (общий фасад) + 20 DataFinder |
| B | **UXCam** | `flutter_uxcam` | Запись сессий, теги экранов, кастомные события, репорт исключений | `Metrics` (`urbi_metrics.dart`) + `routes_observer` | ≈145 (`Metrics.*`) + 13 |
| C | **Mixpanel** | `mixpanel_flutter` | Тайминг/латентность операций (сеть, поиск, авторизация) | глобальный `mixpanel?` | ≈44 |
| D | **Urbi Analytics** | `urbi_analytics` (`balady-metrics.urbi.ae`) | Собственный бэкенд метрик Urbi: экраны + кастомные события + приёмник AdvancedMetrics | `urbiAnalyticsProvider` | ≈48 |
| E | **AdvancedMetrics** | `urbi_metrics_utils.dart` (singleton) | Тех-телеметрия: старт, батарея, потеря GPS, время ответа поиска, расчёт маршрута | `AdvancedMetrics.instance` → шлёт через (D) | ≈19 |
| F | **Adjust** | `adjust_sdk` (`advert_metrics.dart`) | Маркетинг/атрибуция рекламных конверсий | `advertMetricsProvider` | ≈31 |
| G | **BSS** | собственный `BssService` → бэкенд Balady | Серверный поток UI-событий (POI, поиск, deeplink), батч раз в 5 сек | `BssService.instance` | ≈43 (27 файлов) |
| H | **Host-оболочка** | `firebase_analytics`, `sentry_flutter`/`sentry_dio`, `firebase_messaging`, `firebase_remote_config` | Firebase Analytics + Sentry (краши/ошибки) на уровне корневого `lib/` | корневой `lib/main.dart`, `lib/app/...` | — |

> **Firebase Crashlytics** объявлен как dependency override (`pubspec.yaml`), но
> в коде **не инициализируется и не используется** — «спящая» зависимость.
> Систем вроде Amplitude, Segment, AppsFlyer, Countly, PostHog, AppMetrica,
> Braze, CleverTap, OneSignal, HMS Analytics в репозитории **нет**.

**Как это делится на потоки концептуально:**

- **Продуктовая аналитика (что делает пользователь):** Insider + BytePlus (через
  `appAnalyticsProvider`), BSS, Urbi Analytics.
- **Поведение/поиск (детально):** BytePlus/DataFinder (9 событий), BSS.
- **Тех-телеметрия/производительность:** AdvancedMetrics (+ Urbi Analytics как sink),
  Mixpanel (тайминги), UXCam (запись сессий).
- **Маркетинг/атрибуция:** Adjust.
- **Краши/ошибки:** Sentry (+ UXCam `reportExceptionEvent`).

---

## 1. Ядро — фича `app_analytics` (то, на что указали)

Расположение: `mapness/lib/features/app_analytics/`.

Это **единственный поток с общим фасадом**. Любой вызов идёт через один
Riverpod-провайдер, который «разветвляет» событие по бэкендам:

```
ref.read(appAnalyticsProvider)              ← вызывает фича-код
        │
        ▼
_CompositeAnalytics  (app_analytics.dart)   ← роутер/сплиттер
        ├── AppAnalyticsInsiderImpl         ← Insider  (только базовые события)
        └── AppAnalyticsBytePlusImpl        ← BytePlus (базовые + 9 DataFinder)
```

### 1.1 Архитектура (два интерфейса-способности)

Файл `app_analytics_repository.dart` объявляет **два** интерфейса:

| Интерфейс | Реализуют | События |
|-----------|-----------|---------|
| `AppAnalyticsRepository` | Insider **и** BytePlus | базовые (навигация, онбординг, …) |
| `DataFinderAnalyticsRepository` | **только** BytePlus | 9 search-событий DataFinder |

`AppAnalyticsApi` объединяет оба. Композит для DataFinder-событий делает
`whereType<DataFinderAnalyticsRepository>()` — то есть эти 9 событий получает
**только** BytePlus, Insider их не видит. Чтобы добавить новый приёмник
(например, BSS) без правок вызывающего кода — достаточно, чтобы его impl тоже
реализовал `DataFinderAnalyticsRepository`.

**Ключевые файлы:**

| Файл | Назначение |
|------|-----------|
| `app_analytics_repository.dart` | Оба интерфейса — сигнатуры всех событий |
| `app_analytics.dart` | Провайдер `AppAnalytics` + `_CompositeAnalytics` (fan-out) + логика `setUserInfo` |
| `data/app_analytics_insider_impl.dart` | Impl Insider (`tagEvent().build()`) |
| `data/app_analytics_byteplus_impl.dart` | Impl BytePlus (`onEventV3`) + dry-run на симуляторе |
| `models/datafinder_models.dart` | Модели payload, енамы, генератор UUID, `DataFinderOrigin.resolve` (8 значений `event_source`) |
| `models/datafinder_mappers.dart` | `DirectoryObjectMessage`/`SuggestMessage` → `DataFinderPoi` |
| `datafinder_source_tracker.dart` | Хранит «источник» текущего пути (Map/Explore/Routes/FreeRoam) |
| `README.md` | Подробный инженерный гайд (первоисточник по DataFinder) |

### 1.2 Поток A1 — Insider (`flutter_insider`)

- **Зачем:** платформа вовлечения — push-уведомления, deeplinks, геофенсинг,
  плюс приём базовых продуктовых событий.
- **Инициализация:** `entry_point.dart` → `initInsider()` (стр. 811-845):
  `FlutterInsider.Instance.init('baladyapp', 'group.movingViolations', callback)`,
  затем `setActiveForegroundPushView()` и `registerWithQuietPermission(false)`.
- **Геофенс после согласия:** `enableInsiderGeofenceAfterConsent()`
  (`entry_point.dart:1483`) — включает сбор локации и трекинг геозон.
- **Идентификация:** `setUserInfo` → `user.login(identifiers)` с email/локалью/
  кастом-атрибутами (device_id, device_os, app_version).
- **Получает только базовые события** (см. каталог §1.4); DataFinder-события — нет.
- **iOS:** поды `InsiderMobile`, `InsiderHybrid`, `InsiderMobileAdvancedNotification`;
  URL-схемы `insiderbaladyapp` / `insiderbaladyappuat`.
  **Android:** maven `mobilesdk.useinsider.com/android`.

### 1.3 Поток A2 — BytePlus / DataFinder (`rangers_applog_flutter_plugin`)

- **Зачем:** поведенческая аналитика ByteDance (проект **DataFinder**). Основная
  цель второй фазы — детально трекать поиск/POI-поведение по спецификации
  «Balady User Behavior Tracking Metrics — BRD V0.1».
- **Инициализация:** `entry_point.dart` → `_initBytePlus(envType)` (стр. 1453),
  вызывается из `setupMapness()`:
  ```dart
  RangersApplogFlutterPlugin.initRangersAppLog(
    appId,        // из RemoteConfig / .env.<flavor>
    channel,      // BYTEPLUS_CHANNEL
    true,         // enableAb
    false,        // enableEncrypt
    !isProduction,// enableLog (подробно на stg/dev, тихо на prod)
    'https://balady.finder-snssdk.bytepluses.com',
  );
  ```
  Есть флаг-гард `_bytePlusInitialized`, чтобы не инициализировать SDK дважды
  (движок может переприсоединиться). Если `BYTEPLUS_APP_ID` пуст — init скипается.
- **App ID по флейворам** (`.env.<flavor>` → `BYTEPLUS_APP_ID`):
  `prod` → `10000002` (проект «Balady»); `stg`/`pre`/`dev` → `10000000`
  («Balady Staging Test»). Так пре-прод и ниже не засоряют прод-аналитику.
- **Все события:** через `RangersApplogFlutterPlugin.onEventV3(name, params)`.
- **Идентификация:** `setUserUniqueId(userId)` — `userId = sub` (SSO subject, единый
  id для phone-OTP и national-id логинов), fallback `idNo`; `null` = **logout**
  (важно: вызов не защищён null-check, иначе прошлый юзер «останется залогинен»).
- **Автотрек экранов ОТКЛЮЧЁН осознанно:** `RangersApplogNavigationObserver`
  **не** регистрируется (`entry_point.dart:126-132`) — его обход дерева элементов
  ломает вложенные tab-навигаторы `auto_route` (красный экран). Все DataFinder-
  события шлются явно из flow поиска/POI.
- **iOS:** под `RangersAppLog 6.17.7-iOS26-xc-rc2` (единый XCFramework — и симулятор,
  и девайс).

**Dry-run на симуляторе (важно):** BytePlus показывает данные только с реальных
устройств. Поэтому в `app_analytics_byteplus_impl.dart` есть авто-гейт:
- **симулятор/эмулятор** → события **только логируются** (`[DataFinder][DRY-RUN] …`),
  не отправляются;
- **реальное устройство** → отправляются (`[DataFinder] …`).

Детекция — через `device_info_plus` `isPhysicalDevice` (резолвится один раз на
старте; до резолва — dry-run, безопасный дефолт). Ручной оверрайд:
`_forceDryRun = true`.

### 1.4 Каталог базовых событий (Insider + BytePlus) и где вызываются

Все — через `ref.read(appAnalyticsProvider).<метод>()`. Уходят **и в Insider, и в
BytePlus** одновременно. Имена событий у BytePlus в скобках (`onEventV3`).

| Метод фасада | Событие BytePlus | Где вызывается (триггер) |
|--------------|------------------|--------------------------|
| `onboardingFlowStarted` | `onboarding_flow_started` | `guards/onboard_route_guard.dart:17` — вход в онбординг |
| `onboardingFlowSkipped` | `onboarding_flow_skipped` | `stories_fullscreen.dart:93`, `story_frame_widget.dart:333` — пропуск сторис |
| `onboardingFlowCompleted` | `onboarding_stories_completed` | `stories_fullscreen.dart:98,131`, `story_frame_widget.dart:331` — конец сторис |
| `navigationSearch` | `navigation_search` | `navi_search_content.dart:80` — поиск точки назначения |
| `navigationStarted` | `navigation_started` | `routing_info.dart:510` — нажатие «GO» |
| `navigationHalfWay` | `navigation_half_way` | `path_nav_eta.dart:60` — пройдено >50% маршрута |
| `navigationCompleted` | `navigation_completed` | `path_nav_page.dart:662` — прибытие |
| `userMovementDetected` | `user_movement_detected` | ⚠️ **не вызывается** (метод есть, call site 0) |
| `categorySelected` | `category_selected` | `entry_point.dart:1206` (deeplink), `map_quick_filters.dart:95` — выбор быстрого фильтра |
| `serviceSectionVisited` | `service_section_visited` | `bottom_menu_page.dart:98` — вкладка «Сервисы» |
| `quickActionSelected` | `quick_action_used` | `dashboard_actions.dart` (parking/qibla/quran/athkar/free-roam/my-location/snap-send/road-event) + deeplinks в `entry_point.dart` (~10 мест) |
| `appIconQuickActionSelected` | `app_icon_quick_action_used` | `app_icon_quick_action_handler.dart:323` — шорткат с иконки приложения |
| `carPlayConnected` | `carplay_connected` | `car_enable_free_roam.dart:28` — подключение CarPlay/Android Auto |
| `poiContributionUsed` | `contribution_used` | `submit_feedback.dart:78` — отправка контрибуции POI |
| `isNavigationUser` | `is_navigation_user` | `path_nav_page.dart:262` — первое завершение навигации |
| `deviceTypeDetected` | `device_type_detected` | `entry_point.dart:212` — на старте приложения |
| `networkConnectionType` | `network_type_detected` | `entry_point.dart:293,295` — mobile/wifi на старте |
| `transportModeSelected` | `transport_mode_selected` | `routing_info.dart:441` — выбор типа транспорта + GO |
| `setUserInfo` | профиль + `setUserUniqueId` | из `AppAnalytics.build()` — на каждый логин/логаут/смену аккаунта |

> Всего ≈36 мест вызова базовых событий. Самый частый — `quickActionSelected`.

### 1.5 9 событий DataFinder (только BytePlus) и где вызываются

| Событие | Метод фасада | Где вызывается (триггер) |
|---------|--------------|--------------------------|
| `search_box_click` | `searchBoxClick` | `map_search_bar.dart:170`, `routing_search_bar.dart:79` — фокус поля поиска |
| `search_box_input` | `searchBoxInput` | `map_search_bar.dart:271`, `routing_search_bar.dart:125` (Manual); `map_search_history.dart:39`, `navi_search_history.dart:40` (History) |
| `search_button_click` | `searchButtonClick` | `map_search_bar.dart:335`, `routing_search_bar.dart:141` — кнопка поиска на клавиатуре |
| `quick_search_click` | `quickSearchClick` | `search.dart:407` (чипы на лендинге), `map_search_content_v2.dart:280` (чипы в шите) |
| `favorite_add` | `favoriteAdd` | `poi_favorite_dialog.dart:69` — добавление в избранное (Home/Work/List) |
| `suggestion_exposure` | `suggestionExposure` | `search.dart:877` — показ списка подсказок (по элементу!) |
| `suggestion_click` | `suggestionClick` | `search.dart:856` (нотифаер) ← `suggest_item.dart:108` (тап) |
| `search_results_exposure` | `searchResultsExposure` | `search.dart:924` — показ результатов + пагинация (по элементу!) |
| `search_results_click` | `searchResultsClick` | `search.dart:842` (нотифаер) ← `map_search_results.dart:115`, `navi_search_results.dart:114`, `routing_search_results.dart:121` |

**⚠️ Exposure-события — ПО ЭЛЕМЕНТУ, не массивом.** По BRD «10 показанных
элементов → 10 отдельных событий». Цикл живёт в `app_analytics_byteplus_impl.dart`
(дашборд BytePlus не парсит массивы). 20 результатов → 20 событий
`search_results_exposure`, каждое со своим `poi_*` + общим контекстом. Пагинация:
`poi_rank` продолжается сквозь страницы (стр.1 → 1-20, стр.2 → 21-40), `request_id`
и `search_session_id` переиспользуются.

**Значения енамов** (`datafinder_models.dart`):
- `operation_type`: `Manual` · `History`
- `trigger_method`: `Keyboard`
- `favorite_type`: `Home` · `Work` · `Not Specified`
- `search_type`: `Manual` · `Quick search` · `Click suggestion` · `History` · `Search in this area`
- `click_action`: `View POI Details` · `Initiate Navigation` · `Share POI` · `Add to Favorites`
- `event_source` (8): `Map-Main Page` · `Map-Direction-Path Changing` · `Explore-Main Page` · `Explore-Free Roam` · `Explore-Direction` · `Explore-Direction-Path Changing` · `Routes-Main Page` · `Routes-Path Changing`

### 1.6 `event_source` — трекинг источника (8 значений)

Balady — это **один экран-карта с оверлей-контроллерами**, поэтому `event_source`
это **не** маршрут, а **поверхность, с которой начался путь**, скомбинированная с
живым состоянием навигации.

**1) Источник «штампуется»** при входе на поверхность
(`datafinder_source_tracker.dart` → `stampOrigin`):

| Origin | Где штампуется |
|--------|----------------|
| `map` | `map_tap_handler_provider.dart:184` — тап по POI на карте |
| `explore` | `bottom_menu_page.dart:68` (вкладка Explore) + `map_search_sheet.dart:103` (открытие поиска); **дефолт** |
| `routes` | `bottom_menu_page.dart:70` — вкладка Routes |
| `freeRoam` | `free_roam_page.dart:67` — вход в Free Roam |

**2) Резолвится** через `DataFinderOrigin.resolve(inNavigation, pathChanging)`
(`datafinder_models.dart`, читается в `search.dart:157,167`): origin ×
активная `PathNavRoute` × активная `RoutingRoutes`/`RouteDetails` → одно из 8
значений. Например: map-путь остаётся `Map-Main Page` вплоть до Directions→Go→Search
(только редактирование нарисованного маршрута → `Map-Direction-Path Changing`);
explore-путь становится `Explore-Direction` при старте навигации.

**3) Out-of-band события** (`favorite_add` из диалога без search-scope) читают тот
же источник через `searchProvider(map).dataFinderEventSource` — избранное из карты
= `Map-Main Page`, из Routes/Direction-поиска = наследует поверхность.

Инвариант зафиксирован тестом
`test/features/app_analytics/datafinder_origin_resolve_test.dart`.

### 1.7 Корреляторы (client-side UUID)

2GIS SDK не отдаёт server request id, поэтому они генерятся в `Search`-нотифаере
(`DataFinderIds.uuid()`, `datafinder_models.dart`):

- `request_id` — новый на **каждый вызов SDK** (`search.dart:316,405,472,553`).
- `suggestion_session_id` — один на сессию подсказок, ставится на первом нажатии
  клавиши (`search.dart:315`).
- `search_session_id` — один на поиск, новый на стр.1, **не** меняется на пагинации
  (`search.dart:404,471,552`).

Пары `suggestion_exposure↔suggestion_click` и `search_results_exposure↔click`
связываются по совпадающему session id. Флаги `_searchFromHistory` /
`_searchFromQuickFilter` определяют `search_type`.

`DataFinderPoi` строится общими мапперами (`datafinder_mappers.dart`):
`directoryObjectMessage.toDataFinderPoi(...)` / `suggestMessage.toDataFinderPoi(...)`;
`poi_type` — строковый тип объекта 2GIS (`branch`, `street`, …; `unknown` → `place`),
`poi_distance` — км с округлением до 2 знаков (минимум 0.01).

### 1.8 Тесты и документация
- `test/features/app_analytics/datafinder_origin_resolve_test.dart` — 8 значений `event_source`.
- `test/features/app_analytics/datafinder_poi_json_test.dart` — сериализация POI.
- `mapness/lib/features/app_analytics/README.md` — полный инженерный гайд.
- `docs/datafinder_event_examples.md` — примеры payload по каждому событию (v1.1, BRD-порядок).

---

## 2. Прочие потоки телеметрии (вне `appAnalyticsProvider`)

### 2.1 UXCam (`flutter_uxcam`) — запись сессий + крупнейший поток событий

- **Зачем:** запись сессий, теги экранов, кастомные события, репорт исключений.
- **Инициализация:** `entry_point.dart` → внутри `initMixpanel()` (стр. 711-727):
  `FlutterUxcam.startWithConfiguration(FlutterUxConfig(... userAppKey: '2w1otnta9bvvhzo' ...))`
  (crash handling, multi-session record; сетевой лог только в debug). Падение init
  не критично — приложение продолжает работу.
- **Обёртка `Metrics`** (`mapness/lib/shared/lib/urbi_metrics.dart`): статические
  `Metrics.logEvent` / `logEventAdvanced` → `FlutterUxcam.logEvent[WithProperties]`,
  `Metrics.logException` → `FlutterUxcam.reportExceptionEvent`. Это **самый частый**
  канал: ≈145 вызовов `Metrics.*` по всему `mapness/lib`.
- **Теги экранов:** `routes_observer.dart` — `FlutterUxcam.tagScreenName(path)` на
  каждый push/смену таба (авто-теги SDK выключены, теги ставятся вручную).
- **Прямые события:** `CommonFunctions.sendUXCamEvent(...)` (напр. SnapAndSend,
  `entry_point.dart:1188`).
- 📄 **Полный список всех 145 UXCam-событий** (по тегам, с именами и `file:line`) —
  в отдельном файле [`ANALYTICS_UXCAM_EVENTS.md`](ANALYTICS_UXCAM_EVENTS.md).

### 2.2 Mixpanel (`mixpanel_flutter`) — тайминги операций

- **Зачем:** измерять латентность/успех операций (сеть, поиск, авторизация, кэш).
  Паттерн `timeEvent('X')` … `await track('X')` вокруг async-операций.
- **Инициализация:** `entry_point.dart` → `initMixpanel()` (стр. 696-704),
  токен `2d045d85e25087812e92c62b84d6fbc3`, `trackAutomaticEvents: true`. Глобальная
  переменная `Mixpanel? mixpanel` (nullable — если init упал, вызовы `mixpanel?.` —
  no-op).
- **Где:** ≈44 места — `search.dart` (fetchSuggest/quickSearch/searchByText/
  searchByQuery), `auth_provider.dart` (doAuth/logOut/reset), `favourite_cache.dart`,
  `weather_remote_datasource.dart`, `stories_repo.dart`, `profile_image_provider.dart`,
  `iwish_entity.dart`, `qr_license_repository.dart`.
- На логауте — `mixpanel?.reset()`.

### 2.3 Urbi Analytics (`urbi_analytics`) — собственный бэкенд метрик

- **Зачем:** метрики продукта в бэкенд Urbi/Balady.
  `createClient(Configuration('balady-metrics.urbi.ae/metrics-api'))`.
- **Провайдер:** `urbiAnalyticsProvider` (`shared/providers/urbi_analytics.dart`),
  `keepAlive`. API: `.track(event, properties)`, `.screen(path)`, `.trackWithPrint(...)`.
- **Где (≈48):** `routes_observer.dart` (`.screen()` на каждый экран),
  `entry_point.dart:1204` (quickFilterSearch), `app_icon_quick_action_handler.dart`,
  `thermal_monitor.dart`, `search.dart` (emptySuggestResult/suggestResult и др.),
  а также как **приёмник (`track`)** для AdvancedMetrics (§2.4).
- Нативный мост `_HostFlutterApi.analyticsTrack` (`entry_point.dart:1600`) тоже
  шлёт в `analyticsClient.track` с `{'app_run': ...}`.

### 2.4 AdvancedMetrics (`urbi_metrics_utils.dart`) — тех-телеметрия

- **Зачем:** здоровье/производительность приложения. Singleton со своим
  `sessionId` (uuid). Метрики: время старта, использование батареи, потеря/восстановление
  GPS, время ответа поиска, расчёт маршрута, load time.
- **Куда шлёт:** через колбэк `track:` = `ref.read(urbiAnalyticsProvider).track`,
  т.е. фактически поток **(D) Urbi Analytics**.
- **Где (≈19):** `entry_point.dart` (`stopMeasureStartup`, `sendPreviousSessionBatteryUsage`,
  `startMeasureBattery`), `path_nav_message.dart` (lost/restore GPS),
  `search.dart` (`startSearchResponse`/`stopSearchResponse`).

### 2.5 Adjust (`adjust_sdk`) — маркетинг/атрибуция

- **Зачем:** атрибуция рекламных конверсий (advert metrics).
- **Провайдер:** `advertMetricsProvider` (`features/advert_metrics/advert_metrics.dart`);
  `Adjust.trackEvent(AdjustEvent(token))`.
- **Токены:** енам `AdvertMetricsKeys` → короткие токены Adjust (напр.
  `exploreLandingEngagement → 'g1f5nk'`, `poiSubmitted → 'vkqfwl'`). Есть флаг
  `isUniquePerSession` (сверка `sessionId` из AdvancedMetrics через `sharedPrefs`).
- **Где (≈31):** лендинг-энгейджмент (`map_tap_handler_provider.dart:227`), поиск
  (`entry_point.dart:1207`), добавление POI (`search_results.dart`, сторис,
  `submit_feedback.dart`), маршруты (`path_nav_page.dart` — halfway/completed/unique).
- **Android:** поды `com.adjust.sdk:adjust-android(+meta-referrer,+oaid)`.

### 2.6 BSS (`BssService`) — собственный серверный поток UI-событий

- **Зачем:** структурированный поток пользовательских событий в бэкенд Balady
  (BSS). Формат `BssRequest` (eventType, actionType, uiElement, payload).
- **Реализация:** `shared/providers/analytic/bss_service.dart` — singleton с
  **очередью и батч-отправкой раз в 5 сек** (`_sendInterval`, `_eventStack`,
  `Timer.periodic`). Инициализируется с `Dio`, `BssCommon`, потоком видимой области.
- **Где (≈43 вызова в 27 файлах):** особенно плотно в POI-картах
  (`pages/poi_card/*`, `poi_content_sliver.dart`), поиске (`suggest_item.dart`,
  `search_results.dart`), deeplink-старте поиска (`entry_point.dart:1214`).

### 2.7 Host-оболочка (корневой `lib/`) — Firebase Analytics + Sentry

Корневой `lib/` — это host-приложение суперappа, оборачивающее модуль `mapness`.
Здесь живут ещё два потока (по данным поиска; ключи не приводятся):

- **Firebase Analytics** (`firebase_analytics`): `fbAnalytics = FirebaseAnalytics.instance`
  в `lib/app/core/utils/common_functions.dart:73`, событийный лог на уровне оболочки.
  В самом `mapness` Firebase Analytics **не** используется — там только Firebase
  **Core** (init в `app_config_loader.dart`), **Messaging** (push) и **Remote Config**.
- **Sentry** (`sentry_flutter`, `sentry_dio`): инициализация в корневом `lib/main.dart`
  (обёртка `SentryFlutter.init`, `SentryScreenshotWidget`, `SentryUserInteractionWidget`),
  DSN на self-hosted `sentry.momah.gov.sa`. Perf-трейсинг ограничен в prod. Плюс
  UXCam `reportExceptionEvent` дублирует часть исключений.

---

## 3. Матрица «событие → куда уходит»

| Домен события | Insider | BytePlus | UXCam | Mixpanel | Urbi | AdvMetrics | Adjust | BSS | Sentry/FBA |
|---------------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Онбординг/сторис | ✅ | ✅ | ✅ | | | | ✅ | | |
| Навигация (start/half/complete) | ✅ | ✅ | ✅ | | ✅ | ✅ | ✅ | | |
| Быстрые фильтры/категории | ✅ | ✅ | ✅ | | ✅ | ✅ | | ✅ | |
| Поиск (suggest/results) | | ✅ (DataFinder) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | |
| POI-карточка/действия | | ✅ (favorite/click) | ✅ | | | | ✅ | ✅ | |
| Экраны (screen views) | | | ✅ (tag) | авто | ✅ (`.screen`) | | | | (FBA в оболочке) |
| Тех-телеметрия (батарея/GPS/старт) | | | | ✅ (тайминги) | ✅ (sink) | ✅ | | | |
| Краши/исключения | | | ✅ (report) | | | | | | ✅ Sentry |
| Идентификация юзера | ✅ login | ✅ setUserUniqueId | | reset на logout | | | | | |

> «Куда уходит» — приблизительно: часть доменов покрыта не всеми перечисленными
> вызовами одновременно; матрица отражает, какие системы в принципе задействованы
> в домене.

---

## 4. Наблюдения и потенциальные риски

1. **Единый фасад есть только у двух систем.** Через `appAnalyticsProvider` идут
   Insider + BytePlus. Остальные 6 потоков (UXCam/Mixpanel/Urbi/AdvancedMetrics/
   Adjust/BSS) вызываются напрямую и разрозненно — одно и то же действие часто
   логируется в 3-5 систем в разных местах (напр. `_openQuickFilter` в
   `entry_point.dart` шлёт сразу в Urbi + appAnalytics(categorySelected) + Adjust + BSS).
   Это ожидаемо для суперappа, но повышает риск рассинхрона имён/семантики.
2. **`userMovementDetected` — мёртвый код:** метод реализован в обоих impl, но
   **не вызывается** нигде. Кандидат на удаление или на подключение.
3. **Хардкод ключей в коде:** токен Mixpanel и `userAppKey` UXCam зашиты в
   `entry_point.dart` (не через `.env`/RemoteConfig, в отличие от BytePlus). Стоит
   унифицировать на конфиг по флейворам.
4. **Firebase Crashlytics — спящая зависимость:** объявлен как override, но не
   инициализирован и не используется. Либо подключить, либо убрать.
5. **UXCam init внутри `initMixpanel()`** — семантически спрятан; имя метода не
   отражает, что там же стартует UXCam.
6. **Prod App ID BytePlus** ранее числился как открытый вопрос (регистрация в
   консоли BytePlus) — проверить, что `.env.prod` реально содержит `10000002`
   и прод-канал (см. README §9).
7. **Приватные данные в записи сессий:** UXCam пишет экраны целиком —
   стоит убедиться, что чувствительные поля (SSO/национальный id, избранные адреса)
   маскируются (occlusion).

---

*Отчёт сгенерирован автоматическим обходом кода; номера строк актуальны на момент
составления (ветка `development`). Первоисточник по DataFinder —
`mapness/lib/features/app_analytics/README.md`.*
