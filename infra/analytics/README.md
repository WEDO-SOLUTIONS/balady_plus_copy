> [English](README.md) · [Русский](README.ru.md) · [العربية](README.ar.md)

# Balady+ self-owned analytics — PostHog self-hosted (experiment)

Runbook: from an empty server to dashboards. Also covers which secrets come into
existence and how to remove the experiment entirely. Context: `docs/analytics/DEVOPS_BRIEF.md`;
the stream migration plan is in `ANALYTICS_MIGRATION_PLAN.md` (repo root).

> **Experiment status.** PostHog self-hosted officially ships "as is": no vendor
> support, paid features are Cloud-only, and upgrades are our own
> responsibility (`https://posthog.com/docs/self-host`). We accepted this
> deliberately for the pilot. If it doesn't pan out — see "How to remove the experiment".

## 1. Server

Minimum requirements (per the PostHog docs, confirmed by the pilot):

| Parameter | Value |
|---|---|
| OS | Ubuntu 22.04/24.04 LTS, **x86_64** (the official script targets Ubuntu) |
| CPU / RAM | 4 vCPU / **16 GB** (8 GB is the absolute minimum and will be tight) |
| Disk | 60+ GB SSD (ClickHouse and Kafka grow; plan for 100+ in production) |
| Network | Public IP, ports **80/443** open, outbound internet access |
| DNS | An A record for a subdomain pointing at the IP, or without your own DNS: `<IP>.sslip.io` — resolves on its own, Caddy obtains a LetsEncrypt cert |

Pilot stand: Selectel (Kazakhstan), `153.80.192.8`, Ubuntu 24.04,
4 vCPU / 16 GB / 60 GB, domain `153.80.192.8.sslip.io`. Access is via SSH keys.

## 2. Deploying PostHog (the official hobby path)

```bash
ssh root@<server>
mkdir -p /opt/posthog && cd /opt/posthog
curl -fsSL https://raw.githubusercontent.com/PostHog/posthog/master/bin/deploy-hobby -o deploy-hobby
chmod +x deploy-hobby
# review the script before running; then (tag and domain as args, non-interactive):
./deploy-hobby latest <IP>.sslip.io
```

The script installs Docker on its own, clones `posthog/posthog`, generates `/opt/posthog/.env`
(instance secrets — POSTHOG_SECRET and others), downloads GeoIP and brings up ~30 containers.
Migrations and TLS certificate issuance take 5–10 minutes; readiness:
`curl -s localhost/_health` → `200`. Log: `/opt/posthog/deploy.log`.

Notes:
- The Rust services (capture and others) are pulled with the `:master` tag regardless of the
  application tag you picked — fine for the pilot, pin digests for production.
- If capture starts returning 503, it is almost certainly memory: `docker stats`,
  check ClickHouse/Kafka.
- Management: `cd /opt/posthog && docker-compose stop|start`.

## 3. Initial setup (in the UI, once)

1. Open `https://<IP>.sslip.io` → **sign up the first user** (the account is
   local; no registration with the vendor is needed) → create an organization and a project.
2. **Project API key** (`phc_…`) and **project id** (a number): Settings → Project.
   The key goes into the app (`BALADY_ANALYTICS_KEY`).
3. **Personal API key** (`phx_…`): profile → Personal API keys → create one with
   the `dashboard:read`, `dashboard:write`, `insight:write` scopes. Needed only
   for provisioning dashboards.

## 4. Smoke test without the app

```bash
POSTHOG_HOST=https://<IP>.sslip.io ./smoke_test.sh phc_YOUR_KEY
```

The `infra_smoke_test` event must show up in the UI: Activity → Explore. If it
arrived, the infrastructure is valid and you can wire up the app next.

## 5. Wiring up the app

In `.env.dev` (or whichever flavor the experiment uses):

```
BALADY_ANALYTICS_MODE=dual
BALADY_ANALYTICS_URL=https://<IP>.sslip.io
BALADY_ANALYTICS_KEY=phc_...
```

Empty URL/KEY = the transport stays logging-only, nothing is sent anywhere.
Build: `fvm flutter run --flavor dev` (or however it is usually done). Verification checklist:

- [ ] walk through the screens → `$screen` events in Activity;
- [ ] run a search → `searchByText` (with the `query` property), `Search::*`,
      `search_duration` (props `search_response_duration`, `search_query_type`,
      `search_query_value`);
- [ ] events have `$os` and `$app_version` populated;
- [ ] login → an identify event (the person stops being anonymous), logout → reset;
- [ ] turn off the network, generate some events, turn it back on → the events arrive (the SDK
      persists the queue offline).

## 6. Dashboards

```bash
cd infra/analytics/dashboards
POSTHOG_HOST=https://<IP>.sslip.io POSTHOG_PROJECT_ID=1 POSTHOG_API_KEY=phx_... \
  python3 provision.py
```

Creates 4 dashboards: Audience (DAU/WAU/MAU, retention, platforms/versions),
Search (top queries, funnels, empty results), Screens & navigation, Tech
(exceptions, APIError, search timings). Idempotent; `--force` recreates.

Editing dashboards: change the `*.json` files here and rerun with `--force` — do not
edit them by hand in the UI (it will be overwritten). If PostHog rejects the query schema after
an upgrade: build the insight in the UI, grab the `query` via
`GET /api/projects/<id>/insights/<id>` and update the JSON.

## 7. Secrets: what lives where and how to hand it over

| Secret | Where it is used | Where to store it |
|---|---|---|
| SSH keys to the server | access to the VM | everyone has their own key; root access is granted by the server owner |
| PostHog UI admin login | web interface | team password manager (1Password/Bitwarden — whatever the team uses) |
| `phc_…` project key | the app (`BALADY_ANALYTICS_KEY` in `.env.*`) | password manager + local `.env` files (do not commit prod values) |
| `phx_…` personal key | provision.py only | personal, each person has their own; a vault is not required |
| `/opt/posthog/.env` on the server | instance secrets (POSTHOG_SECRET and others) | server only; when migrating, back it up together with the DB |

The repository contains placeholders only. Git hooks do not catch every leak: never
put keys into commits. The `phc_` key is technically "public" (it ships in the build), but
there is no reason to expose it outside the team.

## 8. How to remove the experiment

1. Shut down / return the server (all data and instance secrets die with it).
2. In the repo: `git rm -r infra/analytics ANALYTICS_MIGRATION_PLAN.md` (the plan — if
   you decided not to continue at all).
3. Flutter: delete `posthog_balady_analytics_sink.dart`, remove `posthog_flutter` from
   `mapness/pubspec.yaml` and `com.posthog.posthog.AUTO_INIT` from
   `AndroidManifest.xml`/`Info.plist`; drop the `sink:` parameter in the two
   `configure()` calls (host `app.dart`, mapness `entry_point.dart`).
4. `.env.*`: remove `BALADY_ANALYTICS_URL`/`BALADY_ANALYTICS_KEY`.
5. The facade, the channels and `UrbiBaladyAnalyticsSink` **stay** — they are not tied to
   PostHog and are needed for migrating to any other backend.
