import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum MarkerColorCode {
  darkGreen,
  blue,
  orange,
  brown,
  red,
  purple,
  yellow,
  green,
  darkRed,
  turquoise,
  unknown;

  Color get color => switch (this) {
    MarkerColorCode.darkGreen => const Color(0xFF1B8354),
    MarkerColorCode.blue => const Color(0xFF1570EF),
    MarkerColorCode.orange => const Color(0xFFF79009),
    MarkerColorCode.brown => const Color(0xFFB54708),
    MarkerColorCode.red => const Color(0xFFF04438),
    MarkerColorCode.purple => const Color(0xFF6D428F),
    MarkerColorCode.yellow => const Color(0xFFF5BD02),
    MarkerColorCode.green => const Color(0xFF17B26A),
    MarkerColorCode.darkRed => const Color(0xFF912018),
    MarkerColorCode.turquoise => const Color(0xFF63D9D0),
    MarkerColorCode.unknown => const Color(0xFF000000),
  };
}
