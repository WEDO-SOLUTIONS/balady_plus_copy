import 'package:flutter/material.dart';

/// App text styles
abstract class MapnessTypography {
  /// 15, 400
  static const l = TextStyle(
    fontWeight: FontWeight.w700,
    color: Color(0xff212121),
    fontSize: 18,
    height: 1.33,
  );

  /// 15, 400
  static const m = TextStyle(
    fontWeight: FontWeight.w400,
    color: Color(0xff212121),
    fontSize: 15,
    height: 1.33,
  );

  /// 13, 400
  static const s = TextStyle(
    fontWeight: FontWeight.w400,
    color: Color(0xff212121),
    fontSize: 13,
    height: 1.23,
  );

  /// 11, 500
  static const xs = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 11,
    color: Color(0xff929292),
    height: 1.45,
  );
}
