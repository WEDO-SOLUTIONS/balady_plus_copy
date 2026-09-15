# BE-336 — Open in Balady+ from third-party apps

**Status:** in development on `feat/BE-336/open-in-balady-plus` (not yet merged to `development`)
**JIRA:** [BE-336 — Epic](https://wedosolutions-sa.atlassian.net/browse/BE-336), [BE-334 — `baladymaps://` scheme + Android `geo:` fix](https://wedosolutions-sa.atlassian.net/browse/BE-334), [BE-335 — iOS routing-app registration](https://wedosolutions-sa.atlassian.net/browse/BE-335)

## What it is

Makes Balady+ appear in the system "open in / route with" menus that
other apps offer: WhatsApp's location and address menus (Android and
iOS), and iOS's own Apple Maps / Find My / Contacts / Calendar "route
in other apps" pickers. Two child tasks:

- **BE-334** — a new `baladymaps://` URL scheme for partner integration
  (WhatsApp/Meta) plus a fix for Android `geo:` links: today any `geo:`
  URI with a single path segment falls through to the short-link
  service and shows a "no internet" toast instead of opening the point.
- **BE-335** — registers the app as an iOS *routing app*
  (`MKDirectionsApplicationSupportedModes` + `CFBundleDocumentTypes` /
  `com.apple.maps.directionsrequest` in `Info.plist`, plus a coverage
  GeoJSON) so Apple Maps, Find My, Contacts and Calendar can hand a
  `MKDirectionsRequest` to Balady+.

This document covers the parts that live outside the repository (App
Store Connect, Meta/WhatsApp coordination, device verification) and
the external contract (the URL scheme) that partner teams need. The
code itself is described only at the level needed to understand where
those manual steps plug in.

## Architecture

```
WhatsApp (Android/iOS)          Apple Maps / Find My / Contacts / Calendar (iOS)
      |                                        |
      | baladymaps://…   geo:…                 | MKDirectionsRequest
      v                 v                      v
AndroidManifest.xml  AndroidManifest.xml   SceneDelegate.swift
  <data scheme=          <data scheme=       scene(_:openURLContexts:)
  "baladymaps"/>          "geo"/>              -> DirectionsRequestChannel.handle(url:)
      |                    |                      |  (checked before AppLinks.shared.handleLink)
      +---------+----------+                      |
                |                                 | momra.balady/directions_request
                v                                 v
     entry_point.dart: openAppLink(uri)   DirectionsRequestNativeBridge (Dart)
                |                                 |
                |  branch inserted BEFORE           |
                |  _handleShortLink                |
                v                                 |
     ExternalMapLinkParser.parse(uri)              |
                |  -> ExternalMapLinkIntent?          |
                v                                 |
     ExternalMapLinkNavigator.open(intent)  <------+
                |
    +-----------+------------+
    v           v            v
openSearch  openLocationCard  openDirections
(SearchRoute) (DeeplinkRoute)  (RoutingRoutesRoute)
```

Key pieces:

- [`mapness/lib/features/external_map_links/`](../../mapness/lib/features/external_map_links/)
  — `ExternalMapLinkParser` turns a `baladymaps://` or `geo:` `Uri`
  into a sealed `ExternalMapLinkIntent` (`ExternalMapSearchIntent` /
  `ExternalMapShowLocationIntent` / `ExternalMapDirectionsIntent`), and
  `ExternalMapLinkNavigator` executes one: push the search route and
  run the query, replace-or-push the location card
  (`DeeplinkRoute`), or replace-or-push `RoutingRoutesRoute` with the
  resolved source/destination points.
- `mapness/lib/entry_point.dart`, `openAppLink` — the new branch is
  inserted right after `initCameraPositionPoint()` and **before**
  `_handleShortLink` runs. If the scheme is `baladymaps`/`geo` but the
  link doesn't parse, it is logged and dropped — the app never guesses.
