import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

Color getMetroLineColor(String line, BuildContext context) => switch (line) {
      'Blue' => Colors.blue,
      'Red' => context.colorsV3.errorDefault,
      'Green' => context.colorsV3.successDefault,
      'Yellow' => const Color(0xFFD5CD3E),
      'Orange' => const Color(0xFFC76B27),
      'Purple' => Colors.purple,
      _ => Colors.black,
    };
