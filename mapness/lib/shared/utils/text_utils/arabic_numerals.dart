/// Digit shaping for the Arabic locale (HB-95).
///
/// The `intl` package cannot do this for us: its `ar` locale data declares
/// `ZERO_DIGIT: '0'` (see `number_symbols_data.dart`), so
/// `NumberFormat.decimalPattern('ar')` localises the grouping separator but
/// still emits Latin digits. Shaping therefore has to be explicit.
///
/// Only the ten digits are substituted — the decimal point and the grouping
/// comma are deliberately left as ASCII rather than switched to `٫` (U+066B)
/// and `٬` (U+066C), because the rest of the app (and the native map labels)
/// use ASCII separators and mixing the two reads worse than either alone.
///
/// Apply this at the **display** boundary only. Never shape a string that is
/// about to be parsed, sent to a backend, used as a cache key, or logged —
/// `int.parse` / `DateFormat.parse` do not understand Arabic-Indic digits.
library;

import 'package:flutter/widgets.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// U+0660 ARABIC-INDIC DIGIT ZERO.
const int _arabicIndicZero = 0x0660;

const int _asciiZero = 0x30;
const int _asciiNine = 0x39;
const int _hyphenMinus = 0x2D;

/// U+200E LEFT-TO-RIGHT MARK.
const int _lrmCodeUnit = 0x200E;
const String _lrm = '‎';

bool _isAsciiDigit(int unit) => unit >= _asciiZero && unit <= _asciiNine;

/// Substitutes ASCII digits in [value] with Arabic-Indic digits (٠١٢٣٤٥٦٧٨٩).
///
/// Every other code unit — separators, letters, whitespace, bidi marks — is
/// preserved as-is. Returns [value] unchanged when it holds no ASCII digits,
/// so the common case allocates nothing.
///
/// Minus signs get one extra piece of care. Arabic-Indic digits are bidi class
/// AN, and an ASCII hyphen (class ES) only binds to EN digits — before AN it
/// resolves to the surrounding paragraph direction, so `-4` would render as
/// `٤-` inside RTL text. A LEFT-TO-RIGHT MARK is inserted before a hyphen that
/// acts as a *sign*, matching CLDR's `MINUS_SIGN: '‎-'` for `ar`. A hyphen
/// sitting between two digits is a range separator (`07:00-19:00`), not a sign,
/// and is left alone.
String toArabicIndicDigits(String value) {
  final units = value.codeUnits;
  if (!units.any(_isAsciiDigit)) {
    return value;
  }

  final buffer = StringBuffer();
  for (var i = 0; i < units.length; i++) {
    final unit = units[i];
    if (_isAsciiDigit(unit)) {
      buffer.writeCharCode(unit - _asciiZero + _arabicIndicZero);
      continue;
    }
    if (unit == _hyphenMinus &&
        i + 1 < units.length &&
        _isAsciiDigit(units[i + 1]) &&
        !(i > 0 && (_isAsciiDigit(units[i - 1]) || units[i - 1] == _lrmCodeUnit))) {
      buffer.write(_lrm);
    }
    buffer.writeCharCode(unit);
  }

  return buffer.toString();
}

/// True when [localeName] ('ar', 'ar_SA', …) renders Arabic-Indic digits.
bool localeUsesArabicIndicDigits(String localeName) => localeName.startsWith('ar');

/// Shapes the digits of [value] for [localeName]. No-op outside Arabic.
///
/// For code that has a locale/language code but no [AppLocalizations] or
/// [BuildContext] — providers, repositories, background work.
String digitsForLocale(String localeName, String value) =>
    localeUsesArabicIndicDigits(localeName) ? toArabicIndicDigits(value) : value;

/// Shapes digits according to the locale of an [AppLocalizations] instance.
///
/// This is the primary hook: most formatting helpers in the app already take
/// an [AppLocalizations] for their unit suffixes, so they can shape their
/// output without a signature change.
extension LocalizedNumerals on AppLocalizations {
  /// True when this locale renders numbers with Arabic-Indic digits.
  bool get usesArabicIndicDigits => localeUsesArabicIndicDigits(localeName);

  /// Shapes the digits of [value] for this locale. No-op outside Arabic.
  String digits(String value) => digitsForLocale(localeName, value);

  /// Nullable form of [digits] — keeps `null` as `null`.
  String? digitsOrNull(String? value) => value == null ? null : digits(value);

  /// Shapes [value] for this locale. Convenience for raw numbers.
  String number(num value) => digits('$value');
}

/// Shapes digits for widgets that have a [BuildContext] but no
/// [AppLocalizations] to hand.
extension LocalizedNumeralsContext on BuildContext {
  /// Shapes the digits of [value] for the active locale. No-op outside Arabic.
  String digits(String value) => AppLocalizations.of(this).digits(value);

  /// Nullable form of [digits] — keeps `null` as `null`.
  String? digitsOrNull(String? value) => value == null ? null : digits(value);
}
