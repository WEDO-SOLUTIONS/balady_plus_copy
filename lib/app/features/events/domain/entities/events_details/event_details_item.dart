import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/events_location.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_details/events_picture.dart';
import 'package:dgis_map/library.dart';

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
  final double? fees;

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
    this.fees,
  });

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

  String getTime() {
    return "${startTime?.replaceAll("AM", "am".tr()).replaceAll("PM", "pm".tr())} - ${endTime?.replaceAll("AM", "am".tr()).replaceAll("PM", "pm".tr())}";
  }

  DateTime? getStartDateFull() {
    if (startDate != null && startTime != null) {
      return (setTimeInDateTime(startDate!, startTime!));
    }
    return null;
  }

  DateTime? getEndDateFull() {
    if (endDate != null && endTime != null) {
      return (setTimeInDateTime(endDate!, endTime!));
    }
    return null;
  }

  String getFess() {
    if (fees == 0 || fees == null) {
      //   return "مجاني";
    }

    return feesType ?? "";
  }

  LatLng? getLocation() {
    double? lon = double.tryParse(location?.y ?? "");
    double? lat = double.tryParse(location?.x ?? "");

    if (lat != null && lon != null) return LatLng(latitude: lat, longitude: lon);
    return null;
  }

  DateTime setTimeInDateTime(DateTime dateTime, String timeString) {
    // Define a regular expression pattern to match the time string
    final pattern = r'^(\d{1,2}):(\d{2}) (AM|PM)$';
    final regex = RegExp(pattern);

    // Try to match the time string with the regular expression
    final match = regex.firstMatch(timeString);

    if (match == null) {
      throw ArgumentError('Invalid time format. Should be in HH:mm AM/PM format');
    }

    var hour = int.parse(match.group(1)!);
    var minute = int.parse(match.group(2)!);
    final amOrPm = match.group(3);

    if (hour < 1 || hour > 12 || minute < 0 || minute > 59) {
      throw ArgumentError('Invalid hour or minute');
    }

    // Adjust the hour based on AM or PM
    if (amOrPm == 'PM' && hour != 12) {
      hour += 12;
    } else if (amOrPm == 'AM' && hour == 12) {
      hour = 0;
    }

    // Create a new DateTime object with the provided time and the date from the input DateTime
    final newDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);

    return newDateTime;
  }
}
