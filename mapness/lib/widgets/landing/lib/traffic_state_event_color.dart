import 'dart:ui';

import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:dgis_map/library.dart';

extension TrafficStateEventColor on TrafficStateEvent {
  Color get color => switch (score) {
      < 3 => NonThemeColor.color23,
      < 5 => NonThemeColor.color24,
      _ => NonThemeColor.color25,
    };
}
