
## Special Theme Manager

This document describes the architecture of the special theme modes mechanism that controls
application theming and dashboard variations based on calendar and geographic conditions.

The main goal is to centralize all logic that defines “special modes” (National Day, Ramadan, Mekkah),
their priorities and impact on the UI, so that different teams (client, design, product, backend) understand
how it works and where to plug in new modes.

---

## 1. Terms and goals

- **Special Theme Mode** – a logical display mode applied on top of the base light theme.
  It affects at the same time:
  - the selected color palette (via `BaladyAppThemes.*`),
  - the selected dashboard variant (layout, banners, background, etc.),
  - potentially additional special screens (splash / intro).

- **Special Theme Manager** – a combination of an enum, a provider and priority rules that:
  - determine which `SpecialThemeMode` is currently active,
  - encapsulate priority rules between modes,
  - provide a single interface for the rest of the app.

Goals:

- **Single source of truth**: the code does not contain scattered boolean flags like `isNationalDay`, `isRamadan`, `isNearMekkah`.
  Instead there is a single `SpecialThemeMode`.
- **Extensibility**: adding a new special mode should not require rewriting the whole UI; it should be limited to
  updating `SpecialThemeMode` and a few integration points (theme, dashboard, splash).
- **Clear overlap rules**: when several conditions are true at the same time (e.g. Ramadan
  and being near Mekkah), the behavior is unambiguous.

---

## 2. SpecialThemeMode enum

Base enum representing the current mode:

```dart
enum SpecialThemeMode {
  base,
  nationalDay,
  foundationDay,
  mekkahBase,
  ramadan,
}
```

Semantic meaning:

- `base` – default application mode, original light theme, default dashboard.
- `nationalDay` – existing Saudi National Day mode: dedicated palette, decorated dashboard and splash (kept for backward compatibility and future use).
- `foundationDay` – Foundation Day theme (February 22, 2026).
- `mekkahBase` – location-based “religion” theme for all users currently located in Makkah, used as a base Makkah-style theme.
- `ramadan` – **Makkah seasonal theme**, used only for users in Makkah during special seasons:
  - Ramadan seasonal window (February 17 – March 20, 2026),
  - Hajj seasonal window (May 24 – May 29, 2026).

`SpecialThemeMode` **does not know by itself** when it should be enabled – that is the responsibility of providers.

---

## 3. Signal sources (feature providers)

Special Theme Manager relies on several independent feature providers, each responsible for its own domain.
All of them return `bool` and are used only as inputs to `specialThemeModeProvider`.

1. **Saudi National Day**
   - File: `mapness/lib/features/special_themes/modes/saudi_national_day/saudi_national_day.dart`
   - Provider: `saudiNationalDayProvider : bool`
   - Logic:
     - determines whether the current date is within the Saudi National Day window
       (`startDate` / `endDate` in the feature);
     - has a debug override (`saudiNationalDayDebugProvider`) that can force `true` regardless of the actual date;
     - updates on a timer (every 15 minutes) within a reasonable window around the event.

2. **Foundation Day**
   - File: `mapness/lib/features/special_themes/modes/foundation_day/foundation_day.dart`
   - Provider: `foundationDayProvider : bool`
   - Logic:
     - returns `true` only when the local date equals **February 22** of the current year;
     - does not depend on location.

3. **Mekkah base theme** (location-based)
   - File: `mapness/lib/features/special_themes/modes/mekkah_base/mekkah_base_theme.dart`
   - Provider: `mekkahBaseThemeProvider : bool`
   - Source: `locationProvider` (current user coordinates).
   - Logic:
     - uses Haversine distance between current location and Makkah coordinates
       (`_mekkahLat = 21.3891`, `_mekkahLon = 39.8579`);
     - returns `true` if the user is within `_mekkahRadiusKm = 25.0` km of Makkah.

4. **Ramadan seasonal window**
   - File: `mapness/lib/features/special_themes/modes/ramadan/ramadan_season.dart`
   - Provider: `ramadanSeasonProvider : bool`
   - Logic:
     - compares today’s local date (without time) to the configured Ramadan window
       for **2026-02-17 – 2026-03-20**;
     - returns `true` when today is within that window (inclusive).

5. **Hajj seasonal window**
   - File: `mapness/lib/features/special_themes/modes/ramadan/hajj_season.dart`
   - Provider: `hajjSeasonProvider : bool`
   - Logic:
     - compares today’s local date to the configured Hajj window
       for **2026-05-24 – 2026-05-29** (with the “one day before” rule baked into dates);
     - returns `true` when today is within that window (inclusive).

