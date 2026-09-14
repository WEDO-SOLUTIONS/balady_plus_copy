import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One-time migration utility for converting old splash SharedPreferences keys
/// to the new centralized format.
///
/// **Migration:**
/// - Old key: `is_saudi_day_shown` (boolean)
/// - New key: `theme_splash_shown_nationalDay_{startDate}_{endDate}` (boolean)
///
/// **Usage:**
/// Call [migrateSplashKeys] once during app initialization (e.g., in entry_point.dart).
/// The migration is idempotent and safe to call multiple times.
///
/// **Example:**
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final prefs = await SharedPreferences.getInstance();
///   await migrateSplashKeys(prefs);
///   runApp(MyApp());
/// }
/// ```
class ThemeSplashMigration {
  const ThemeSplashMigration._();

  /// Old SharedPreferences key used by SaudiDaySplashGuard.
  static const String _oldSaudiDayKey = 'is_saudi_day_shown';

  /// Prefix for new theme splash keys.
  static const String _newKeyPrefix = 'theme_splash_shown_';

  /// Migrates old splash SharedPreferences keys to the new format.
  ///
  /// This function:
  /// 1. Checks if the old key `is_saudi_day_shown` exists
  /// 2. If true, creates a new key for the current Saudi National Day activation period
  /// 3. Preserves the old key for safety (can be removed in future release)
  ///
  /// Returns true if migration was performed, false if not needed.
  static Future<bool> migrateSplashKeys(SharedPreferences prefs) async {
    try {
      // Check if old key exists and is true
      final oldValue = prefs.getBool(_oldSaudiDayKey);

      if (oldValue == null || oldValue == false) {
        // Nothing to migrate
        return false;
      }

      // Generate new key for current Saudi National Day period
      final newKey = _generateSaudiDayKey();

      // Check if already migrated
      if (prefs.containsKey(newKey)) {
        logger.log(
          'ThemeSplashMigration: Already migrated (key exists: $newKey)',
        );
        return false;
      }

      // Perform migration
      await prefs.setBool(newKey, true);

      logger.log(
        'ThemeSplashMigration: Migrated $_oldSaudiDayKey -> $newKey',
        logLevel: MapnessLogLevel.info,
      );

      // Keep old key for safety (can be removed in cleanup phase)
      // await prefs.remove(_oldSaudiDayKey);

      return true;
    } catch (e, stackTrace) {
      logger.log(
        'ThemeSplashMigration: Failed to migrate splash keys: $e\n$stackTrace',
        logLevel: MapnessLogLevel.error,
      );
      return false;
    }
  }

  /// Generates the new SharedPreferences key for Saudi National Day.
  ///
  /// Format: `theme_splash_shown_nationalDay_{startDate}_{endDate}`
  /// Example: `theme_splash_shown_nationalDay_2025-09-18_2025-09-27`
  static String _generateSaudiDayKey() {
    final startDate = SaudiNationalDayConfig.startDate;
    final endDate = SaudiNationalDayConfig.endDate;

    final start = _formatDate(startDate);
    final end = _formatDate(endDate);

    return '${_newKeyPrefix}nationalDay_${start}_$end';
  }

  /// Formats a DateTime to ISO 8601 date string (YYYY-MM-DD).
  static String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Cleans up old SharedPreferences keys after successful migration.
  ///
  /// This should only be called in a future release after confirming
  /// the migration was successful for all users.
  ///
  /// **Warning:** This is a destructive operation. Only call after
  /// verifying no rollback is needed.
  static Future<void> cleanupOldKeys(SharedPreferences prefs) async {
    try {
      if (prefs.containsKey(_oldSaudiDayKey)) {
        await prefs.remove(_oldSaudiDayKey);
        logger.log(
          'ThemeSplashMigration: Removed old key $_oldSaudiDayKey',
          logLevel: MapnessLogLevel.info,
        );
      }
    } catch (e, stackTrace) {
      logger.log(
        'ThemeSplashMigration: Failed to cleanup old keys: $e\n$stackTrace',
        logLevel: MapnessLogLevel.error,
      );
    }
  }
}
