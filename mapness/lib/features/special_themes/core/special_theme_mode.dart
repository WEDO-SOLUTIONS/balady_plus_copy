import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/founding_day/founding_day_debug.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/features/special_themes/modes/foundation_day/foundation_day.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/mekkah_base_theme.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'special_theme_mode.g.dart';

/// Logical display modes that control global theming and dashboard variants.
///
/// See docs/special_theme_manager.md for detailed semantics.
enum SpecialThemeMode {
  /// Default application mode, original light theme, default dashboard.
  base,

  /// Existing Saudi National Day mode (kept for backward compatibility
  /// and future use).
  nationalDay,

  /// Foundation Day theme (February 22, 2026).
  foundationDay,

  /// Location-based "religion" theme for all users currently located
  /// in Makkah, used as a base Makkah-style theme.
  mekkahBase,

  /// Makkah seasonal theme, used only for users in Makkah during
  /// special seasons (Ramadan / Hajj).
  ramadan,
}

@Riverpod(keepAlive: true)
class FoundationDayDebug extends _$FoundationDayDebug {
  @override
  bool build() => false;

  bool get enabled => state;

  set enabled(bool value) {
    state = value;
    final isEnabled = ref.watch(foundingDayDebugUrbiProvider);
    final notifier = ref.read(foundingDayDebugUrbiProvider.notifier);
    if (value) {
      notifier.enable();
    } else {
      notifier.disable();
    }
  }
}

@Riverpod(keepAlive: true)
class MekkahBaseThemeDebug extends _$MekkahBaseThemeDebug {
  @override
  bool build() => false;

  bool get enabled => state;

  set enabled(bool value) => state = value;
}

@Riverpod(keepAlive: true)
class RamadanSeasonDebug extends _$RamadanSeasonDebug {
  @override
  bool build() => false;

  bool get enabled => state;

  set enabled(bool value) => state = value;
}

@Riverpod(keepAlive: true)
class HajjSeasonDebug extends _$HajjSeasonDebug {
  @override
  bool build() => false;

  bool get enabled => state;

  set enabled(bool value) => state = value;
}

@Riverpod(keepAlive: true)
class LeapDebug extends _$LeapDebug {
  @override
  bool build() => false;

  bool get enabled => state;

  set enabled(bool value) => state = value;
}

/// Debug override for [SpecialThemeMode].
///
/// When `state` is non-null, [specialThemeModeProvider] will return this
/// value instead of computing mode from feature providers. This is used only
/// from debug overlay UI and should not be enabled in production builds.
@riverpod
class SpecialThemeModeDebugOverride extends _$SpecialThemeModeDebugOverride {
  @override
  SpecialThemeMode? build() => null;

  /// The mode forced from the debug overlay, or null when none is forced.
  ///
  /// Deliberately not called `override`: that name shadows the `@override`
  /// annotation for every member declared after it.
  SpecialThemeMode? get forcedMode => state;

  set forcedMode(SpecialThemeMode? mode) {
    state = mode;
  }

  void clear() {
    state = null;
  }
}

/// Central provider that exposes current [SpecialThemeMode].
///
/// Implements the priority rules described in docs/special_theme_manager.md:
///
///   Makkah seasonal Ramadan/Hajj > Makkah base > Foundation Day > National Day > Base
///
/// Remote config from themes_config.json can disable Makkah-related themes.
/// Each theme supports:
///   - `enabled`: theme works by its conditions (location, dates)
///   - `force_enabled`: theme is always active, ignoring all conditions (for testing)
@riverpod
SpecialThemeMode specialThemeMode(Ref ref) {
  final debugOverride = ref.watch(specialThemeModeDebugOverrideProvider);
  if (debugOverride != null) {
    return debugOverride;
  }

  final isNationalDay = ref.watch(saudiNationalDayProvider);

  // Debug flags from UI
  final isFoundationDayDebug = ref.watch(foundationDayDebugProvider);
  final isMekkahBaseDebug = ref.watch(mekkahBaseThemeDebugProvider);
  final isRamadanSeasonDebug = ref.watch(ramadanSeasonDebugProvider);
  final isHajjSeasonDebug = ref.watch(hajjSeasonDebugProvider);

  // Remote config for each theme
  final mekkahConfig = ref.watch(placesActivationMekkahProvider);
  final ramadanConfig = ref.watch(placesActivationRamadanProvider);
  final foundationDayConfig = ref.watch(placesActivationFoundationDayProvider);
  final hajjConfig = ref.watch(placesActivationHajjProvider);

  // Foundation Day: force_enabled OR debug OR (enabled AND conditions met)
  final isFoundationDay =
      foundationDayConfig.forceEnabled ||
      isFoundationDayDebug ||
      (foundationDayConfig.enabled && ref.watch(foundationDayProvider));

  // Ramadan: force_enabled OR (enabled AND in date range) OR debug
  final isRamadanSeason =
      ramadanConfig.forceEnabled || isRamadanSeasonDebug || (ramadanConfig.enabled && _isInDateRange(ramadanConfig));

  // Hajj: force_enabled OR (enabled AND in date range) OR debug
  final isHajjSeason =
      hajjConfig.forceEnabled || isHajjSeasonDebug || (hajjConfig.enabled && _isInDateRange(hajjConfig));

  // Makkah base: force_enabled OR (enabled AND in Makkah area AND in date range) OR debug.
  // Also implicitly enabled when Ramadan/Hajj debug is on (since they require Makkah).
  final isInMakkahArea = ref.watch(mekkahBaseThemeProvider);
  final isMekkahBase =
      mekkahConfig.forceEnabled ||
      isMekkahBaseDebug ||
      isRamadanSeasonDebug ||
      isHajjSeasonDebug ||
      (mekkahConfig.enabled && isInMakkahArea && _isInDateRange(mekkahConfig));

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

bool _isInDateRange(ThemeConfig config) {
  // If no start date, treat as not yet configured
  if (config.startDate == null) {
    return false;
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final start = config.startDate!;

  // Must be on or after start date
  if (today.isBefore(start)) {
    return false;
  }

  // If no end date, theme is active indefinitely after start
  if (config.endDate == null) {
    return true;
  }

  // Check if within end date
  return !today.isAfter(config.endDate!);
}
