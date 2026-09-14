import 'dart:math' show pi;
import 'package:flutter/material.dart'
    show
        Border,
        BorderRadius,
        BorderRadiusGeometry,
        BorderSide,
        BoxBorder,
        BuildContext,
        Color,
        InputBorder,
        OutlineInputBorder,
        UnderlineInputBorder;

import '../../services/services_exports.dart' show NavigationService;
import '../utils_exports.dart' show ContextConversion, DIRECTION, BorderType;

extension BorderConversion on BorderType {
  InputBorder inputBorder({required Color color, double radius = 8.0}) {
    switch (this) {
      case BorderType.none:
        return InputBorder.none;
      case BorderType.outline:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: color),
        );
      case BorderType.underline:
        return UnderlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: color),
        );
    }
  }

  BoxBorder? boxBorder({required Color color}) {
    switch (this) {
      case BorderType.none:
        return null;
      case BorderType.outline:
        return Border.all(color: color);
      case BorderType.underline:
        return Border(bottom: BorderSide(color: color));
    }
  }

  BorderRadiusGeometry? boxBorderRadius({required double radius}) {
    switch (this) {
      case BorderType.none:
        return null;
      case BorderType.outline:
        return BorderRadius.circular(radius);
      case BorderType.underline:
        return null;
    }
  }
}

extension DirectionConversion on DIRECTION {
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
