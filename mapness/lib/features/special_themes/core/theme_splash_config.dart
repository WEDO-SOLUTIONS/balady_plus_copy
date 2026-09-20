import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/features/stories/models/story_types.dart';

/// Strategy for persisting splash screen state.
///
/// Determines how often a themed splash screen should be shown to the user.
enum SplashPersistenceStrategy {
  /// Show splash once ever, persist forever.
  ///
  /// Example: User sees splash once in their lifetime, never again.
  onceEver,

  /// Show splash once per theme activation period.
  ///
  /// Example: During Ramadan 2026 (Feb 17 - Mar 20), show splash only once.
  /// Next year during Ramadan 2027, show splash again.
  ///
  /// Uses dates from ThemeConfig (activation_periods) to generate unique keys.
  oncePerActivationPeriod,

  /// Show splash once per day during theme period.
  ///
  /// Example: Show splash every day at first app launch during the theme's active period.
  oncePerDay,

  /// Always show splash (for testing/debug).
  ///
  /// Example: Show splash every time the theme becomes active.
  always,
}

/// Configuration for themed splash screens.
///
/// Each [SpecialThemeMode] can have an associated splash screen configuration
/// that defines:
/// - Whether splash is enabled
/// - Which [StoryTypes] to display
/// - How to persist the "shown" state via [SplashPersistenceStrategy]
class ThemeSplashConfig {
  /// Whether splash screen is enabled for this theme.
  final bool enabled;

  /// The story type to display when splash is shown.
  final StoryTypes storyType;

  /// Strategy for persisting splash shown state.
  final SplashPersistenceStrategy persistenceStrategy;

  const ThemeSplashConfig({
    required this.enabled,
    required this.storyType,
    this.persistenceStrategy = SplashPersistenceStrategy.oncePerActivationPeriod,
  });

  /// Disabled splash configuration (no splash shown).
  static const disabled = ThemeSplashConfig(
    enabled: false,
    storyType: StoryTypes.network, // Dummy value
    persistenceStrategy: SplashPersistenceStrategy.onceEver,
  );
}

/// Extension that associates each [SpecialThemeMode] with its splash configuration.
///
/// This centralizes the logic for determining which themes have splash screens
/// and how they should behave.
extension SpecialThemeModeSplashExtension on SpecialThemeMode {
  /// Returns the splash configuration for this theme mode.
  ///
  /// If a theme has [ThemeSplashConfig.enabled] = true, the splash guard will
  /// show the associated story when the theme becomes active.
  ThemeSplashConfig get splashConfig {
    switch (this) {
      case SpecialThemeMode.nationalDay:
        // Saudi National Day: show the splash on every app open while the
        // theme is active. `always` never persists a "shown" flag, so the
        // guard re-shows it on each cold start.
        return const ThemeSplashConfig(
          enabled: true,
          storyType: StoryTypes.saudiDay,
          persistenceStrategy: SplashPersistenceStrategy.always,
        );

      case SpecialThemeMode.mekkahBase:
        // Makkah Base: Show splash once when user enters Makkah zone
        return const ThemeSplashConfig(
          enabled: true,
          storyType: StoryTypes.mekkahBase,
          persistenceStrategy: SplashPersistenceStrategy.oncePerActivationPeriod,
        );

      // Foundation Day, Ramadan - disabled for now (can be easily enabled in future)
      case SpecialThemeMode.foundationDay:
      case SpecialThemeMode.ramadan:
      case SpecialThemeMode.base:
        return ThemeSplashConfig.disabled;
    }
  }
}
