import 'dart:ui';

import 'package:intl/intl.dart';

class WeatherDateFormatter {
  // static String defaultLocale =
  //     Platform.localeName; // Returns locale string in the form 'en_US

  //get today day
  static String getToday(Locale locale) {
    final now = DateTime.now();
    return DateFormat('EEE', locale.languageCode).format(now);
  }

  static String getDay(String date, Locale locale) {
    final dateTime = DateTime.parse(date);
    return DateFormat('EEE', locale.languageCode).format(dateTime);
  }

  static bool isToday(String date, Locale locale) {
    if (getToday(locale) == getDay(date, locale)) {
      return true;
    } else {
      return false;
    }
  }
}
