import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CityIDs, DefaultColorsTheme, HailColorsTheme, TabukColorsTheme;
import 'package:flutter/material.dart';

class AppColorsTheme {
  static Color primary50 = DefaultColorsTheme.primary50;
  static Color primary100 = DefaultColorsTheme.primary100;
  static Color primary200 = DefaultColorsTheme.primary200;
  static Color primary300 = DefaultColorsTheme.primary300;
  static Color primary700 = DefaultColorsTheme.primary700;

  static void setTheme(String cityId) {
    switch (cityId) {
      case CityIDs.Hail:
        primary50 = HailColorsTheme.primary50;
        primary100 = HailColorsTheme.primary100;
        primary200 = HailColorsTheme.primary200;
        primary300 = HailColorsTheme.primary300;
        primary700 = HailColorsTheme.primary700;
        break;
      case CityIDs.Tabuk:
        primary50 = TabukColorsTheme.primary50;
        primary100 = TabukColorsTheme.primary100;
        primary200 = TabukColorsTheme.primary200;
        primary300 = TabukColorsTheme.primary300;
        primary700 = TabukColorsTheme.primary700;
        break;
      default:
        primary50 = DefaultColorsTheme.primary50;
        primary100 = DefaultColorsTheme.primary100;
        primary200 = DefaultColorsTheme.primary200;
        primary300 = DefaultColorsTheme.primary300;
        primary700 = DefaultColorsTheme.primary700;
    }
  }
}
