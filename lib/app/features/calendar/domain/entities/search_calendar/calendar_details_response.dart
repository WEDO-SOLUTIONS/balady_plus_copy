import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/events_location.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/events_picture.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

class CalendarDetailsResponse {
  final String? id;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? logoUrl;
  final List<Picture>? pictures;

  CalendarDetailsResponse(
      {this.id,
      this.name,
      this.description,
      this.startDate,
      this.endDate,
      this.logoUrl,
      this.pictures});

  String getStartDay() {
    if (startDate != null) {
      return startDate!.day.toString();
    }
    return '';
  }

  String getStartMonth() {
    if (startDate != null) {
      return startDate!.toMonthName();
    }
    return '';
  }

  String getStartYear() {
    if (startDate != null) {
      //return startDate!.month.toString();
      return startDate!.year.toString();
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

  String getEndYear() {
    if (endDate != null) {
      return endDate!.year.toString();
    }
    return '';
  }

  String getDate() {
    return " ${getStartDay()} ${getStartMonth()} ${getStartYear()}   - ${getEndDay()} ${getEndMonth()} ${getEndYear()}";
  }
}

class Picture {
  final String? caption;
  final String? url;

  Picture({
    this.caption,
    this.url,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        caption: json["caption"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "caption": caption,
        "url": url,
      };
}
