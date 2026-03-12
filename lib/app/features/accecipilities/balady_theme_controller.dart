import 'package:flutter/foundation.dart';
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
  static const String _darkModeKey = 'balady_dark_mode';

  /// Internal state for dark mode
  bool _isDarkMode = false;

  /// Public getter to expose theme state safely
  bool get isDarkMode => _isDarkMode;

  /// Constructor
  /// Automatically loads saved theme settings
  BaladyThemeNotifier() {
    _loadThemePreference();
  }

  /// -------------------------------------------------------------------------
  /// 🔄 Load Theme Preference
  /// -------------------------------------------------------------------------
  /// Retrieves the persisted theme mode from local storage.
  /// Defaults to light mode if no value is found.
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      notifyListeners();
    } catch (error) {
      _logError('loading theme preference', error);
    }
  }

  /// -------------------------------------------------------------------------
  /// 💾 Save Theme Preference
  /// -------------------------------------------------------------------------
  /// Persists the current theme mode locally.
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, _isDarkMode);
    } catch (error) {
      _logError('saving theme preference', error);
    }
  }

  /// -------------------------------------------------------------------------
  /// 🌗 Toggle Theme Mode
  /// -------------------------------------------------------------------------
  /// Updates the theme mode and persists the change.
  void toggleTheme(bool enableDarkMode) {
    if (_isDarkMode == enableDarkMode) return;

    _isDarkMode = enableDarkMode;
    _saveThemePreference();
    notifyListeners();
  }

  /// -------------------------------------------------------------------------
  /// ♻️ Reset Theme Settings
  /// -------------------------------------------------------------------------
  /// Resets the theme mode to default (Light Mode).
  void resetTheme() {
    _isDarkMode = false;
    _saveThemePreference();
    notifyListeners();
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
