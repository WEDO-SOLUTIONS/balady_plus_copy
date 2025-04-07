import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:dgis_map/library.dart';


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
  String? feesType;

  SearchEventsItem(
      {this.id,
      this.eventName,
      this.category,
      this.city,
      this.startDate,
      this.endDate,
      this.locationX,
      this.locationY,
      this.logoImage,
      this.feesType});

  String getStartDay() {
    if (startDate != null) {
      return startDate!.day.toString().padLeft(2, "0");
    }
    return '';
  }

  String getStartMonth() {
    if (startDate != null) {
      return startDate!.toMonthName();
    }
    return '';
  }

  String getEndDay() {
    if (endDate != null) {
      return endDate!.day.toString().padLeft(2, "0");
    }
    return '';
  }

  String getEndYear() {
    if (endDate != null) {
      return endDate!.year.toString();
    }
    return '';
  }

  String getStartYear() {
    if (startDate != null) {
      return startDate!.year.toString();
    }
    return '';
  }

  String getEndMonth() {
    if (endDate != null) {
      return endDate!.toMonthName();
    }
    return '';
  }

  LatLng? getLocation() {
    double? lon = double.tryParse(locationY ?? "");
    double? lat = double.tryParse(locationX ?? "");

    if (lat != null && lon != null) return LatLng(latitude:lat, longitude:lon);
    return null;
  }

  String getDate() {
    return "${getStartDay()} ${getStartMonth()}  - ${getEndDay()} ${getEndMonth()}";
  }

  String getStartDate() {
    return "${getStartDay()} ${getStartMonth()} ${getStartYear()}";
  }

  String getEndDate() {
    return "${getEndDay()} ${getEndMonth()} ${getEndYear()}";
  }

  String getFormatDate() {
    return " ${getStartDay()} ${getStartMonth()} ${getStartYear()}  |  ${getEndDay()} ${getEndMonth()} ${getEndYear()}";
  }
}
