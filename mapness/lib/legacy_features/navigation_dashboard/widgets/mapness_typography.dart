import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App text styles
abstract class MapnessTypography {
  /// 15, 400
  static final l = GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    color: const Color(0xff212121),
    fontSize: 18,
    height: 1.33,
  );

  /// 15, 400
  static final m = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: const Color(0xff212121),
    fontSize: 15,
    height: 1.33,
  );

  /// 13, 400
  static final s = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: const Color(0xff212121),
    fontSize: 13,
    height: 1.23,
  );

  /// 11, 500
  static final xs = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    fontSize: 11,
    color: const Color(0xff929292),
    height: 1.45,
  );
}
