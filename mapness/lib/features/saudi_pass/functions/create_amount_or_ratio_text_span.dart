import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mapness/shared/providers/app_language.dart';

import 'format_currency_text_span.dart';

TextSpan? createAmountOrRatioTextSpan({
  required Language language,
  required Locale locale,
  num? amount,
  num? ratio,
  double? iconSize,
}) {
  if (amount != null) {
    return formatCurrencyTextSpan(amount, language, locale, iconSize);
  }

  if (ratio != null) {
    return TextSpan(text: NumberFormat.decimalPercentPattern(locale: locale.languageCode).format(ratio / 100));
  }

  return null;
}
