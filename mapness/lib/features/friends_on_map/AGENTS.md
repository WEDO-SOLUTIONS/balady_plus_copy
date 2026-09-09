# Friends on Map Notes

This subtree will own the Friends on Map domain (BE-213): consent/activation, location permissions, position reporting, the friend graph (invite/QR, requests, friend list, block), friend markers + friend card on the map, and — if time allows within the timebox — the additive social-layer pieces (reduced meetup, check-ins, shared lists).

## Status

Part A (Foundations) is done: S-01 (activate) + S-02 (manage location permission) + S-03 (position reporting) + S-05 (global pause) + S-06 (deactivate). Part B (friend graph) has started: the friend list screen (S-11 core — header/count, search, empty state) is in, reading from a mocked in-memory repository (no real friends can be added yet — that's S-07, not built). Nothing from Part C (map) has started. Read the roadmap below before continuing Part B.

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
- A bearer-token Dio interceptor already exists at `shared/lib/auth/auth_token_interceptors.dart` — `AuthTokenInterceptor.tokenInterceptor(ref, baseOptions)`, reusable verbatim: reads `tokenProvider.future` (always-non-null `Future<String>`, empty when logged out), attaches `Authorization: Bearer`, retries once on 401 after `tokenProvider.notifier.refreshToken()`. Three existing call sites (`shared/providers/dgis_network.dart`, `dgis_http_network.dart`, `dgis_hmac_netwrok.dart`) all build a **fresh, feature-scoped `Dio(BaseOptions(baseUrl: ...))`**, not a clone of the shared `baseDioProvider` singleton — that's the convention to follow, not `short_link_repository.dart`'s clone-then-new-Dio approach (also read, but the outlier). The real blocker isn't the interceptor, it's the base URL: `EnvironmentConfig` (`shared/config/environment_config.dart`) has one URL field per backend, sourced from Firebase Remote Config across four env factories (`.urbiDev()` etc.) — a real Friends on Map backend needs a new `friendsOnMapApi` field added there first. Don't build this Dio client until a real endpoint exists to point it at; every repository in this feature is still a mocked in-memory fake.
- Local-first Hive cache, matching `features/favourites/`'s pattern exactly: box via `hiveProvider(boxName)` (`shared/providers/hive.dart`), pending add/delete sync as two `List<T>` keys in the *same* box (not a separate box), next free Hive `typeId` is **6** (favourites uses 2-5, search history uses 1). Adapters are **hand-registered** in `entry_point.dart`'s `initHive()` (~line 1640) — the generated `hive_registrar.g.dart` exists but is dead code, never called; a new Hive model's adapter must be added there by hand. This pattern is deliberately not yet used for the friend list (see "Important Files" below) — it earns its complexity once there's a real add/remove mutation to protect against app-kill-mid-sync, not for a read-only mocked list with nothing to lose.
- BRD requirement R-85 (ETA-mode sharing links) is specified as reusing the temporary-sharing-link mechanism (R-80–R-84) — `features/share_eta/` may already cover a meaningful part of the "temporary/ETA location sharing" story (S-19) independently of the friend graph. Confirm the actual overlap before estimating that piece.

## A BR-05 tension to resolve later, not now

BRD business rule BR-05 (S-11) describes the friend list as "the single in-feature hub" that requests/activity/shared-lists/privacy/notifications are all reached *from* — implying it should eventually **replace** `FriendsOnMapPage`'s post-activation view, not be a screen reached *from* it. Right now it's the other way around: the friend list is one more row on `FriendsOnMapStatusView`, alongside pause/deactivate, for the same reason those are there — no other destination exists yet to justify restructuring around. Revisit this once enough of the hub's rows (requests, activity, shared lists, the real privacy screen) exist to make one restructuring worthwhile, rather than moving the entry point piecemeal on every slice.

## Important Files

- `models/friends_on_map_activation_status.dart`: `notActivated | foregroundDenied | activeForegroundOnly | activeWithBackground | revoked`. `foregroundDenied`/`revoked` are live permission reads, not persisted — see the doc comment on each value.
- `providers/friends_on_map_activated.dart`: persisted "has the user ever completed activation" bool (SharedPreferences), copied from `shared/providers/onboarding.dart`'s pattern. Also the S-01 AC-05 "don't repeat the disclosure" flag.
- `providers/friends_on_map_activation.dart`: `@Riverpod(keepAlive: true)` orchestrator — derives status from the persisted flag + a live `Geolocator.checkPermission()` read (never permission_handler for foreground-vs-background, it can't distinguish whileInUse from always). Exposes `requestForegroundPermission()`, `requestBackgroundPermission()`, `completeActivation()`, `refreshPermissionStatus()` (called on resume, both pre- and post-activation).
- `data/friends_on_map_activation_repository.dart` + `data/fake_friends_on_map_activation_repository.dart`: the mocked-backend seam for activation. Swap the binding in `providers/friends_on_map_activation_repository.dart` for a Dio-backed implementation once a real endpoint exists — nothing above it should need to change.
- `ui/friends_on_map_page.dart`: `@RoutePage()`, one screen that switches on activation status. Owns the pre-activation local step (disclosure → optional background prompt) as plain widget state, since that's ephemeral to one user action, not shared app-wide state.
- `ui/widgets/`: one view per status — disclosure (R-02), permission-denied (R-05), background-prompt (R-04), status (R-06/R-07 copy, active + revoked variants).
- Entry point: `pages/profile/profile_page.dart`, a `ContentRowV2` alongside Account/Help Center/About/Privacy (not under `SettingsRoute` — that page holds device/app preferences like Dark Mode and Language, not feature entry points).
- Resume-triggered revocation detection (R-07) lives partly outside this subtree: `pages/map/map_page.dart`'s existing `didChangeAppLifecycleState` gets a guarded `refreshPermissionStatus()` call, and its `build()` gets a `ref.listen` that toasts the moment status flips to `revoked` — `MapPage` is the always-mounted screen, so this is how the user is informed even off the Friends on Map page itself.
- `android/app/src/main/AndroidManifest.xml` (repo root) now declares `ACCESS_BACKGROUND_LOCATION` — required for `Geolocator.checkPermission()` to ever return `always` on Android; it was missing before this slice.
- l10n keys: `friendsOnMap*` in `mapness/lib/l10n/app_en.arb` / `app_ar.arb`. Placeholder copy — not reviewed by legal/design, per R-02's disclosure requirement in the BRD.
- `data/friends_on_map_position_repository.dart` + `data/fake_friends_on_map_position_repository.dart`: mocked-backend seam for `reportPosition()`. The fake overwrites one field, never appends — satisfies R-15 (no history) by construction.
- `data/friends_on_map_visibility_repository.dart` + `data/fake_friends_on_map_visibility_repository.dart`: mocked-backend seam for the pause (`setPaused()`). Kept separate from the position/activation repositories rather than combined, matching how the API description separates `/v1/me/position` from `/v1/me/visibility`.
- `providers/friends_on_map_position_reporter.dart`: `@Riverpod(keepAlive: true)` — a `Timer.periodic` loop (currently a placeholder fixed 30s interval, `// TODO(BE-213)`: not yet the BRD's N-01–N-04 adaptive intervals) that calls the position repository whenever activation status is one of the active variants. Reads position from the existing `shared/providers/location.dart`'s `locationProvider` rather than opening a second `Geolocator` stream. Deliberately never gated on the pause flag — R-16 requires reporting to continue while paused, with suppression happening at the read side once Part B's visibility authorization exists. Must be kept alive by something watching it even when the Friends on Map screen is closed — `pages/map/map_page.dart`'s `build()` does this (`ref.watch(friendsOnMapPositionReporterProvider)`), same rationale as its existing resume/revocation wiring.
- `providers/friends_on_map_paused.dart`: persisted bool (SharedPreferences), same shape as `friends_on_map_activated.dart`. Deliberately independent of the activation flag — per BR-03 of S-06, `FriendsOnMapActivation.deactivate()` must not touch it, so a pause set before deactivating is still in effect after reactivating.
- `providers/friends_on_map_activation.dart` also now exposes `deactivate()` (S-06) — flips the persisted activated flag back to `false`, which is what the position reporter watches, so reporting stops as a direct consequence rather than through a separate "stop" call.
- The pause toggle and deactivate button currently live directly on `ui/widgets/friends_on_map_status_view.dart` (now a `ConsumerWidget`), ahead of the real privacy screen (R-95) which depends on the friend-list hub from Part B. This is a deliberate, temporary placement — moving them onto that screen later is a pure relocation, not a rework.
- `models/friend.dart`: plain domain model (id, displayName, profilePictureUrl) — no position/presence/district fields yet, those need real data from a backend this feature doesn't have.
- `data/friends_repository.dart` + `data/fake_friends_repository.dart`: mocked-backend seam for `getFriends()`, returns a fixed 3-friend sample. Deliberately a plain in-memory fake, not backed by Hive — see the local-first-cache note above for why.
- `providers/friends_list.dart`: plain `@riverpod Future<List<Friend>>` — not gated on `friendsOnMapActivatedProvider` (R-09: the friend graph is independent of activation; only *reachability*, via the status-view entry point, currently depends on it).
- `providers/friend_search_query.dart`: raw search text state (R-42). No debounce (tiny dataset), no Arabic orthographic normalization (BRD open decision D-16 leaves cross-script matching undecided) — case-insensitive substring match only, applied client-side in `ui/friend_list_page.dart`.
- `ui/friend_list_page.dart`: `@RoutePage()`. Distinguishes "no friends at all" (R-46 empty state with an inert add-friend action, `ui/widgets/friend_list_empty_state.dart`) from "search matched nothing" (a plain message, list stays interactive) — these are different states, don't conflate them.
- `ui/widgets/friend_list_item.dart`: avatar-or-initials + display name row. Initials derivation (first letter of first two words, or one letter for a single-word name) is a placeholder — BRD open decision D-09 leaves single-word-name initials undecided; not a design-reviewed answer.
- Entry point: one more row on `ui/widgets/friends_on_map_status_view.dart`, alongside pause/deactivate — see the BR-05 tension note above for why this isn't yet the real hub architecture.

## Verification

Once code lands here:

```bash
rtk fvm dart format -l 120 mapness/lib/features/friends_on_map/<changed-files>
rtk fvm flutter analyze --no-pub mapness/lib/features/friends_on_map/
```