- `ios/Runner/DirectionsRequestChannel.swift` — a new native channel,
  `momra.balady/directions_request`, that mirrors the cold-start
  storage pattern already used by `AppIconQuickActionChannel`: a
  static `pendingRequest` is stashed natively if Flutter isn't ready
  yet, and the Dart side calls back to peek/consume it once the engine
  is up (`initExternalDirectionsRequests()` in `entry_point.dart`,
  delivered on cold start and again on `didChangeAppLifecycleState`
  resumed).
- `ios/Runner/SaudiArabiaCoverage.geojson` — the routing-app coverage
  polygon (see manual steps below).

## URL scheme spec (external contract — for Meta/WhatsApp)

| Use case | Link |
| --- | --- |
| Address search | `baladymaps://?q=<query>` (alias `text`), optional `&near=<lat>,<lng>` |
| Show a location | `baladymaps://?ll=<lat>,<lng>`, optional `&label=<name>&z=<1..20>` |
| Directions | `baladymaps://?daddr=<lat,lng\|text>`, optional `&saddr=<lat,lng\|current>&mode=<driving\|walking\|transit>` |

Parameter semantics:

- All values are UTF-8, percent-encoded; Arabic text is supported.
- Coordinates use a dot as the decimal separator, regardless of locale.
- A malformed `ll` (unparsable pair, or a component out of range) makes
  the whole link ignored — nothing opens, nothing is guessed.
- `z` is clamped to `1..20`; an unparsable value is treated as absent.
- An unknown `mode` falls back to `driving`.
- Absent `near` biases search results to the whole Kingdom rather than
  a specific area.

Android also fixes handling of the three `geo:` forms Google already
documents:

- `geo:lat,lng` — show that point.
- `geo:lat,lng?q=lat,lng(Label)` — show the point with a label.
- `geo:0,0?q=address text` — free-text search (the `0,0` here is a
  placeholder, not a real coordinate/bias).

## Manual steps outside the repo

### 1. App Store Connect — Routing App Coverage File

Required before **any** App Store submission once BE-335's `Info.plist`
keys are in a build — without it App Store Connect rejects the build
with a routing-app validation error.

1. **Who:** App Manager role or higher on the Balady+ app in App Store
   Connect.
2. **Where:** App Store Connect → **My Apps** → **Balady+** → **App
   Store** tab → select the version being prepared → **Routing App
   Coverage File** section.
3. Upload `ios/Runner/SaudiArabiaCoverage.geojson`.
4. This must be attached to the version **before** it is submitted for
   review, and is re-validated on every build.

### 2. Local testing of the coverage file (Xcode)

1. Xcode → **Product** → **Scheme** → **Edit Scheme…** (the `dev`
   scheme) → **Run** → **Options** tab → **Routing App Coverage File**
   → select `Runner/SaudiArabiaCoverage.geojson`.
2. A `RoutingCoverageFileReference` entry is already committed in
   `ios/Runner.xcodeproj/xcshareddata/xcschemes/dev.xcscheme`. If
   Xcode rewrites that element when you open the scheme editor, commit
   Xcode's version rather than reverting it — the two should stay in
   sync.

### 3. Meta / WhatsApp deliverables (partner communication, not code)

These go to Meta/WhatsApp as the integration owner, not through code
review:

1. **Confirm the scheme spelling in writing.** Meta's own example uses
   `baladimaps`; ours is `baladymaps`. A late rename touches
   `AndroidManifest.xml`, `Info.plist`, and `ExternalMapLinkParser`
   simultaneously, plus requires re-submitting the integration to
   Meta — settle the spelling before Meta ships their side.
2. **Send the scheme spec table** above (search / show-location /
   directions forms and parameters).
3. **Send the Balady+ app icon** in the sizes WhatsApp's menu requests,
   with the menu label **"Open in Balady+"** (the brand is Balady+,
   not "Baladi").
4. **Remind Meta that WhatsApp must whitelist `baladymaps`** in its own
   iOS app configuration (`LSApplicationQueriesSchemes`) — without
   that entry on WhatsApp's side, the menu item will not appear on
   iOS even though our scheme is registered.
