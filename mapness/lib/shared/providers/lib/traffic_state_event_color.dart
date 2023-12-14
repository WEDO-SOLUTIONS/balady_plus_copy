import 'dart:ui';

import 'package:dgis_map/library.dart';

extension TrafficStateEventColor on TrafficStateEvent {
  Color? get color {
    return switch (score) {
      < 3 => const Color(0xff52B374),
      < 6 => const Color(0xffFBB815),
      _ => const Color(0xffD14733),
    };
  }
}
