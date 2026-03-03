import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeController extends ChangeNotifier {
  BaladyAppThemes _currentTheme = BaladyAppThemes.light;
  bool _initialized = true;

  BaladyAppThemes get currentTheme => _currentTheme;
  bool get isInitialized => _initialized;

  Future<void> init() async {
    _initialized = true;
    notifyListeners();
  }

  Future<void> setTheme(BaladyAppThemes theme) async {
    _currentTheme = theme;
    notifyListeners();
  }

  SystemUiOverlayStyle get systemOverlayStyle => switch (_currentTheme) {
        BaladyAppThemes.light => SystemUiOverlayStyle.dark,
        BaladyAppThemes.dark => SystemUiOverlayStyle.light,
        BaladyAppThemes.saudiDay => SystemUiOverlayStyle.dark,
        BaladyAppThemes.foundationDay => SystemUiOverlayStyle.dark,
        BaladyAppThemes.mekkah => SystemUiOverlayStyle.light,
      };

  AppColorsThemeV3 get colors => switch (_currentTheme) {
        BaladyAppThemes.light => AppColorsThemeV3.palette(themes: BaladyAppThemes.light),
        BaladyAppThemes.dark => AppColorsThemeV3.palette(themes: BaladyAppThemes.dark),
        BaladyAppThemes.saudiDay => AppColorsThemeV3.palette(themes: BaladyAppThemes.saudiDay),
        BaladyAppThemes.foundationDay => AppColorsThemeV3.palette(themes: BaladyAppThemes.foundationDay),
        BaladyAppThemes.mekkah => AppColorsThemeV3.palette(themes: BaladyAppThemes.mekkah),
      };
}
