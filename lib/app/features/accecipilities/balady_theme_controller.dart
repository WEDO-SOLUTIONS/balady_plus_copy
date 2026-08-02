import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ---------------------------------------------------------------------------
/// 🌙 BaladyThemeNotifier
/// ---------------------------------------------------------------------------
/// Responsible for managing and persisting the application's theme mode
/// (Light / Dark).
///
/// This class:
/// - Loads the saved theme preference on initialization
/// - Persists user changes using SharedPreferences
/// - Notifies listeners when the theme changes
/// ---------------------------------------------------------------------------
class BaladyThemeNotifier extends ChangeNotifier {
  /// Key used to store the theme mode in SharedPreferences
  static const String _themeModeKey = 'balady_theme_mode';
  // The default theme of the user's device.
  ThemeMode _themeMode = ThemeMode.system;

  /// Set while something transient forces a theme — driving through a tunnel, for
  /// instance. Wins over [_themeMode] but is never persisted, so the user's own
  /// choice is still there once the override is lifted (or the app is restarted).
  ThemeMode? _transientThemeMode;

  ThemeMode get themeMode => _transientThemeMode ?? _themeMode;

  /// The user's persisted preference, ignoring any transient override.
  ThemeMode get preferredThemeMode => _themeMode;

  // For backward compatibility or internal checks if needed
  // ... inside BaladyThemeNotifier class

  // Updated getter to correctly reflect the current active state
  bool get isDarkMode {
    final mode = themeMode;
    if (mode == ThemeMode.system) {
      // Check the device's actual brightness
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return mode == ThemeMode.dark;
  }

  /// Forces [mode] without touching the persisted preference. Pass `null` to drop the
  /// override and fall back to whatever the user picked.
  void setTransientThemeMode(ThemeMode? mode) {
    if (_transientThemeMode == mode) return;

    _transientThemeMode = mode;
    notifyListeners();
  }

  /// Constructor
  /// Automatically loads saved theme settings
  // BaladyThemeNotifier() {
  //   init();
  // }

  /// -------------------------------------------------------------------------
  /// 🔄 Load Theme Preference
  /// -------------------------------------------------------------------------
  /// Retrieves the persisted theme mode from local storage.
  /// Defaults to light mode if no value is found.
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString(_themeModeKey);

      if (savedMode != null) {
        _themeMode = ThemeMode.values.firstWhere((e) => e.name == savedMode, orElse: () => ThemeMode.system);
      } else {
        // Migration: check for the old boolean key
        final oldDarkMode = prefs.getBool('balady_dark_mode');
        if (oldDarkMode != null) {
          _themeMode = oldDarkMode ? ThemeMode.dark : ThemeMode.light;
          // Save it in the new format immediately
          await prefs.setString(_themeModeKey, _themeMode.name);
        } else {
          _themeMode = ThemeMode.system;
        }
      }
      notifyListeners();
    } catch (error) {
      _logError('loading theme preference', error);
    }
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.name);
    } catch (error) {
      _logError('saving theme preference', error);
    }
  }

  /// -------------------------------------------------------------------------
  /// 💾 Save Theme Preference
  /// -------------------------------------------------------------------------
  /// Persists the current theme mode locally.
  // Future<void> _saveThemePreference() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setBool(_darkModeKey, _isDarkMode);
  //   } catch (error) {
  //     _logError('saving theme preference', error);
  //   }
  // }

  /// -------------------------------------------------------------------------
  /// 🌗 Toggle Theme Mode
  /// -------------------------------------------------------------------------
  /// Updates the theme mode and persists the change.
  void toggleTheme(bool enableDarkMode) {
    updateThemeMode(enableDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  /// -------------------------------------------------------------------------
  /// ♻️ Reset Theme Settings
  /// -------------------------------------------------------------------------
  /// Resets the theme mode to default (Light Mode).
  void resetTheme() {
    updateThemeMode(ThemeMode.system);
  }

  /// -------------------------------------------------------------------------
  /// 🐞 Debug Logger
  /// -------------------------------------------------------------------------
  /// Logs errors only in debug mode to avoid noise in production.
  void _logError(String action, Object error) {
    if (kDebugMode) {
      debugPrint('BaladyThemeNotifier error while $action: $error');
    }
  }
}
