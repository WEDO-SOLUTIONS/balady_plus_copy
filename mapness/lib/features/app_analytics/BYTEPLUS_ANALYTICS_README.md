# BytePlus RangersAppLog — Analytics Integration

## Overview

All analytics events are sent to **both** Insider and BytePlus simultaneously via a composite pattern. You never call either SDK directly — you call `AppAnalytics` via Riverpod and every backend receives the event automatically.

---

## Architecture

```
AppAnalytics (Riverpod provider)
  └── _CompositeAnalytics
        ├── AppAnalyticsInsiderImpl   ← Insider SDK
        └── AppAnalyticsBytePlusImpl  ← BytePlus RangersAppLog SDK
```

**Key files:**

| File | Purpose |
|------|---------|
| `app_analytics_repository.dart` | Abstract interface — all event method signatures |
| `data/app_analytics_byteplus_impl.dart` | BytePlus implementation |
| `data/app_analytics_insider_impl.dart` | Insider implementation |
| `app_analytics.dart` | Riverpod provider + composite fan-out |
| `lib/entry_point.dart` | SDK initialization (`setupMapness`) + `MapnessBytePlusObserver` |

---

## SDK Initialization

BytePlus is initialized **before any widget is built**, inside `setupMapness()` in `entry_point.dart`.

```dart
// entry_point.dart (already done — do not modify)
RangersApplogFlutterPlugin.initRangersAppLog(
  appId,
  channel,
  false,         // enableAb
  false,         // enableEncrypt
  !isProduction, // enableLog: true on stg/dev, false on prod
  null,          // host: null = default BytePlus endpoint
);
```

The App ID and channel come from environment variables loaded per flavor:

| Flavor | File | BYTEPLUS_APP_ID | BYTEPLUS_CHANNEL |
|--------|------|-----------------|-----------------|
| stg / dev | `.env.stg` / `.env.dev` | STG app ID | `TestFlight` |
| pre / prod | `.env.pre` / `.env.prod` | Prod app ID | `AppStore` |

> **Action required:** Replace `TODO_STG_APP_ID` / `TODO_PROD_APP_ID` in the `.env` files with real IDs from the BytePlus console → App Management.

### Page-view tracking (automatic)

`MapnessBytePlusObserver` is registered in `MaterialApp.navigatorObservers`. It automatically tracks every route push/pop as a page view in BytePlus — no code needed per screen.

---

## How to Send Events

### 1. Get the provider

```dart
// In a widget or another provider:
final analytics = ref.read(appAnalyticsProvider.notifier);
```

### 2. Call an event method

```dart
// Simple event (no params)
analytics.onboardingFlowStarted();

// Event with params
analytics.navigationStarted(
  originLocation: 'Riyadh',
  destinationLocation: 'Jeddah',
  destinationCity: 'Jeddah',
  originCity: 'Riyadh',
  estimateTime: 120,        // seconds
  estimateDistance: 980.5,  // kilometers
);
```

The call fans out to both Insider and BytePlus. You never import either SDK in your feature code.

---

## Available Events

| Method | BytePlus event name | Key parameters |
|--------|-------------------|----------------|
| `onboardingFlowStarted()` | `onboarding_flow_started` | — |
| `onboardingFlowSkipped()` | `onboarding_flow_skipped` | — |
| `onboardingFlowCompleted()` | `onboarding_stories_completed` | — |
| `navigationSearch(...)` | `navigation_search` | keyword, origin, destination, results_found, result_count |
| `navigationStarted(...)` | `navigation_started` | origin, destination, cities, estimated_time, estimated_distance |
| `navigationHalfWay(...)` | `navigation_half_way` | origin, destination, cities, time_to_midway, midway_point |
| `navigationCompleted(...)` | `navigation_completed` | origin, destination, cities, time_to_reach |
| `userMovementDetected(...)` | `user_movement_detected` | origin, destination, same_city |
| `isNavigationUser(...)` | `is_navigation_user` | is_navigation_user (0/1) |
| `categorySelected(...)` | `category_selected` | category |
| `serviceSectionVisited()` | `service_section_visited` | — |
| `quickActionSelected(...)` | `quick_action_used` | action |
| `carPlayConnected()` | `carplay_connected` | status, timestamp |
| `poiContributionUsed(...)` | `contribution_used` | contribution_type, source |
| `deviceTypeDetected()` | `device_type_detected` | device_type, platform |
| `networkConnectionType(...)` | `network_type_detected` | connection_type |
| `transportModeSelected(...)` | `transport_mode_selected` | mode |
| `setUserInfo(...)` | profile set (not an event) | email, locale, device_id, device_os, app_version |

---

## Adding a New Event

**Step 1** — Add the method signature to `app_analytics_repository.dart`:

```dart
void myNewEvent({required String param});
```

**Step 2** — Implement in `app_analytics_byteplus_impl.dart`:

```dart
@override
void myNewEvent({required String param}) {
  RangersApplog.onEventV3('my_new_event', {'param': param});
}
```

**Step 3** — Implement in `app_analytics_insider_impl.dart`:

```dart
@override
void myNewEvent({required String param}) {
  FlutterInsider.Instance.tagEvent('my_new_event')
      .addParameterWithString('param', param)
      .build();
}
```

**Step 4** — Add the fan-out in `app_analytics.dart` inside `_CompositeAnalytics`:

```dart
@override
void myNewEvent({required String param}) {
  for (final impl in _implementations) {
    impl.myNewEvent(param: param);
  }
}
```

**Step 5** — Call it from your feature:

```dart
ref.read(appAnalyticsProvider.notifier).myNewEvent(param: 'value');
```

---

## Console Access

| | |
|---|---|
| **URL** | https://balady.finder.bytepluses.com/ |
| **Admin account** | `admin` |
| **Initial password** | `dP#YpGyvkm71Qoob8%iP` |

After login, click **DataFinder** (top-right Product Service panel) to access dashboards and analytics.

### Finding the App ID

Go to **Project Center → Details** in the top navigation. The App List shows all registered apps with their App IDs:

| App | App ID | Status |
|-----|--------|--------|
| Balady Staging Test APP | `10000000` | Data connected (use for stg/dev) |
| BaladyTest | `10000001` | Data not connected (test app) |

Put the correct App ID in your `.env` files:
```
# .env.stg / .env.dev
BYTEPLUS_APP_ID=10000000

# .env.pre / .env.prod
BYTEPLUS_APP_ID=<prod App ID from console>
```

### Verifying Events

After triggering events in the app, wait ~15 minutes then check:

1. Console → **DataFinder** → **Analysis Tools → Event Analysis** → search event name
2. Per-user events: **Analysis Tools → User Details** → enter UUID → check `user`, `header`, `events` sections
3. If events don't appear: verify the App ID in your `.env` file is correct

SDK logs are enabled automatically on stg/dev flavors — check Xcode console for `[BytePlus]` prefixed output.

### Official Docs

- Flutter SDK integration: https://docs.byteplus.com/en/docs/data-intelligence/Flutter_SDK_integration
- Flutter SDK API reference: https://docs.byteplus.com/en/docs/data-intelligence/Flutter_SDK_API_Description

---

## iOS Pod Version Notes

RangersAppLog ships two incompatible native builds. The Podfile auto-selects based on the active Xcode scheme:

| Xcode scheme | Pod version | Use case |
|--------------|-------------|----------|
| `*-stg` / `*-dev` | `6.17.7-iOS26-xc-rc2` | iOS Simulator (arm64 slice included) |
| `*-pre` / `*-prod` | `>= 6.17.3` | Real device (BytePlus SG region) |

This is transparent — `pod install` handles it automatically.
