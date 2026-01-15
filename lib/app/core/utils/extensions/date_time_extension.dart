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
    final date = CommonFunctions.mapARNumbersToENNumbers(HijriCalendar.fromDate(this).toFormat("yyyy/mm/dd"));
    return date;
  }

  // Future<String> toHijriFormattedDateForCompliance() async {
  //   var date = "";
  //   try {
  //     date = CommonFunctions.mapARNumbersToENNumbers(
  //         HijriCalendar.fromDate(this).toFormat("yyyy/mm/dd"));
  //
  //     String year = HijriCalendar.fromDate(this).hYear.toString();
  //     String month =
  //         HijriCalendar.fromDate(this).hMonth.toString().padLeft(2, '0');
  //     String day = HijriCalendar.fromDate(this).hDay.toString().padLeft(2, '0');
  //
  //     return "$year/$month/$day";
  //   } catch (error, stackTrace) {
  //     LogsViewModel().sendEventFromModel(
  //       event: ErrorExceptionModel(
  //         nameEvent: EventsName.handledException,
  //         message: error.toString(),
  //         stackTrace: stackTrace.toString(),
  //       ),
  //     );
  //     String formattedDate = DateFormat("dd/MM/yyyy").format(this);
  //
  //     date = await (BaladyServices(webService: sl())
  //             .getHijtiDate(formattedDate)) ??
  //         "";
  //   }
  //   return date;
  // }

  // Future<String> toHijriFormattedDate1() async {
  //   var date = "";
  //
  //   date = await toHijriFormattedDateForCompliance();
  //
  //   return date;
  // }

  String formatTo(DateForm dateForm) {
    if (dateForm == DateForm.hijri) {
      return toHijriFormattedDate();
    }
    return toFormattedDate();
  }

  // Future<String> formatToService(DateForm dateForm) async {
  //   if (dateForm == DateForm.hijri) {
  //     return toHijriFormattedDateForCompliance();
  //   }
  //   return toFormattedDate();
  // }

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

  String toMonthName() {
    final formatter = DateFormat('MMM', translator.activeLanguageCode);
    final formattedDate = formatter.format(this);
    return formattedDate;
  }

  String toTime() {
    final formatter = DateFormat('h:mm a', translator.activeLanguageCode);
    final formattedDate = formatter.format(this);
    return CommonFunctions.mapARNumbersToENNumbers(formattedDate);
  }
}

String formatDateRange(DateTime start, DateTime end, [String? locale]) {
  final sameMonth = start.month == end.month;
  final sameYear = start.year == end.year;

  final dayFormatter = DateFormat('d', locale);
  final monthFormatter = DateFormat('MMM', locale);
  final yearFormatter = DateFormat('y', locale);

  if (sameMonth && sameYear) {
    // Example: 17–20 Nov 2025
    return '${dayFormatter.format(start)}–${dayFormatter.format(end)} '
        '${monthFormatter.format(start)} ${yearFormatter.format(start)}';
  } else if (sameYear) {
    // Example: 28 Oct – 2 Nov 2025
    return '${dayFormatter.format(start)} ${monthFormatter.format(start)} – '
        '${dayFormatter.format(end)} ${monthFormatter.format(end)} '
        '${yearFormatter.format(start)}';
  } else {
    // Example: 28 Dec 2025 – 3 Jan 2026
    return '${dayFormatter.format(start)} ${monthFormatter.format(start)} '
        '${yearFormatter.format(start)} – '
        '${dayFormatter.format(end)} ${monthFormatter.format(end)} '
        '${yearFormatter.format(end)}';
  }
}