Each of these providers **does not change UI or theme by itself** – they only supply facts about the world
to the Special Theme Manager layer.

---

## 4. Central provider: specialThemeModeProvider

The main entry point for the rest of the application is a provider that returns the current `SpecialThemeMode`.

Responsibilities:

- read all necessary signal providers (`saudiNationalDayProvider`, `foundationDayProvider`,
  `mekkahBaseThemeProvider`, `ramadanSeasonProvider`, `hajjSeasonProvider`);
- apply priority rules (see section 5);
- optionally respect a **debug override** (see section 9);
- return a concrete `SpecialThemeMode`.

Current implementation (simplified, but production-aligned):

```dart
@riverpod
class SpecialThemeModeDebugOverride extends _$SpecialThemeModeDebugOverride {
  @override
  SpecialThemeMode? build() => null;

  void setOverride(SpecialThemeMode? mode) {
    state = mode;
  }

  void clear() {
    state = null;
  }
}

@riverpod
SpecialThemeMode specialThemeMode(SpecialThemeModeRef ref) {
  final debugOverride = ref.watch(specialThemeModeDebugOverrideProvider);
  if (debugOverride != null) {
    return debugOverride;
  }

  final isNationalDay = ref.watch(saudiNationalDayProvider);
  final isFoundationDay = ref.watch(foundationDayProvider);
  final isMekkahBase = ref.watch(mekkahBaseThemeProvider);
  final isRamadanSeason = ref.watch(ramadanSeasonProvider);
  final isHajjSeason = ref.watch(hajjSeasonProvider);

  // 1. Makkah seasonal Ramadan/Hajj
  if (isMekkahBase && (isRamadanSeason || isHajjSeason)) {
    return SpecialThemeMode.ramadan;
  }

  // 2. Makkah base
  if (isMekkahBase) {
    return SpecialThemeMode.mekkahBase;
  }

  // 3. Foundation Day (applies globally, regardless of location)
  if (isFoundationDay) {
    return SpecialThemeMode.foundationDay;
  }

  // 4. Saudi National Day (existing logic)
  if (isNationalDay) {
    return SpecialThemeMode.nationalDay;
  }

  // 5. Base
  return SpecialThemeMode.base;
}
```

The rest of the app **should not directly combine** `isNationalDay`, `isRamadanSeason`, `isMekkahBase`, etc. – it
should rely on `specialThemeModeProvider` and its contract.

---

## 5. Mode priority rules

Since modes can overlap in time and conditions, it is important to define priorities explicitly.

Updated agreement (subject to change based on product requirements):

1. **Makkah seasonal Ramadan/Hajj > Makkah base > Foundation Day > National Day > Base**

Interpretation:

- If the user is in Makkah **and** the current date is within one of the seasonal windows
  (Ramadan or Hajj, with one-day pre-start for each), `SpecialThemeMode.ramadan` is active.
- Else, if the user is in Makkah but outside these seasonal windows, `SpecialThemeMode.mekkahBase` is active
  (Makkah “religion” theme is always on for users in Makkah).
- Else, if it is Foundation Day (February 22, 2026), `SpecialThemeMode.foundationDay` is active for all users,
  regardless of their location.
- Else, if it is Saudi National Day according to the existing feature logic, `SpecialThemeMode.nationalDay` is active.
- In all other cases – `SpecialThemeMode.base`.

All clients of `specialThemeModeProvider` can rely on this rule; if priority changes, this document must be updated.

---

## 6. Relation to themes (BaladyAppThemes.*)

Currently, theme selection in `entry_point.dart` is tied to a boolean National Day flag. After integrating Special Theme Manager,
the logic conceptually looks like this:

```dart
final mode = ref.watch(specialThemeModeProvider);

final theme = switch (mode) {
  SpecialThemeMode.none        => BaladyAppThemes.light,
  SpecialThemeMode.nationalDay => BaladyAppThemes.saudiDay,
  SpecialThemeMode.ramadan     => BaladyAppThemes.ramadan,
  SpecialThemeMode.mekkah      => BaladyAppThemes.mekkah,
};

AppColorsThemeV3.palette(themes: theme);
```

As a result:

- the color palette of the entire application is determined by **one** `SpecialThemeMode` value;
- all screens that use `context.colors` / `AppColorsThemeV3` automatically adapt to the active mode;
- adding a new mode boils down to:
  - adding a value to `SpecialThemeMode`;
  - updating `specialThemeModeProvider`;
  - adding a corresponding theme to `BaladyAppThemes`.

