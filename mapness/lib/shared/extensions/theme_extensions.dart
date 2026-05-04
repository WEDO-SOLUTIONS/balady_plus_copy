import 'package:flutter/material.dart';

extension ThemeDataX on ThemeData {
  ThemeData overrideExtension<T extends ThemeExtension<T>>(T value) =>
      copyWith(extensions: {...extensions, T: value}.values);
}
