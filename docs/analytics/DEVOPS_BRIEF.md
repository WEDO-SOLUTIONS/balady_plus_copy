# Balady+ Self-Hosted Analytics — DevOps Brief

> TL;DR: we are deploying **our own** product/technical analytics server
> (replacing the dead UXCam and external SDKs we have lost access to).
> Target stack — **PostHog self-hosted** (open source: own UI, own DB, API).
> The app is already prepared to send events — only the server is missing.

## Why

- **Access lost** to legacy systems (UXCam, Mixpanel, Insider, BytePlus) —
  data leaks to third-party servers, and we have no dashboards of our own.
- We need our own data: search/navigation funnels, screens, API errors, timings —
  inside our own perimeter (data residency, PII under our control).
- The first step is done: UXCam has been removed from the app, and all of its ~200 events
  have been migrated to the internal `BaladyAnalytics` facade (currently no-op/log).

## What to deploy

**PostHog self-hosted** (https://posthog.com/docs/self-host).
**The pilot is already deployed** on a temporary host (Selectel, `153.80.192.8.sslip.io`) —
the step-by-step runbook with the server spec, the secrets involved and the teardown
procedure: **`infra/analytics/README.md`**. For the permanent perimeter, repeat the same steps:

- A VM with Ubuntu 22.04/24.04 x86_64, 4 vCPU / 16 GB RAM / 100+ GB SSD, ports 80/443.
- The official `deploy-hobby` (docker compose, ~30 containers: ClickHouse,
  Kafka, PostgreSQL, Redis, Temporal and others). k8s/Helm is no longer
  supported by the vendor — compose only.
- A domain like `analytics.<our-perimeter>` + TLS (Caddy obtains LetsEncrypt
  certificates itself). UI access — via team SSO/VPN.
- Backups: ClickHouse + PostgreSQL + `/opt/posthog/.env`, event retention —
  12 months (negotiable).
- Keep in mind: there is no vendor support for self-hosted (the product is "as is"),
  upgrades are on us (`bin/upgrade-hobby`); the rust services are pulled with the
  `:master` tag — pin image digests before going beyond the pilot.

## What requests the app will send (and why)

| Request | What it is | Volume (estimate) |
|---|---|---|
| `POST /batch` | event batches (JSON): screens, taps, search, API errors | main stream; batches of 10–50 events, gzip |
| `POST /decide` | feature flags / SDK config (optional, phase 2) | 1 per session start |
| `GET /array/...` | JS/SDK config (optional) | rare, cached |

Events are sent by the mobile app (iOS/Android) on behalf of the user —
the endpoint must be reachable from the public internet (like a regular API),
POST only, with no CORS relaxations beyond what is necessary.

## What is needed from the app (already in place)

- `.env.<flavor>` → `BALADY_ANALYTICS_MODE` = `legacy` | `dual` | `ours` —
  the kill switch (currently prod=`legacy`, everything else=`dual`).
- Once the server is ready: we add `BALADY_ANALYTICS_URL` + the PostHog project API key
  to `.env` and replace the logging transport with the PostHog SDK — feature code
  stays unchanged.

## Plan (phases)

1. **Now**: facade in the app, stub transport. Nothing is sent anywhere.
2. **Pilot**: PostHog in the stg perimeter → `dual` on stg/dev builds → verify
   dashboards (search funnel, screen views, APIError).
3. **Production**: PostHog in prod → switch prod to `dual` → migrate the remaining
   legacy streams (Mixpanel timings, Urbi Analytics) into the facade.
4. **Final**: `ours` — legacy SDKs are switched off as readiness allows.
   BSS (our server-side stream for search/map) lives independently and stays.

## Security / PII

- Data does not leave our perimeter (unlike UXCam/Mixpanel/BytePlus).
- Identity: the national ID must **not** be used as distinct_id in the clear —
  during the Pilot phase we will agree on hashing (e.g., SHA-256 of `sub`).
- Masking: enable session recordings (replay) only after a PII review.

## Context

- Full map of the legacy analytics: `docs/analytics/ANALYTICS_REPORT.md`.
- Facade engineering guide: `mapness/lib/features/balady_analytics/README.md`.