---

## 7. Dashboard selection by SpecialThemeMode

In addition to recoloring we want different dashboard variants:

- **National Day** – existing dashboard with festive banners and background.
- **Ramadan** – its own dashboard variant (special blocks/cards) + its own palette.
- **Mekkah** – a dedicated dashboard tailored to the "I am near Mekkah" scenario.
- **None** – the default base dashboard.

Recommended approach – introduce a separate “host” widget that chooses a concrete dashboard based on the mode:

```dart
class LandingDashboardHost extends ConsumerWidget {
  const LandingDashboardHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(specialThemeModeProvider);

    switch (mode) {
      case SpecialThemeMode.mekkah:
        return const MekkahDashboard();
      case SpecialThemeMode.ramadan:
        return const RamadanDashboard();
      case SpecialThemeMode.nationalDay:
        return const NationalDayDashboard();
      case SpecialThemeMode.none:
      default:
        return const DefaultDashboard();
    }
  }
}
```

Where:

- `DefaultDashboard` – current dashboard in the default mode.
- `NationalDayDashboard` – can either be a separate widget or a wrapper over `DefaultDashboard` with national
  decorations enabled (banners, backgrounds, etc.).
- `RamadanDashboard` and `MekkahDashboard` – separate implementations (they can reuse parts of the existing
  dashboard but structurally are dedicated scenarios).

The important part is that dashboard selection is also based only on `SpecialThemeMode`, not on individual booleans.

---

## 8. Guards and special screens (splash / intro)

The existing `SaudiDaySplashGuard` is tied to `SaudiNationalDay.isNow()` and is responsible only for
displaying the Saudi National Day splash screen.

For other modes, possible options are:

- separate guards (`RamadanSplashGuard`, `MekkahIntroGuard`) that use their respective feature providers;
- or a single `SpecialModeGuard` that reads `specialThemeModeProvider` and decides which splash/intro to show
  based on the current mode.

At the first step it is enough to adapt only theme and dashboard integration; guards can be evolved gradually
without breaking the current National Day behavior.

---

## 9. Debug and testing

To simplify testing and QA workflows, the following debug tools are available in the common debug overlay
(`DebugOverlay` / `DebugSheet`):

- **Saudi National Day debug**
  - Widget: `SaudiNationalDayDebugSwitcher`.
  - Controls `saudiNationalDayDebugProvider` and the global `saudiNationalDayDebugOverride` flag inside
    the Saudi National Day feature.
  - Effect: forces `saudiNationalDayProvider` to return `true` regardless of the real date, which in turn
    may switch `SpecialThemeMode` to `nationalDay` according to the priority rules.

- **Global Special Theme Mode override**
  - Provider: `SpecialThemeModeDebugOverride` (see section 4).
  - Widget: `SpecialThemeDebugPanel` (in `widgets/debug_overlay/special_theme_debug_panel.dart`).
  - Functionality:
    - shows the current effective `SpecialThemeMode` value;
    - shows the raw boolean signals (`saudiNationalDayProvider`, `foundationDayProvider`,
      `mekkahBaseThemeProvider`, `ramadanSeasonProvider`, `hajjSeasonProvider`);
    - allows selecting any `SpecialThemeMode` value from a dropdown – this sets the debug override and
      **forces** `specialThemeModeProvider` to return that value;
    - provides a `Reset` button that clears the override and returns the app to real signals.

Important notes:

- Debug overrides should be used **only in development/testing builds** (e.g. behind `URBI_DEBUG` or similar flags
  for entry to the debug overlay).
- All higher-level integrations (themes, dashboards, guards) read only `specialThemeModeProvider`, therefore
  any change in debug signals or overrides is automatically reflected across the app.

---

## 10. Future extensions

If new modes are introduced in the future (for example, Eid, New Year, city-specific themes), the steps are:

1. Add a new value to `SpecialThemeMode`.
2. Implement a feature provider that determines when this mode should be active.
3. Update `specialThemeModeProvider` to include this signal and priority rules.
4. Add the corresponding palette to `BaladyAppThemes` and update the theme selection mapping.
5. Add or adapt the dashboard for this mode (or switch certain sections inside existing dashboards).
6. If necessary – add guard/intro/splash.

This way the Special Theme Manager architecture remains stable while new modes are added in a controlled
and predictable manner.

