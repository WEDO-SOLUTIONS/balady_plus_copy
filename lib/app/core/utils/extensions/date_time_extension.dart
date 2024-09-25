import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../features/_shared_feature_/balady_features/services/services.dart';
import '../../dependency_injection/injection_container.dart';
import '../utils_exports.dart' show CommonFunctions, DateForm;

import 'package:balady_plus/app/events_logs/balady_logs.dart';

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

  Future<String> toHijriFormattedDateForCompliance() async {
    var date = "";
    try {
      date = CommonFunctions.mapARNumbersToENNumbers(
          HijriCalendar.fromDate(this).toFormat("yyyy/mm/dd"));

      String year = HijriCalendar.fromDate(this).hYear.toString();
      String month =
          HijriCalendar.fromDate(this).hMonth.toString().padLeft(2, '0');
      String day = HijriCalendar.fromDate(this).hDay.toString().padLeft(2, '0');

      return "$year/$month/$day";
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      String formattedDate = DateFormat("dd/MM/yyyy").format(this);

      date = await (BaladyServices(webService: sl())
              .getHijtiDate(formattedDate)) ??
          "";
    }
    return date;
  }

  Future<String> toHijriFormattedDate1() async {
    var date = "";

    date = await toHijriFormattedDateForCompliance();

    return date;
  }

  String formatTo(DateForm dateForm) {
    if (dateForm == DateForm.hijri) {
      return toHijriFormattedDate();
    }
    return toFormattedDate();
  }

  Future<String> formatToService(DateForm dateForm) async {
    if (dateForm == DateForm.hijri) {
      return toHijriFormattedDateForCompliance();
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
