import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

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
  ResturantModel(
      {required id,
      required name,
      required type,
      required description,
      required latLng,
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
      this.YCOORDINATE})
      : super(
            id: id,
            name: name,
            description: description,
            type: type,
            latLng: latLng);

  factory ResturantModel.fromJson(Map<String, dynamic> json) => ResturantModel(
        id: json['attributes']["OBJECTID"].toString(),
        name: json['attributes']["TRADENAME"] ?? '',
        description: json['attributes']["ACTIVITY_DETAILED_DESCRIPTION"] ?? '',
        type: json['attributes']["ACTIVITY_DETAILED_DESCRIPTION"]?.toString() ??
            '',
        OBJECTID: json['attributes']["OBJECTID"] ?? '',
        XCOORDINATE: json['attributes']["XCOORDINATE"] ?? '',
        YCOORDINATE: json['attributes']["YCOORDINATE"] ?? '',
        STREET_NAME: json['attributes']["STREET_NAME"] ?? '',
        ACTIVITY_DETAILED_DESCRIPTION:
            json['attributes']["ACTIVITY_DETAILED_DESCRIPTION"] ?? '',
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
}