5. **Confirm Android works** only after it has been verified on a real
   WhatsApp build (see next section) — don't send this confirmation
   based on code review alone.

### 4. Android verification on real WhatsApp

1. Install a build containing this change.
2. Test on two devices: one **with** Google Maps installed, one
   **without**.
3. In WhatsApp: open a shared location message, tap a contact's
   address, and request directions to a shared location.
4. Expect the system chooser to list **Balady+** alongside other map
   apps.
5. Select Balady+ and confirm: the location card / search results open
   correctly, and no "no internet" toast appears (that toast is the
   symptom of the bug this task fixes).
6. Smoke-test the underlying `geo:`/`baladymaps://` handling directly
   with adb, without going through WhatsApp:

   ```bash
   adb shell am start -a android.intent.action.VIEW -d "geo:24.7136,46.6753"
   adb shell am start -a android.intent.action.VIEW -d "geo:0,0?q=%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%B6"
   adb shell am start -a android.intent.action.VIEW -d "baladymaps://?daddr=24.6877,46.7219&mode=walking"
   ```

### 5. iOS verification of Apple Maps / Find My

A **physical device is required** — the Simulator does not reliably
offer third-party routing apps in these menus.

1. Build via Xcode with the coverage file set (see step 2 above).
2. **Find My:** open a person or device → the transport row → confirm
   **"Open in Balady+"** appears.
3. **Apple Maps:** build a route to a destination inside Saudi Arabia
   → open the route options / "more apps" list → confirm Balady+
   appears.
4. Build a route to a destination **outside** the coverage polygon and
   confirm Balady+ does **not** appear there.
5. Test the `baladymaps://` scheme forms directly with simctl:

   ```bash
   xcrun simctl openurl booted "baladymaps://?ll=24.7136,46.6753&label=Test&z=14"
   ```

### 6. Release

The `Info.plist` routing-app registration only takes effect for users
once it ships in a released build — a TestFlight build is sufficient
for QA to verify the manual steps above, but the "appears in Apple
Maps / Find My" behavior will not reach production users until the App
Store release goes out with the coverage file attached (step 1).

## Open question

**Fallback when Balady+ is not installed.** Neither BE-334 nor this
epic decides whether a `baladymaps://` link (or a WhatsApp/Meta
integration hitting it) should fall back to a universal link or to an
App Store listing when the app isn't present. Flag this for product
and Meta before the partner integration goes live — the scheme itself
gives no signal either way if the app is missing.

## Regression QA matrix

These existing deep-link paths must keep working unchanged, since the
new branch sits ahead of them in `openAppLink`:

| Existing link type | Example | Expected |
| --- | --- | --- |
| Legacy share link (`q=lat,lon`) | `https://plus.balady.gov.sa/#/poi-map?q=24.7,46.6` | Opens the point as before (generic parser, untouched) |
| Short link | `https://go.balady.gov.sa/abc123` | Still resolves through `_handleShortLink` |
| Universal links | app-associated `https://` links | Still handled by `AppLinks`/existing universal-link path |
| Insider / Firebase push deep links | in-app push payload links | Still handled by their existing handlers |

## Gotchas

- `geo:` URIs are opaque to Android — a `geo:lat,lng` link is a single
  path segment, indistinguishable by shape from a short link. The new
  parser branch **must stay above** short-link detection in
  `openAppLink`; if it's moved below, `geo:` links regress to the
  original "no internet" toast bug.
- Never call `Uri.decodeFull` on these external links. `uri.queryParameters`
  already decodes once; a second decode corrupts Arabic labels that
  contain their own percent-encoded punctuation (e.g. a label
  containing `%26` or `%2C`).
- The coverage polygon (`SaudiArabiaCoverage.geojson`) is deliberately
  coarse. Apple only uses it to decide whether to **offer** Balady+ in
  a routing-apps list for a given destination — it is not a precision
  service-area boundary, so a generous margin around the Kingdom's
  borders is fine and preferred over rejecting legitimate near-border
  destinations.
