import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/services.dart';

class NumberTextInputFormatter extends TextInputFormatter {
  final Function(bool) onError;
  NumberTextInputFormatter({required this.onError});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    bool match = RegExp(r'[0-9]').hasMatch(newValue.text);
    onError(match);
    return newValue.copyWith(
        text: CommonFunctions.replaceArabicNumberWithEnglish(newValue.text));
  }
}
