import 'dart:math';

import 'package:flutter/services.dart';

/// A custom [TextInputFormatter] that formats phone numbers according to a specified country code.
///
/// The default country code is set to '966' (Saudi Arabia). The formatter removes any non-digit
/// characters from the input and applies a mask to format the phone number in the pattern:
/// `+<countryCode> (XXX) XXX-XX-XX`.
///
/// Example:
/// ```dart
/// final formatter = PhoneNumberFormatter();
/// ```
///
/// You can also specify a different country code:
/// ```dart
/// final formatter = PhoneNumberFormatter(countyCode: '1'); // For USA
/// ```
///
/// The formatter handles the following scenarios:
/// - Removes any non-digit characters from the input.
/// - Applies the mask to format the phone number.
/// - Adjusts the cursor position appropriately.
/// - Handles backspace correctly by resetting the cursor position if the formatted text is empty.
///
/// See also:
/// - [TextInputFormatter]
/// - [TextEditingValue]

String _convertArabicDigits(String text) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  return text.splitMapJoin(
    RegExp('[٠-٩]'),
    onMatch: (m) => arabic.indexOf(m[0]!).toString(),
    onNonMatch: (s) => s,
  );
}

class PhoneNumberFormatter extends TextInputFormatter {
  static const _arabicCountyCode = '966';
  static const arabicPhoneNumberMinLength = 12;

  final String countyCode;
  const PhoneNumberFormatter({this.countyCode = _arabicCountyCode});

  /// Formats the given [text] by removing any non-digit characters.
  ///
  /// TODO(ilyasov): extract to a separate utility class.
  static String formatPure(String text) => _convertArabicDigits(text).replaceAll(RegExp(r'\D'), '');

  /// Validates a Saudi mobile number: exactly 9 local digits starting with 5 after +966.
  static String? validateSaudiMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final local = formatPure(value).replaceFirst(RegExp(r'^966'), '');
    if (local.length != 9 || !local.startsWith('5')) {
      return '';
    }
    return null;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final initialMask = '+$countyCode (';
    // Remove any non-digit characters (convert Arabic digits first)
    String digitsOnly = _convertArabicDigits(newValue.text).replaceAll(RegExp(r'\D'), '');

    // Apply the mask
    final StringBuffer formatted = StringBuffer(initialMask);

    var i = 0;
    if (digitsOnly.startsWith(countyCode)) {
      digitsOnly = digitsOnly.replaceFirst(countyCode, '');
    }
    for (; i < min(digitsOnly.length, 9); i++) {
      if (i == 2) {
        formatted.write(') ');
      }
      if (i == 5) {
        formatted.write('-');
      }
      if (i == 7) {
        formatted.write('-');
      }

      formatted.write(digitsOnly[i]);
    }

    if (oldValue.text.length > newValue.text.length && formatted.toString() == initialMask) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Return the formatted text
    return TextEditingValue(
      text: formatted.toString(),
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
