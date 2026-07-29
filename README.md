# BE-90 — navigation live updates, screenshots

Branch `feat/BE-90/lock-screen-widgets`. All data comes from throwaway debug drivers that are
removed before merge, so distances and traffic are canned, not from a real route.

## iOS

iPhone 17 Pro / iOS 26 (simulator), `dev` build. Full-screen shots — the widget sits at the
bottom of the lock screen, above the flashlight/camera buttons.

| # | File | Scenario | How to reproduce | What to look at |
|---|------|----------|------------------|-----------------|
| 1 | `01-car-navigating.png` | Car, normal guidance | `-BaladyLADemo` | Maneuver glyph on its tile, "1 km" + street, speedometer 100 with the 110 limit badge, Balady mark. Timeline: travelled part `#F1F1F1`, then accent `#2AB3A9` → `#FFEF03` → `#F63319`. The 24px marker is `assets/icons/makkah/directions.svg` turned 90° clockwise, `#0C3330` fill with a 1px `#249A91` border. Bottom row: three equal columns — time left, arrival time, distance left |
| 2 | `02-car-gps-lost.png` | Car, GPS lost | `-BaladyLADemo -BaladyLADemoGpsLost` | The first row is replaced by the red error/default pill; everything else is unchanged |
| 3 | `03-car-reroute.png` | Car, route rebuild | `-BaladyLADemo -BaladyLADemoReroute` | Green success/default pill |
| 4 | `04-pedestrian-navigating.png` | Walking | `-BaladyLADemo -BaladyLADemoPedestrian` | Dashes instead of traffic: 3×12, 2px gap, radius on top only; travelled ones at 40% opacity; the marker is a 24px accent circle (twice the dash height). No speedometer |
| 5 | `05-car-arabic-rtl.png` | Car, Arabic (RTL) | `-BaladyLADemo -BaladyLADemoArabic` | The whole layout and the timeline mirror (the marker points left), the maneuver glyph does **not** mirror, units read "كم / د" |
| 6 | `06-arrival.png` | Arrival | `-BaladyLADemo -BaladyLADemoArrived` | "You've arrived" + address, two buttons: `Open Balady+` (soft) and `End trip` (error/default). Speedometer and timeline are hidden; there are no buttons while driving |

Not covered by the shots:

- **Dynamic Island** — the expanded view follows the same layout (maneuver + speed + timeline +
  three columns), but this simulator does not render Live Activities in the island at all
  (the pill stays empty). Needs a look on a device.
- **Speeding** (the limit badge fills red) — not emulated by the debug driver; it comes from
  `exceedingMaxSpeedLimitChannel`.
- **Real traffic** — the shots use fixed 45/20/35% shares; on a real route the segments come
  from `traffic.speedColors`.

## Android

Pixel 8a (API 37, dark theme), notification driven by a temporary debug receiver.

| # | File | Scenario | What to look at |
|---|------|----------|-----------------|
| 1 | `android-01-shade-navigating.png` | Shade, normal guidance | Balady icon on the leading edge (drawn by the system), "50 m", "Towards King Fahd Branch Rd", arrival time and time left in the header. Below — the Android 16 Live Update timeline (`Notification.ProgressStyle`) with the same colours as iOS and the same progress marker |
| 2 | `android-02-lockscreen.png` | Lock screen | The same notification, collapsed — Android has no separate lock screen surface |
| 3 | `android-03-shade-gps-lost.png` | GPS lost | "GPS signal lost" replaces the distance (the counterpart of the red pill on iOS) |
| 4 | `android-04-shade-arrival.png` | Arrival | "You've arrived" + "Zira kafe" and two actions: `Open in Balady+` / `End trip` |

Not verified: the status bar chip (promoted ongoing). The platform grants it to foreground
service notifications, and the debug receiver posts the notification directly;
`setRequestPromotedOngoing` is called reflectively on Android 16 QPR1+.
