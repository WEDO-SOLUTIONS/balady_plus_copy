import 'package:hijri/hijri_calendar.dart';

import '../utils_exports.dart' show DateForm;

extension DateTimeExtension on DateTime {
  String toFormattedDate() {
    return "$year/$month/$day";
  }

  String toHijriFormattedDate() {
    final date = HijriCalendar.fromDate(this).toFormat("yyyy/mm/dd");
    return date;
  }

  String formatTo(DateForm dateForm) {
    if (dateForm == DateForm.hijri) {
      return toHijriFormattedDate();
    }
    return toFormattedDate();
  }
}
