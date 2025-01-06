import 'package:flutter/material.dart';

class BaladyTempPalette extends ThemeExtension<BaladyTempPalette> {
  final Color onAccent;
  final Color accentDefault;
  final Color accentActive;
  final Color backgroundSurface1;
  final Color foregroundSoft;
  final Color foregroundDefault;

  const BaladyTempPalette({
    required this.onAccent,
    required this.accentDefault,
    required this.accentActive,
    required this.backgroundSurface1,
    required this.foregroundSoft,
    required this.foregroundDefault,
  });

  @override
  ThemeExtension<BaladyTempPalette> copyWith() => BaladyTempPalette(
        accentDefault: accentDefault,
        onAccent: onAccent,
        accentActive: accentActive,
        backgroundSurface1: backgroundSurface1,
        foregroundDefault: foregroundDefault,
        foregroundSoft: foregroundSoft,
      );

  @override
  ThemeExtension<BaladyTempPalette> lerp(BaladyTempPalette? other, double t) {
    if (other == null) {
      return this;
    }
    return BaladyTempPalette(
      accentDefault: Color.lerp(accentDefault, other.accentDefault, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentActive: Color.lerp(accentActive, other.accentActive, t)!,
      backgroundSurface1: Color.lerp(backgroundSurface1, other.backgroundSurface1, t)!,
      foregroundSoft: Color.lerp(foregroundSoft, other.foregroundSoft, t)!,
      foregroundDefault: Color.lerp(foregroundDefault, other.foregroundDefault, t)!,
    );
  }

  factory BaladyTempPalette.palette() => const BaladyTempPalette(
        onAccent: Colors.white,
        accentDefault: Color(0xff1FA9A7),
        accentActive: Color(0xFF147674),
        backgroundSurface1: Color(0xFFFFFFFF),
        foregroundSoft: Color(0xFF1B1B1B),
        foregroundDefault: Color(0xFF898989),
      );
}
