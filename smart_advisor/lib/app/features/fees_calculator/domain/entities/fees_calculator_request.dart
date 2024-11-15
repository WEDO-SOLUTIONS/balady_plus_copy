import '../../../select_activity/domain/entities/addetional_activites_response.dart';

class FeesCalculatorRequest {
  final String? municipalityGisCode;
  final String? longitude;
  final String? latitude;
  final int? activityId;
  final int? licensePeriod;
  final double? shopArea;
  final String? cleanOption;
  final String? unitCount;
  final int? accommodationTypeId;
  final List<Permit>? permits;
  final List<Board>? boards;
  final String? atmFeesPaid;
  final String? crNumber;
  List<AddetionalActivityItem>? addetionalActivites;

  FeesCalculatorRequest(
      {this.municipalityGisCode,
      this.longitude,
      this.latitude,
      this.activityId,
      this.licensePeriod,
      this.shopArea,
      this.cleanOption,
      this.unitCount,
      this.accommodationTypeId,
      this.permits,
      this.boards,
      this.atmFeesPaid,
      this.crNumber,
      this.addetionalActivites});

  factory FeesCalculatorRequest.fromJson(Map<String, dynamic> json) =>
      FeesCalculatorRequest(
        municipalityGisCode: json["municipalityGisCode"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        activityId: json["activityId"],
        licensePeriod: json["licensePeriod"],
        shopArea: json["shopArea"],
        cleanOption: json["cleanOption"],
        unitCount: json["unitCount"],
        accommodationTypeId: json["accommodationTypeId"],
        permits: json["permits"] == null
            ? []
            : List<Permit>.from(
                json["permits"]!.map((x) => Permit.fromJson(x))),
        boards: json["boards"] == null
            ? []
            : List<Board>.from(json["boards"]!.map((x) => Board.fromJson(x))),
        atmFeesPaid: json["atmFeesPaid"],
      );

  Map<String, dynamic> toJson() => {
        "municipalityGisCode": municipalityGisCode,
        "longitude": longitude,
        "latitude": latitude,
        "activityId": activityId,
        "licensePeriod": licensePeriod,
        "shopArea": shopArea.toString(),
        "cleanOption": cleanOption,
        "unitCount": unitCount,
        "accommodationTypeId": accommodationTypeId,
        if (permits != null && permits!.isNotEmpty)
          "permits": permits == null
              ? []
              : List<dynamic>.from(permits!.map((x) => x.toJson())),
        if (boards != null && boards!.isNotEmpty)
          "boards": boards == null
              ? []
              : List<dynamic>.from(boards!.map((x) => x.toJson())),
        "atmFeesPaid": atmFeesPaid != null
            ? atmFeesPaid == "ATTACH"
                ? true
                : false
            : null,
        "crNumber": crNumber,
        if (addetionalActivites != null && addetionalActivites!.isNotEmpty)
          "additionalActivities": addetionalActivites == null
              ? []
              : List<dynamic>.from(addetionalActivites!.map((x) => {
                    "activityId": x.activityId.toString(),
                    "area": x.area.toString(),
                  })),
      };
}

class Board {
  final int? typeId;
  final double? area;

  Board({
    this.typeId,
    this.area,
  });

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        typeId: json["typeId"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "typeId": typeId,
        "area": area.toString(),
      };
}

class Permit {
  final int? permitTypeId;
  final SideWalk? sideWalk;
  final dynamic nonFoodVehicleCount;
  final dynamic permitName;

  Permit({
    this.permitTypeId,
    this.sideWalk,
    this.nonFoodVehicleCount,
    this.permitName,
  });

  factory Permit.fromJson(Map<String, dynamic> json) => Permit(
        permitTypeId: json["permitTypeId"],
        sideWalk: json["sideWalk"] == null
            ? null
            : SideWalk.fromJson(json["sideWalk"]),
        nonFoodVehicleCount: json["nonFoodVehicleCount"],
        permitName: json["permitName"],
      );

  Map<String, dynamic> toJson() => {
        "permitTypeId": permitTypeId,
        "sideWalk": sideWalk?.toJson(),
        "nonFoodVehicleCount": nonFoodVehicleCount,
        "permitName": permitName,
      };
}

class SideWalk {
  final int? length;
  final int? width;
  final int? days;

  SideWalk({
    this.length,
    this.width,
    this.days,
  });

  factory SideWalk.fromJson(Map<String, dynamic> json) => SideWalk(
        length: json["length"],
        width: json["width"],
        days: json["days"],
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "width": width,
        "days": days,
      };
}
