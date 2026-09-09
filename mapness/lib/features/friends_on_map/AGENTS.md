# Friends on Map Notes

This subtree will own the Friends on Map domain (BE-213): consent/activation, location permissions, position reporting, the friend graph (invite/QR, requests, friend list, block), friend markers + friend card on the map, and — if time allows within the timebox — the additive social-layer pieces (reduced meetup, check-ins, shared lists).

## Status

No code has landed here yet. This file is the entry point for continuing work across sessions and context resets — read the roadmap below before writing any code, and keep this file updated as parts land, the same way `favourites/AGENTS.md` and `satellite/AGENTS.md` do for their subtrees.

## Roadmap

The prioritized implementation plan — MVP parts A (foundations) / B (friend graph) / C (map), cross-cutting infra, additive tier-2 items, cut items, and a schedule-risk list — lives in a published artifact, not in this repo:

https://claude.ai/code/artifact/7f8842df-16a3-42eb-8a54-94068af83a78

("Friends on Map Roadmap"). Its checkbox progress is stored per-browser (`localStorage`) — it reflects whatever the last viewer clicked, not actual code state. Treat it as a working checklist, not a source of truth for what's actually shipped; this file and the git history are that source of truth.

## Source requirements

Not committed to the repo — held in `~/Downloads/friends-on-map/` on the machine that authored the plan:

- `BRD_R1_Friends_on_Map_v2.1.md` — 123 functional + 14 non-functional requirements, 21 user stories, open-decision register (D-01..D-20), Appendix B (limits/thresholds), Appendix C (notification categories).
- `API_description_ Friends on map_v1.1.md` — companion OpenAPI (`friends-on-map-api.yaml`) description: 44 paths / 57 operations, real-time WebSocket channel spec, a mock server (`mock_server.py`) and Postman collection for contract testing.

## Scope decisions made 2026-09-09, before any code

Timebox: 2 weeks max including testing. Backend: mocked, not blocking — develop and test against the OpenAPI contract's mock server; the real backend arrives on its own schedule and testing does not wait for it.

- **Chat/messaging (BRD story S-21) is cut** for this iteration.
- **Meetup ("share a place", S-17) is built reduced**: a one-way place-share object outside any conversation thread, not a message type. The full BRD version (R-70, R-117, business rule BR-03 of S-17) specifies the place card as a message living inside a 1:1 conversation, which isn't being built.
- **Push notifications and movement/geofence notifications (S-20, S-22) are deferred.** No device-token registration exists anywhere in the app yet. Per BRD business rule BR-06 (S-11), in-app entry points (the friend list's pending-requests badge) are sufficient without push, so this is safe to defer.
- **Friends layer on the map**: build the BRD's own documented fallback from day one — a toggle inside this feature's own bottom sheet — instead of waiting to confirm whether `features/lifestyle_layers/`'s existing map layers control can accept a new entry (open decision D-13, owner/timeline unconfirmed). Abstract the toggle so swapping to a real layers-control entry later doesn't require rewriting the map screen.
- **Friend positions start as polling** (`GET /v1/friends:positions` every 10-15s) behind an interface, not the full WebSocket channel from the API description. Upgrade later by copying `features/share_eta/providers/eta_websocket_locator.dart`.
- **QR code scanner is in scope for the MVP**, not a stretch item, built from scratch (old scanner code in the app is commented out / removed from dependencies).
- **First thing to cut if part B runs over time**: joining via invite link when the recipient has no app installed yet (store fallback + applying the invite after install, BRD story S-08). Nothing in the app handles that case today.

Full rationale for each of these is in the roadmap artifact above.

## Reusable patterns found elsewhere in this codebase

- Profile-picture marker + moving-marker updates, and a working raw-WebSocket client with a bespoke auth header: `features/share_eta/` (`providers/eta_geo_subscriber.dart`, `providers/eta_websocket_locator.dart`).
- Map-layer registration: `LayerType` enum + `LayersControls` provider in `features/lifestyle_layers/` (satellite/parking/favourites already follow it — see `features/satellite/AGENTS.md` for a worked example).
- Local-first Hive cache with pending add/delete sync: `features/favourites/` — see its own `AGENTS.md` for the pattern in detail.
- A bearer-token Dio interceptor already exists at `shared/lib/auth/auth_token_interceptors.dart`, but there is no existing "plain JSON REST + bearer" Dio module — assemble one from that interceptor plus a fresh module. `shared/providers/short_link_repository.dart` is the closest structural template but does not attach the bearer token.
- BRD requirement R-85 (ETA-mode sharing links) is specified as reusing the temporary-sharing-link mechanism (R-80–R-84) — `features/share_eta/` may already cover a meaningful part of the "temporary/ETA location sharing" story (S-19) independently of the friend graph. Confirm the actual overlap before estimating that piece.

## Important Files

_(empty — update as code lands, following the pattern in `favourites/AGENTS.md` / `satellite/AGENTS.md`: one line per file naming its responsibility)_

## Verification

Once code lands here:

```bash
rtk fvm dart format -l 120 mapness/lib/features/friends_on_map/<changed-files>
rtk fvm flutter analyze --no-pub mapness/lib/features/friends_on_map/
```
