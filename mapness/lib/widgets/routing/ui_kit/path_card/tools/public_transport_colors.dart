import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

Color getMetroLineColor(String line, BuildContext context) {
  if (line.contains('Blue') || line == 'المسار الأزرق') {
    return Colors.blue;
  } else if (line.contains('Red') || line == 'المسار الأحمر') {
    return context.colors.errorDefault;
  } else if (line.contains('Green') || line == 'المسار الأخضر') {
    return context.colors.successDefault;
  } else if (line.contains('Yellow') || line == 'المسار الأصفر') {
    return const Color(0xFFD5CD3E);
  } else if (line.contains('Orange') || line == 'المسار البرتقالي') {
    return const Color(0xFFC76B27);
  } else if (line.contains('Purple') || line == 'المسار البنفسجي') {
    return Colors.purple;
  } else {
    return context.colors.neutralOnContainer;
  }
}
