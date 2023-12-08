import 'dart:math' show pi;

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:flutter/material.dart' show BuildContext;

import '../utils_exports.dart' show ContextConversion;

enum DIRECTION {
  forward,
  downward,
  backward,
  upward,
  none;

  double get rotate {
    switch (this) {
      case DIRECTION.forward:
        // original shape "does not rotated"
        // or Rotate the shape clockwise by four, means back to original
        return context.isRTL ? _rotate(180.0) : _rotate(0.0);
      case DIRECTION.downward:
        // Rotate the shape clockwise by one
        return _rotate(90.0);
      case DIRECTION.backward:
        // Rotate the shape clockwise by two
        return context.isRTL ? _rotate(0.0) : _rotate(180.0);
      case DIRECTION.upward:
        // Rotate the shape clockwise by three
        return _rotate(270.0);
      case DIRECTION.none:
        return _rotate(0.0);
    }
  }

  int get turns {
    switch (this) {
      case DIRECTION.forward:
        // original shape "does not rotated"
        // or Rotate the shape clockwise by four, means back to original
        return context.isRTL ? 2 : 0;
      case DIRECTION.downward:
        // Rotate the shape clockwise by one
        return 1;
      case DIRECTION.backward:
        // Rotate the shape clockwise by two
        return context.isRTL ? 0 : 2;
      case DIRECTION.upward:
        // Rotate the shape clockwise by three
        return 3;
      case DIRECTION.none:
        return 0;
    }
  }

  double _rotate(double degree) => degree * pi / 180.0;

  BuildContext get context => NavigationService.navigatorKey.currentContext!;
}
