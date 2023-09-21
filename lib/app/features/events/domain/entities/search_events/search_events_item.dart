import 'package:localize_and_translate/localize_and_translate.dart';

class SearchEventsItem {
  String? id;
  String? eventName;
  String? category;
  String? city;
  DateTime? startDate;
  DateTime? endDate;
  String? locationX;
  String? locationY;
  String? logoImage;

  SearchEventsItem({
    this.id,
    this.eventName,
    this.category,
    this.city,
    this.startDate,
    this.endDate,
    this.locationX,
    this.locationY,
    this.logoImage,
  });
  Map<int, String> monthNames = {
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
  };

  String getStartDay() {
    if (startDate != null) {
      return startDate!.day.toString();
    }
    return '';
  }

  String getStartMonth() {
    if (startDate != null) {
      //return startDate!.month.toString();
      return monthNames[startDate!.month] ?? "";
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
      return monthNames[endDate!.month] ?? "";
    }
    return '';
  }
}
