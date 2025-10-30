import 'package:flutter/material.dart'
    show
        Border,
        BorderRadius,
        BorderRadiusGeometry,
        BorderSide,
        BoxBorder,
        Color,
        InputBorder,
        OutlineInputBorder,
        UnderlineInputBorder;

enum BorderType {
  //? First solution (In case you use the static color and radius)
  none,
  outline,
  underline;

  //? Second Solution
  InputBorder toInputBorder({required Color color, double radius = 8.0}) {
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

  BoxBorder? toBoxBorder({required Color color}) {
    switch (this) {
      case BorderType.none:
        return null;
      case BorderType.outline:
        return Border.all(color: color);
      case BorderType.underline:
        return Border(bottom: BorderSide(color: color));
    }
  }

  BorderRadiusGeometry toBoxBorderRadius({required radius}) {
    switch (this) {
      case BorderType.none:
        return BorderRadius.zero;
      case BorderType.outline:
        return BorderRadius.circular(radius);
      case BorderType.underline:
        return BorderRadius.zero;
    }
  }
}
