import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get designWidth => 375;
  double get designHeight => 812;

  double w(double pixels) => pixels * screenWidth / designWidth;
  double h(double pixels) => pixels * screenHeight / designHeight;
}
