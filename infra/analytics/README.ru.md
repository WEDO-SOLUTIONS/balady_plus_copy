> [English](README.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

# Своя аналитика Balady+ — PostHog self-hosted (эксперимент)

Runbook: от пустого сервера до дашбордов. Здесь же — какие секреты появляются
и как удалить эксперимент целиком. Контекст: `docs/analytics/DEVOPS_BRIEF.md`,
план миграции потоков — `ANALYTICS_MIGRATION_PLAN.md` (корень репо).

> **Статус эксперимента.** PostHog self-hosted официально идёт «as is»: без
> вендор-поддержки, платные фичи — только в их Cloud, апгрейды — наша
> ответственность (`https://posthog.com/docs/self-host`). Мы приняли это
> осознанно для пилота. Если не взлетит — см. «Как удалить эксперимент».

## 1. Сервер

Минимум (по докам PostHog и подтверждено пилотом):

| Параметр | Значение |
|---|---|
| ОС | Ubuntu 22.04/24.04 LTS, **x86_64** (официальный скрипт рассчитан на Ubuntu) |
| CPU / RAM | 4 vCPU / **16 GB** (8 GB — абсолютный минимум, будет впритык) |
| Диск | 60+ GB SSD (ClickHouse и Kafka растут; для прода закладывать 100+) |
| Сеть | Публичный IP, открытые **80/443**, исходящий интернет |
| DNS | A-запись поддомена на IP, или без своего DNS: `<IP>.sslip.io` — резолвится сам, Caddy получает LetsEncrypt |

Пилотный стенд: Selectel (Казахстан), `153.80.192.8`, Ubuntu 24.04,
4 vCPU / 16 GB / 60 GB, домен `153.80.192.8.sslip.io`. Доступ — по SSH-ключам.

## 2. Деплой PostHog (официальный hobby-путь)

```bash
ssh root@<server>
mkdir -p /opt/posthog && cd /opt/posthog
curl -fsSL https://raw.githubusercontent.com/PostHog/posthog/master/bin/deploy-hobby -o deploy-hobby
chmod +x deploy-hobby
# просмотрите скрипт перед запуском; затем (тег, домен — аргументами, неинтерактивно):
./deploy-hobby latest <IP>.sslip.io
```

Скрипт сам ставит Docker, клонирует `posthog/posthog`, генерит `/opt/posthog/.env`
(секреты инстанса — POSTHOG_SECRET и др.), качает GeoIP и поднимает ~30 контейнеров.
Миграции и выпуск TLS-сертификата занимают 5–10 минут; готовность:
`curl -s localhost/_health` → `200`. Лог: `/opt/posthog/deploy.log`.

Заметки:
- rust-сервисы (capture и др.) тянутся с тегом `:master` независимо от выбранного
  тега приложения — для пилота ок, для прода зафиксировать digests.
- Если capture начал отдавать 503 — почти наверняка память: `docker stats`,
  смотреть ClickHouse/Kafka.
- Управление: `cd /opt/posthog && docker-compose stop|start`.

## 3. Первичная настройка (в UI, один раз)

1. Откройте `https://<IP>.sslip.io` → **signup первого пользователя** (аккаунт
   локальный, никакой регистрации у вендора не нужно) → создайте организацию и проект.
2. **Project API key** (`phc_…`) и **project id** (число): Settings → Project.
   Ключ пойдёт в приложение (`BALADY_ANALYTICS_KEY`).
3. **Personal API key** (`phx_…`): профиль → Personal API keys → создать со
   скоупами `dashboard:read`, `dashboard:write`, `insight:write`. Нужен только
   для провижининга дашбордов.

## 4. Смоук без приложения

```bash
POSTHOG_HOST=https://<IP>.sslip.io ./smoke_test.sh phc_ВАШ_КЛЮЧ
```

Событие `infra_smoke_test` должно появиться в UI: Activity → Explore. Если
дошло — инфра валидна, дальше можно подключать приложение.

## 5. Подключение приложения

В `.env.dev` (или другой флейвор эксперимента):

```
BALADY_ANALYTICS_MODE=dual
BALADY_ANALYTICS_URL=https://<IP>.sslip.io
BALADY_ANALYTICS_KEY=phc_...
```

Пустые URL/KEY = транспорт остаётся логирующим, ничего никуда не шлётся.
Сборка: `fvm flutter run --flavor dev` (или как принято). Чек-лист проверки:

- [ ] походить по экранам → `$screen` события в Activity;
- [ ] выполнить поиск → `searchByText` (с property `query`), `Search::*`,
      `search_duration` (props `search_response_duration`, `search_query_type`,
      `search_query_value`);
- [ ] у событий заполнены `$os`, `$app_version`;
- [ ] login → событие identify (person перестаёт быть anonymous), logout → reset;
- [ ] выключить сеть, погенерить события, включить → события доехали (SDK
      персистит очередь офлайн).

## 6. Дашборды

```bash
cd infra/analytics/dashboards
POSTHOG_HOST=https://<IP>.sslip.io POSTHOG_PROJECT_ID=1 POSTHOG_API_KEY=phx_... \
  python3 provision.py
```

Создаёт 4 дашборда: Audience (DAU/WAU/MAU, retention, платформы/версии),
Search (топ запросов, воронки, пустые выдачи), Screens & navigation, Tech
(исключения, APIError, тайминги поиска). Идемпотентно; `--force` пересоздаёт.

Правка дашбордов: меняйте `*.json` здесь и перезапускайте с `--force` — не
редактируйте вручную в UI (перетрётся). Если PostHog отверг query-схему после
апгрейда: соберите инсайт в UI, заберите `query` через
`GET /api/projects/<id>/insights/<id>` и обновите JSON.

## 7. Секреты: что где живёт и как передавать

| Секрет | Где используется | Где хранить |
|---|---|---|
| SSH-ключи к серверу | доступ на VM | у каждого свой ключ; root-доступ раздаёт владелец сервера |
| Админ-логин PostHog UI | веб-интерфейс | командный менеджер паролей (1Password/Bitwarden — что принято) |
| `phc_…` project key | приложение (`BALADY_ANALYTICS_KEY` в `.env.*`) | менеджер паролей + локальные `.env` (не коммитить значения prod) |
| `phx_…` personal key | только provision.py | личный, у каждого свой; в vault не обязателен |
| `/opt/posthog/.env` на сервере | секреты инстанса (POSTHOG_SECRET и др.) | только на сервере; при переезде — бэкапить вместе с БД |

В репозитории — только плейсхолдеры. Git-хуки ловят не все утечки: ключи в
коммиты не класть. `phc_`-ключ технически «публичный» (уходит в билд), но
светить его вне команды незачем.

## 8. Как удалить эксперимент

1. Погасить/вернуть сервер (все данные и секреты инстанса умирают вместе с ним).
2. В репо: `git rm -r infra/analytics ANALYTICS_MIGRATION_PLAN.md` (план — если
   решили не продолжать вообще).
3. Флаттер: удалить `posthog_balady_analytics_sink.dart`, `posthog_flutter` из
   `mapness/pubspec.yaml`, `com.posthog.posthog.AUTO_INIT` из
   `AndroidManifest.xml`/`Info.plist`; убрать параметр `sink:` в двух
   `configure()` (host `app.dart`, mapness `entry_point.dart`).
4. `.env.*`: удалить `BALADY_ANALYTICS_URL`/`BALADY_ANALYTICS_KEY`.
5. Фасад, каналы и `UrbiBaladyAnalyticsSink` **остаются** — они не привязаны к
   PostHog и нужны для миграции на любой другой бэкенд.
