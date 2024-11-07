import 'package:flutter/material.dart';

class BaladyTempPalette extends ThemeExtension<BaladyTempPalette> {
  final Color lightAccent;

  const BaladyTempPalette({
    required this.lightAccent,
  });

  @override
  ThemeExtension<BaladyTempPalette> copyWith() => BaladyTempPalette(
        lightAccent: lightAccent,
      );

  @override
  ThemeExtension<BaladyTempPalette> lerp(BaladyTempPalette? other, double t) {
    if (other == null) {
      return this;
    }
    return BaladyTempPalette(
      lightAccent: Color.lerp(lightAccent, other.lightAccent, t)!,
    );
  }

  factory BaladyTempPalette.palette() => const BaladyTempPalette(
        lightAccent: Color(0xff1FA9A7),
      );
}
