import 'package:flutter/material.dart' show SizedBox;

class UIHelper {
  // vertical spaces
  static const SizedBox verticalSmallSpace = SizedBox(height: 12.0);
  static const SizedBox verticalMediumSpace = SizedBox(height: 24.0);
  static const SizedBox verticalLargeSpace = SizedBox(height: 32.0);
  static const SizedBox verticalExtraSpace = SizedBox(height: 60.0);

  // horizontal spaces
  static const SizedBox horizontalSmallSpace = SizedBox(width: 12.0);
  static const SizedBox horizontalMediumSpace = SizedBox(width: 24.0);
  static const SizedBox horizontalLargeSpace = SizedBox(width: 32.0);
  static const SizedBox horizontalExtraSpace = SizedBox(width: 60.0);

  // Default padding
  static const double littlePadding = 8.0;
  static const double smallPadding = 12.0;
  static const double middlePadding = 18.0;
  static const double mediumPadding = 24.0;
  static const double largePadding = 32.0;
  static const double extraPadding = 60.0;

  // General Duration
  static const duration = Duration(milliseconds: 10);
}
