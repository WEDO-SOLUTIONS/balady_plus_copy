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

class PhoneNumberFormatter extends TextInputFormatter {
  static const _arabicCountyCode = '966';

  final String countyCode;
  const PhoneNumberFormatter({this.countyCode = _arabicCountyCode});
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final initialMask = '+$countyCode (';
    // Remove any non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Apply the mask
    final StringBuffer formatted = StringBuffer(initialMask);

    var i = 0;
    if (digitsOnly.startsWith(countyCode)) {
      digitsOnly = digitsOnly.replaceFirst(countyCode, '');
    }
    for (; i < min(digitsOnly.length, 10); i++) {
      if (i == 3) {
        formatted.write(') ');
      }
      if (i == 6) {
        formatted.write('-');
      }
      if (i == 8) {
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
