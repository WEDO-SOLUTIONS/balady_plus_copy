import 'package:flutter/material.dart';

/// Represents shadows values used in UI layout.
abstract class Shadows {
  /// {x: 0 y: 0}, blur: 0, spread: 0,5, black 4%
  /// {x: 0 y: 1}, blur: 4, spread: 0, black 8%
  static const s = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.08),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      spreadRadius: 0.5,
    ),
  ];

  /// {x: 0 y: 2}, blur: 4, spread: 0, black 6%
  /// {x: 0 y: 6}, blur: 12, spread: 0, black 7%
  static const m = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 12,
      offset: Offset(0, 6),
    )
  ];

  /// {x: 0 y: 6}, blur: 8, spread: 0, black 6%
  /// {x: 0 y: 10}, blur: 20, spread: 0, black 8%
  static const l = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 8,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 20,
      offset: Offset(0, 10),
    )
  ];

  /// {x: 0 y: 10}, blur: 12, spread: 0, black 5%
  /// {x: 0 y: 12}, blur: 36, spread: 0, black 7%
  static const xl = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 12,
      offset: Offset(0, 10),
    ),
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 36,
      offset: Offset(0, 12),
    )
  ];

  /// {x: 0 y: 18}, blur: 20, spread: 0, black 5%
  /// {x: 0 y: 18}, blur: 56, spread: 0, black 7%
  static const xxl = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 20,
      offset: Offset(0, 18),
    ),
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 56,
      offset: Offset(0, 18),
    )
  ];
}

/// Represents shadows values used in UI layout to discribe elevations of different layers.
abstract class Elevation {
  /// {x: 0 y: -1}, blur: 2, spread: 0, black 6%
  static const s = BoxShadow(
    offset: Offset(0, -1),
    blurRadius: 2,
    color: Color(0x0F000000),
  );
}
