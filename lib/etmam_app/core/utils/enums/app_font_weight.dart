import 'package:flutter/material.dart' show FontWeight;

enum AppFontWeight {
  light(fontWeight: FontWeight.w300),
  regular(fontWeight: FontWeight.w400),
  medium(fontWeight: FontWeight.w500),
  bold(fontWeight: FontWeight.w700),
  black(fontWeight: FontWeight.w900),
  w600(fontWeight: FontWeight.w600);

  const AppFontWeight({required this.fontWeight});
  final FontWeight fontWeight;
}
