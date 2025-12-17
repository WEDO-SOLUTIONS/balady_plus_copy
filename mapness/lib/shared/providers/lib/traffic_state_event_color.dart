import 'dart:ui';

import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:dgis_map/library.dart';

extension TrafficStateEventColor on TrafficStateEvent {
  Color? get color => switch (score) {
        < 3 => NonThemeColor.color3,
        < 6 => NonThemeColor.color54,
        _ => NonThemeColor.color1,
      };
}
