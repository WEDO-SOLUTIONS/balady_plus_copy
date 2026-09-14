import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/special_themes/core/theme_splash_config.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_splash_state.g.dart';

/// Provider that manages the "shown" state for themed splash screens.
///
/// Tracks which splash screens have been shown to the user based on the
/// [SplashPersistenceStrategy] configured for each [SpecialThemeMode].
///
/// Example keys in SharedPreferences:
/// - `theme_splash_shown_nationalDay_2025-09-18_2025-09-27` (once per activation period)
/// - `theme_splash_shown_mekkahBase_ever` (once ever)
/// - `theme_splash_shown_ramadan_2026-02-17` (once per day)
@riverpod
class ThemeSplashState extends _$ThemeSplashState {
  static const String _prefsKeyPrefix = 'theme_splash_shown_';

  @override
  Map<SpecialThemeMode, bool> build() {
    // Load all splash shown states from SharedPreferences
    final sharedPrefs = ref.read(sharedPrefsProvider);
    final states = <SpecialThemeMode, bool>{};

    for (final mode in SpecialThemeMode.values) {
      final key = _buildPrefsKey(mode);
      states[mode] = sharedPrefs.getBool(key) ?? false;
    }

    return states;
  }

  /// Checks if splash has been shown for the given theme mode.
  ///
  /// Returns true if splash was already shown (don't show again).
  /// Returns false if splash hasn't been shown yet (should show).
  bool hasShownSplashFor(SpecialThemeMode mode) {
    final config = mode.splashConfig;

    // If strategy is "always", never persist (always show)
    if (config.persistenceStrategy == SplashPersistenceStrategy.always) {
      return false;
    }

    return state[mode] ?? false;
  }

  /// Marks splash as shown for the given theme mode.
  ///
  /// Persists the state to SharedPreferences using a key generated based on
  /// the theme's [SplashPersistenceStrategy].
  void markSplashShown(SpecialThemeMode mode) {
    final key = _buildPrefsKey(mode);
    ref.read(sharedPrefsProvider).setBool(key, true);
    state = {...state, mode: true};
  }

  /// Resets splash state for the given theme mode (debug/testing only).
  ///
  /// This allows re-showing splash screens that have already been shown.
  /// Useful for testing splash screens without restarting the app.
  void resetSplashFor(SpecialThemeMode mode) {
    final key = _buildPrefsKey(mode);
    ref.read(sharedPrefsProvider).remove(key);
    state = {...state, mode: false};
  }

  /// Builds a unique SharedPreferences key for the given theme mode.
  ///
  /// The key format depends on the theme's [SplashPersistenceStrategy]:
  /// - onceEver: `theme_splash_shown_{mode}_ever`
  /// - oncePerActivationPeriod: `theme_splash_shown_{mode}_{startDate}_{endDate}`
  /// - oncePerDay: `theme_splash_shown_{mode}_{year}_{month}_{day}`
  /// - always: `theme_splash_shown_{mode}_never` (never persists)
  String _buildPrefsKey(SpecialThemeMode mode) {
    final config = mode.splashConfig;

    switch (config.persistenceStrategy) {
      case SplashPersistenceStrategy.onceEver:
        return '$_prefsKeyPrefix${mode.name}_ever';

      case SplashPersistenceStrategy.oncePerActivationPeriod:
        final themeConfig = _getThemeConfig(mode);
        final period = _formatActivationPeriod(themeConfig);
        return '$_prefsKeyPrefix${mode.name}_$period';

      case SplashPersistenceStrategy.oncePerDay:
        final today = DateTime.now();
        final dateKey = '${today.year}_${today.month}_${today.day}';
        return '$_prefsKeyPrefix${mode.name}_$dateKey';

      case SplashPersistenceStrategy.always:
        // Never persists - using a unique key that resets each time
        return '$_prefsKeyPrefix${mode.name}_never';
    }
  }

  /// Retrieves the [ThemeConfig] for the given theme mode.
  ///
  /// This is used to extract activation period dates for generating
  /// unique SharedPreferences keys.
  ThemeConfig _getThemeConfig(SpecialThemeMode mode) {
    switch (mode) {
      case SpecialThemeMode.ramadan:
        return ref.read(placesActivationRamadanProvider);

      case SpecialThemeMode.foundationDay:
        return ref.read(placesActivationFoundationDayProvider);

      case SpecialThemeMode.mekkahBase:
        return ref.read(placesActivationMekkahProvider);

      case SpecialThemeMode.nationalDay:
        // Saudi National Day uses hardcoded dates in provider
        // Return config with dates from SaudiNationalDayConfig
        return ThemeConfig(
          enabled: true,
          forceEnabled: false,
          startDate: SaudiNationalDayConfig.startDate,
          endDate: SaudiNationalDayConfig.endDate,
        );

      case SpecialThemeMode.base:
        return ThemeConfig.disabled;
    }
  }

  /// Formats the activation period as a string for use in SharedPreferences keys.
  ///
  /// Format: `{startDate}_{endDate}` (ISO 8601 format)
  /// Example: `2025-09-18_2025-09-27`
  ///
  /// If dates are not available, returns `default`.
  String _formatActivationPeriod(ThemeConfig config) {
    if (config.startDate != null && config.endDate != null) {
      final start = _formatDate(config.startDate!);
      final end = _formatDate(config.endDate!);
      return '${start}_$end';
    }
    return 'default';
  }

  /// Formats a DateTime to ISO 8601 date string (YYYY-MM-DD).
  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
