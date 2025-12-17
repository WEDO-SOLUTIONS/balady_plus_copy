import 'package:flutter/widgets.dart';

class BaladySupportingText {
  final String? text;
  final Color? textColor;
  final TextStyle? style;
  final int? maxLength;

  const BaladySupportingText({
    this.text,
    this.textColor,
    this.style,
    this.maxLength,
  });

  bool get isNotEmptyOrNull => text != null && text!.isNotEmpty;
}
