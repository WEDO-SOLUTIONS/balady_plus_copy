import 'dart:ui';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SearchCalendarItem {
  String? id;
  String? name;
  String? type;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  int? timeToStartInDays;
  String? logoURL;

  SearchCalendarItem({
    this.id,
    this.name,
    this.type,
    this.description,
    this.startDate,
    this.endDate,
    this.timeToStartInDays,
    this.logoURL,
  });
  /* Map<int, String> monthNames = {
    1: 'January'.tr(),
    2: 'February'.tr(),
    3: 'March'.tr(),
    4: 'April'.tr(),
    5: 'May'.tr(),
    6: 'June'.tr(),
    7: 'July'.tr(),
    8: 'August'.tr(),
    9: 'September'.tr(),
    10: 'October'.tr(),
    11: 'November'.tr(),
    12: 'December'.tr(),
  };*/

  String getStartDay() {
    if (startDate != null) {
      return startDate!.day.toString();
    }
    return '';
  }

  String getStartYear() {
    if (startDate != null) {
      return startDate!.year.toString();
    }
    return '';
  }

  String getEndYear() {
    if (startDate != null) {
      return endDate!.year.toString();
    }
    return '';
  }

  String getStartDayName() {
    if (startDate != null) {
      return startDate!.toDayName();
    }
    return '';
  }

  String getStartMonth() {
    if (startDate != null) {
      //return startDate!.month.toString();
      return startDate!.toMonthName();
    }
    return '';
  }

  String getEndDay() {
    if (endDate != null) {
      return endDate!.day.toString();
    }
    return '';
  }

  String getEndMonth() {
    if (endDate != null) {
      return endDate!.toMonthName();
    }
    return '';
  }

  String remainingText() {
    return "saudi_calendar_remain".tr().replaceAll("{}", name ?? "");
  }

  String remainingDays() {
    return "saudi_calendar_day"
        .tr()
        .replaceAll("{}", timeToStartInDays.toString() ?? "");
  }

  String getDate() {
    if (startDate == endDate)
      return "${getStartDay()} ${getStartMonth()} ${getStartYear()}";
    return "${getStartDay()} ${getStartMonth()} ${getStartYear()} - ${getEndDay()} ${getEndMonth()} ${getEndYear()}";
  }

  List<Color> getColors(int index) {
    if (index % 3 == 0) {
      return [Color(0xFF65C1C0), Color(0xFFA6D377)];
    }

    if (index % 3 == 1) {
      return [Color(0xFFD48C82), Color(0xFFE7B366)];
    }

    if (index % 3 == 2) {
      return [Color(0xFF6090B9), Color(0xFF67C2D2)];
    }

    if (index % 3 == 3) {
      return [Color(0xFF0A7E47), Color(0xFF3AB379)];
    }

    return [Color(0xFF65C1C0), Color(0xFFA6D377)];
  }
}
