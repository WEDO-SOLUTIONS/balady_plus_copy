import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';
import 'package:collection/collection.dart';

List<ResturantModel> resturantFromJson(List list) =>
    List<ResturantModel>.from(list.map((x) => ResturantModel.fromJson(x)));

class ResturantModel extends PointLayersData {
  int? OBJECTID;
  String? XCOORDINATE;
  String? YCOORDINATE;
  String? STREET_NAME;
  String? ACTIVITY_DETAILED_DESCRIPTION;
  String? TRADENAME;
  String? REGION_ID;
  String? AMANA_ID;
  String? DISTRICT_ID;
  String? CITY_ID;
  String? SUNDAY;
  String? MONDAY;
  String? TUESDAY;
  String? WEDNESDAY;
  String? THURSDAY;
  String? FRIDAY;
  String? SATURDAY;
  String? RATE;
  String? OPENSTATUS;
  String? REVIEW;
  ResturantModel({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    required super.latLng,
    this.ACTIVITY_DETAILED_DESCRIPTION,
    this.AMANA_ID,
    this.CITY_ID,
    this.DISTRICT_ID,
    this.FRIDAY,
    this.MONDAY,
    this.OBJECTID,
    this.OPENSTATUS,
    this.RATE,
    this.REGION_ID,
    this.REVIEW,
    this.SATURDAY,
    this.STREET_NAME,
    this.SUNDAY,
    this.THURSDAY,
    this.TRADENAME,
    this.TUESDAY,
    this.WEDNESDAY,
    this.XCOORDINATE,
    this.YCOORDINATE,
  });

  factory ResturantModel.fromJson(Map<String, dynamic> json) => ResturantModel(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["TRADENAME"] ?? '',
    description: json['attributes']["ACTIVITY_DETAILED_DESCRIPTION"] ?? '',
    type: json['attributes']["ACTIVITY_DETAILED_DESCRIPTION"]?.toString() ?? '',
    OBJECTID: json['attributes']["OBJECTID"] ?? '',
    XCOORDINATE: json['attributes']["XCOORDINATE"] ?? '',
    YCOORDINATE: json['attributes']["YCOORDINATE"] ?? '',
    STREET_NAME: json['attributes']["STREET_NAME"] ?? '',
    ACTIVITY_DETAILED_DESCRIPTION: json['attributes']["ACTIVITY_DETAILED_DESCRIPTION"] ?? '',
    TRADENAME: json['attributes']["TRADENAME"] ?? '',
    REGION_ID: json['attributes']["REGION_ID"] ?? '',
    AMANA_ID: json['attributes']["AMANA_ID"] ?? '',
    DISTRICT_ID: json['attributes']["DISTRICT_ID"] ?? '',
    CITY_ID: json['attributes']["CITY_ID"] ?? '',
    SUNDAY: json['attributes']["SUNDAY"] ?? '',
    MONDAY: json['attributes']["MONDAY"] ?? '',
    TUESDAY: json['attributes']["TUESDAY"] ?? '',
    WEDNESDAY: json['attributes']["WEDNESDAY"] ?? '',
    THURSDAY: json['attributes']["THURSDAY"] ?? '',
    FRIDAY: json['attributes']["FRIDAY"] ?? '',
    SATURDAY: json['attributes']["SATURDAY"] ?? '',
    RATE: json['attributes']["RATE"] ?? '',
    OPENSTATUS: json['attributes']["OPENSTATUS"] ?? '',
    REVIEW: json['attributes']["REVIEW"] ?? '',
    latLng: GeoPointWithElevationMessage(
      elevation: 1,
      latitude: double.parse(json['geometry']["y"].toString()),
      longitude: double.parse(json['geometry']["x"].toString()),
    ),
  );

  String get getRating => RATE != null && RATE!.trim().isNotEmpty ? "$RATE/5" : "";
  String get getReviews => REVIEW != null && REVIEW!.trim().isNotEmpty ? "($REVIEW)" : "";
  String get getAddress =>
      [STREET_NAME, DISTRICT_ID, CITY_ID, REGION_ID].nonNulls.whereNot((element) => element.isEmpty).join(", ");

  String? getCurrentDay() {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return MONDAY?.replaceAll("الاثنين،", "");

      case DateTime.tuesday:
        return TUESDAY?.replaceAll("الثلاثاء،", "");

      case DateTime.wednesday:
        return WEDNESDAY?.replaceAll("الأربعاء،", "");

      case DateTime.thursday:
        return THURSDAY?.replaceAll("الخميس،", "");

      case DateTime.friday:
        return FRIDAY?.replaceAll("الجمعة،", "");

      case DateTime.saturday:
        return SATURDAY?.replaceAll("السبت،", "");

      case DateTime.sunday:
        return SUNDAY?.replaceAll("الأحد،", "");

      default:
        return "";
    }
  }

  String? getDayByNameIndex(int index) {
    switch (index) {
      case 1:
        return SUNDAY?.split("،")[0];

      case 2:
        return MONDAY?.split("،")[0];

      case 3:
        return TUESDAY?.split("،")[0];

      case 4:
        return WEDNESDAY?.split("،")[0];

      case 5:
        return THURSDAY?.split("،")[0];

      case 6:
        return FRIDAY?.split("،")[0];

      case 7:
        return SATURDAY?.split("،")[0];

      default:
        return "";
    }
  }

  String? getDayByIndex(int index) {
    switch (index) {
      case 1:
        return SUNDAY?.replaceAll("الأحد،", "");

      case 2:
        return MONDAY?.replaceAll("الاثنين،", "");

      case 3:
        return TUESDAY?.replaceAll("الثلاثاء،", "");

      case 4:
        return WEDNESDAY?.replaceAll("الأربعاء،", "");

      case 5:
        return THURSDAY?.replaceAll("الخميس،", "");

      case 6:
        return FRIDAY?.replaceAll("الجمعة،", "");

      case 7:
        return SATURDAY?.replaceAll("السبت،", "");

      default:
        return "";
    }
  }

  bool get showWorkingHours =>
      SUNDAY != null && SUNDAY!.isNotEmpty ||
      MONDAY != null && MONDAY!.isNotEmpty ||
      TUESDAY != null && TUESDAY!.isNotEmpty ||
      WEDNESDAY != null && WEDNESDAY!.isNotEmpty ||
      THURSDAY != null && THURSDAY!.isNotEmpty ||
      FRIDAY != null && FRIDAY!.isNotEmpty ||
      SATURDAY != null && SATURDAY!.isNotEmpty;

  int get shiftNo => (getCurrentDay()?.split("،").length ?? 0);
  String? get getFirstShift => getCurrentDay()?.split("،")[0];
  String? get getSecondShift => shiftNo > 1 ? getFirstShift?.split("،")[0] : null;

  String? get getThirdhift => shiftNo > 2 ? getSecondShift?.split("،")[0] : null;

  int shiftsNOByIndex(int index) => (getDayByIndex(index)?.split("،").length ?? 0);
  String? getFirstShiftByIndex(int index) => getDayByIndex(index)?.split("،")[0];
  String? getSecondShiftByIndex(int index) => shiftsNOByIndex(index) > 1 ? getDayByIndex(index)?.split("،")[1] : null;
  String? getThirdShiftByIndex(int index) => shiftsNOByIndex(index) > 2 ? getDayByIndex(index)?.split("،")[2] : null;
}
