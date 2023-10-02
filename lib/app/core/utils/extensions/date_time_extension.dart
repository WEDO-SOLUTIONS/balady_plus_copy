import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../utils_exports.dart' show CommonFunctions, DateForm;

extension DateTimeExtension on DateTime {
  String toFormattedDate() {
    return "$year/$month/$day";
  }

  String toFormattedDate1() {
    return "$month/$day/$year";
  }

  String toHijriFormattedDate() {
    final date = CommonFunctions.mapARNumbersToENNumbers(
        HijriCalendar.fromDate(this).toFormat("yyyy/mm/dd"));
    return date;
  }

  String toHijriFormattedDate1() {
    final date = CommonFunctions.mapARNumbersToENNumbers(
        HijriCalendar.fromDate(this).toFormat("yyyy/mm/dd"));

    String year = HijriCalendar.fromDate(this).hYear.toString();
    String month =
        HijriCalendar.fromDate(this).hMonth.toString().padLeft(2, '0');
    String day = HijriCalendar.fromDate(this).hDay.toString().padLeft(2, '0');

    return "$year/$month/$day";
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
    return CommonFunctions.mapARNumbersToENNumbers(formattedDate);
  }

  String toyMD() {
    final formatter = DateFormat('yMd', translator.activeLanguageCode);
    final formattedDate = formatter.format(this);
    return CommonFunctions.mapARNumbersToENNumbers(formattedDate);
  }

  String toDayName() {
    final formatter = DateFormat('EE', translator.activeLanguageCode);
    final formattedDate = formatter.format(this);
    return CommonFunctions.mapARNumbersToENNumbers(formattedDate);
  }

  String toTime() {
    final formatter = DateFormat('h:mm a', translator.activeLanguageCode);
    final formattedDate = formatter.format(this);
    return CommonFunctions.mapARNumbersToENNumbers(formattedDate);
  }
}
