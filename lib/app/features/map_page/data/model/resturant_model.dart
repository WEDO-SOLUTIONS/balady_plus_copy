import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';
import 'package:collection/collection.dart';

List<ResturantModel> resturantFromJson(List list) =>
    List<ResturantModel>.from(list.map((x) => ResturantModel.fromJson(x)));

class ResturantModel extends PointLayersData {
  int? objectId;
  String? xCoordinate;
  String? yCoordinate;
  String? streetName;
  String? activityDetailedDescription;
  String? tradeName;
  String? regionId;
  String? amanaId;
  String? districtId;
  String? cityId;
  String? sunday;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? frIdAy;
  String? saturday;
  String? rate;
  String? openStatus;
  String? review;
  ResturantModel({
    required super.id,
    required super.name,
    required super.type,
    required super.description,
    required super.latLng,
    this.activityDetailedDescription,
    this.amanaId,
    this.cityId,
    this.districtId,
    this.frIdAy,
    this.monday,
    this.objectId,
    this.openStatus,
    this.rate,
    this.regionId,
    this.review,
    this.saturday,
    this.streetName,
    this.sunday,
    this.thursday,
    this.tradeName,
    this.tuesday,
    this.wednesday,
    this.xCoordinate,
    this.yCoordinate,
  });

  factory ResturantModel.fromJson(Map<String, dynamic> json) => ResturantModel(
    id: json['attributes']["OBJECTID"].toString(),
    name: json['attributes']["TRADENAME"] ?? '',
    description: json['attributes']["ACTIVITY_DETAILED_DESCRIPTION"] ?? '',
    type: json['attributes']["ACTIVITY_DETAILED_DESCRIPTION"]?.toString() ?? '',
    objectId: json['attributes']["OBJECTID"] ?? '',
    xCoordinate: json['attributes']["XCOORDINATE"] ?? '',
    yCoordinate: json['attributes']["YCOORDINATE"] ?? '',
    streetName: json['attributes']["STREET_NAME"] ?? '',
    activityDetailedDescription: json['attributes']["ACTIVITY_DETAILED_DESCRIPTION"] ?? '',
    tradeName: json['attributes']["TRADENAME"] ?? '',
    regionId: json['attributes']["REGION_ID"] ?? '',
    amanaId: json['attributes']["AMANA_ID"] ?? '',
    districtId: json['attributes']["DISTRICT_ID"] ?? '',
    cityId: json['attributes']["CITY_ID"] ?? '',
    sunday: json['attributes']["SUNDAY"] ?? '',
    monday: json['attributes']["MONDAY"] ?? '',
    tuesday: json['attributes']["TUESDAY"] ?? '',
    wednesday: json['attributes']["WEDNESDAY"] ?? '',
    thursday: json['attributes']["THURSDAY"] ?? '',
    frIdAy: json['attributes']["FRIDAY"] ?? '',
    saturday: json['attributes']["SATURDAY"] ?? '',
    rate: json['attributes']["RATE"] ?? '',
    openStatus: json['attributes']["OPENSTATUS"] ?? '',
    review: json['attributes']["REVIEW"] ?? '',
    latLng: GeoPointWithElevationMessage(
      elevation: 1,
      latitude: double.parse(json['geometry']["y"].toString()),
      longitude: double.parse(json['geometry']["x"].toString()),
    ),
  );

  String get getRating => rate != null && rate!.trim().isNotEmpty ? "$rate/5" : "";
  String get getReviews => review != null && review!.trim().isNotEmpty ? "($review)" : "";
  String get getAddress =>
      [streetName, districtId, cityId, regionId].nonNulls.whereNot((element) => element.isEmpty).join(", ");

  String? getCurrentDay() {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return monday?.replaceAll("الاثنين،", "");

      case DateTime.tuesday:
        return tuesday?.replaceAll("الثلاثاء،", "");

      case DateTime.wednesday:
        return wednesday?.replaceAll("الأربعاء،", "");

      case DateTime.thursday:
        return thursday?.replaceAll("الخميس،", "");

      case DateTime.friday:
        return frIdAy?.replaceAll("الجمعة،", "");

      case DateTime.saturday:
        return saturday?.replaceAll("السبت،", "");

      case DateTime.sunday:
        return sunday?.replaceAll("الأحد،", "");

      default:
        return "";
    }
  }

  String? getDayByNameIndex(int index) {
    switch (index) {
      case 1:
        return sunday?.split("،")[0];

      case 2:
        return monday?.split("،")[0];

      case 3:
        return tuesday?.split("،")[0];

      case 4:
        return wednesday?.split("،")[0];

      case 5:
        return thursday?.split("،")[0];

      case 6:
        return frIdAy?.split("،")[0];

      case 7:
        return saturday?.split("،")[0];

      default:
        return "";
    }
  }

  String? getDayByIndex(int index) {
    switch (index) {
      case 1:
        return sunday?.replaceAll("الأحد،", "");

      case 2:
        return monday?.replaceAll("الاثنين،", "");

      case 3:
        return tuesday?.replaceAll("الثلاثاء،", "");

      case 4:
        return wednesday?.replaceAll("الأربعاء،", "");

      case 5:
        return thursday?.replaceAll("الخميس،", "");

      case 6:
        return frIdAy?.replaceAll("الجمعة،", "");

      case 7:
        return saturday?.replaceAll("السبت،", "");

      default:
        return "";
    }
  }

  bool get showWorkingHours =>
      sunday != null && sunday!.isNotEmpty ||
      monday != null && monday!.isNotEmpty ||
      tuesday != null && tuesday!.isNotEmpty ||
      wednesday != null && wednesday!.isNotEmpty ||
      thursday != null && thursday!.isNotEmpty ||
      frIdAy != null && frIdAy!.isNotEmpty ||
      saturday != null && saturday!.isNotEmpty;

  int get shiftNo => (getCurrentDay()?.split("،").length ?? 0);
  String? get getFirstShift => getCurrentDay()?.split("،")[0];
  String? get getSecondShift => shiftNo > 1 ? getFirstShift?.split("،")[0] : null;

  String? get getThirdhift => shiftNo > 2 ? getSecondShift?.split("،")[0] : null;

  int shiftsNOByIndex(int index) => (getDayByIndex(index)?.split("،").length ?? 0);
  String? getFirstShiftByIndex(int index) => getDayByIndex(index)?.split("،")[0];
  String? getSecondShiftByIndex(int index) => shiftsNOByIndex(index) > 1 ? getDayByIndex(index)?.split("،")[1] : null;
  String? getThirdShiftByIndex(int index) => shiftsNOByIndex(index) > 2 ? getDayByIndex(index)?.split("،")[2] : null;
}
