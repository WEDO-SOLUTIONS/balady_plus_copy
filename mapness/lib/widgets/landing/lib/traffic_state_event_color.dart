import 'dart:ui';

import 'package:dgis_map/library.dart';

extension TrafficStateEventColor on TrafficStateEvent {
  Color get color {
    return switch (score) {
      < 3 => const Color(0xff6CB17A),
      < 5 => const Color(0xffF4BB44),
      _ => const Color(0xffC1513C),
    };
  }
}
