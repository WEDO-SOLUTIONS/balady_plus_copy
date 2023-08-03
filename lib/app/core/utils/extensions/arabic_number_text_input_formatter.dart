import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/services.dart';

class ArabicNumberTextInputFormatter extends TextInputFormatter {
  final Function(bool) onError;
  ArabicNumberTextInputFormatter({required this.onError});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
        text: CommonFunctions.replaceArabicNumberWithEnglish(newValue.text));
  }
}
