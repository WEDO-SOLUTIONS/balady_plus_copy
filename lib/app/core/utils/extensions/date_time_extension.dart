import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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

  String toWrittenDate() {
    final formatter = DateFormat('d MMMM y', translator.activeLanguageCode);
    final formattedDate = formatter.format(this);
    return formattedDate;
  }

  String toyMD() {
    final formatter = DateFormat('yMd', translator.activeLanguageCode);
    final formattedDate = formatter.format(this);
    return formattedDate;
  }
}
