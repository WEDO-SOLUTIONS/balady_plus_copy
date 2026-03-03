import 'package:flutter/material.dart';

class BaladyInputLabel {
  final String text;
  final TextStyle? style;
  final bool isRequired;
  final EdgeInsetsGeometry? padding;

  const BaladyInputLabel({
    required this.text,
    this.style,
    this.isRequired = false,
    this.padding,
  });
}
