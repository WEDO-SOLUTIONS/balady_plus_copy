import 'package:flutter/material.dart';

class BaladyTempPalette extends ThemeExtension<BaladyTempPalette> {
  final Color onAccent;
  final Color accentDefault;

  const BaladyTempPalette({
    required this.onAccent,
    required this.accentDefault,
  });

  @override
  ThemeExtension<BaladyTempPalette> copyWith() => BaladyTempPalette(
        accentDefault: accentDefault,
        onAccent: onAccent,
      );

  @override
  ThemeExtension<BaladyTempPalette> lerp(BaladyTempPalette? other, double t) {
    if (other == null) {
      return this;
    }
    return BaladyTempPalette(
      accentDefault: Color.lerp(accentDefault, other.accentDefault, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
    );
  }

  factory BaladyTempPalette.palette() => const BaladyTempPalette(
        onAccent: Colors.white,
        accentDefault: Color(0xff1FA9A7),
      );
}
