import 'package:balady_plus/app/features/events/domain/entities/events_details/events_location.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/events_picture.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventDetailsResponse {
  final String? id;
  final String? name;
  final String? description;
  final String? category;
  final String? city;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;
  final String? logoUrl;
  final String? feesType;
  final String? season;
  final String? audience;
  final Location? location;
  final String? ticketUrl;
  final List<Picture>? pictures;

  EventDetailsResponse({
    this.id,
    this.name,
    this.description,
    this.category,
    this.city,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.logoUrl,
    this.feesType,
    this.season,
    this.audience,
    this.location,
    this.ticketUrl,
    this.pictures,
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
