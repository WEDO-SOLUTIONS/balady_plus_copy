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

**PostHog self-hosted** (https://posthog.com/docs/self-host):

- Option A (starter/pilot): `docker compose` on a single VM —
  4 vCPU / 16 GB RAM / 200 GB SSD is enough to begin with.
- Option B (production): Helm chart on k8s. Inside: ClickHouse (events),
  PostgreSQL (metadata), Redis, MinIO/S3 (session recordings, if enabled).
- A domain like `analytics.<our-perimeter>` + TLS. UI access — via team SSO/VPN.
- Backups: ClickHouse + PostgreSQL, event retention — 12 months (negotiable).

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
