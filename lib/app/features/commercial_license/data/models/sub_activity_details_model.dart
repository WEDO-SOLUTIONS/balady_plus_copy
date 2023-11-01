import '../../commercial_license_exports.dart';

class SubActivityModelDetailsModel extends SubActivityDetails {
  SubActivityModelDetailsModel({
    super.id,
    super.name,
    super.ename,
    super.nameEn,
    super.maxArea,
    super.minArea,
    super.mainActivity,
    super.isicNumber,
    super.subActivity,
    super.isLicenseOwnerFemaleOnly,
    super.isWorkerTypeFemaleOnly,
    super.activityTerms,
    super.unit,
    super.unitDesc,
    super.minYears,
    super.maxYears,
    super.isTabacco,
    super.fawry,
    super.twentyFourHourStatus,
    super.vehicleParkingPermit,
    super.entityType,
    super.vehicleType,
    super.pathType,
    super.foodActivity,
    super.ownershipType,
    super.requestFlow,
  });

  factory SubActivityModelDetailsModel.fromJson(Map<String, dynamic> json) =>
      SubActivityModelDetailsModel(
        id: json["id"],
        name: json["name"],
        ename: json["ename"],
        nameEn: json["nameEn"],
        maxArea: json["maxArea"]?.toDouble(),
        minArea: json["minArea"]?.toDouble(),
        mainActivity: json["mainActivity"] == null
            ? null
            : MainActivityModel.fromJson(json["mainActivity"]),
        isicNumber: json["isicNumber"],
        subActivity: json["subActivityModel"] == null
            ? null
            : SubSubActivityModel.fromJson(json["subActivityModel"]),
        isLicenseOwnerFemaleOnly: json["isLicenseOwnerFemaleOnly"],
        isWorkerTypeFemaleOnly: json["isWorkerTypeFemaleOnly"],
        activityTerms: json["activityTerms"] == null
            ? []
            : List<ActivityTermModel>.from(json["activityTerms"]!
                .map((x) => ActivityTermModel.fromJson(x))),
        unit: json["unit"],
        unitDesc: json["unitDesc"],
        minYears: json["minYears"],
        maxYears: json["maxYears"],
        isTabacco: json["isTabacco"],
        fawry: json["fawry"],
        twentyFourHourStatus: json["twentyFourHourStatus"],
        vehicleParkingPermit: json["vehicleParkingPermit"],
        entityType: json["entityType"],
        vehicleType: json["vehicleType"],
        pathType: json["pathType"],
        foodActivity: json["foodActivity"],
        ownershipType: json["ownershipType"],
        requestFlow: json["requestFlow"],
      );
}

class ActivityTermModel extends ActivityTerm {
  ActivityTermModel({
    super.sectionName,
    super.sectionContent,
  });

  factory ActivityTermModel.fromJson(Map<String, dynamic> json) =>
      ActivityTermModel(
        sectionName: json["sectionName"],
        sectionContent: json["sectionContent"] == null
            ? []
            : List<SectionContentModel>.from(json["sectionContent"]!
                .map((x) => SectionContentModel.fromJson(x))),
      );
}

class SectionContentModel extends SectionContent {
  SectionContentModel({
    super.label,
    super.value,
  });

  factory SectionContentModel.fromJson(Map<String, dynamic> json) =>
      SectionContentModel(
        label: json["label"],
        value: json["value"] == null
            ? []
            : List<String>.from(json["value"]!.map((x) => x)),
      );
}

class MainActivityModel extends MainActivity {
  MainActivityModel({
    super.id,
    super.nameAr,
    super.nameEn,
    super.activityTypeId,
    super.craft,
    super.craftMessage,
  });

  factory MainActivityModel.fromJson(Map<String, dynamic> json) =>
      MainActivityModel(
        id: json["id"],
        nameAr: json["nameAr"],
        nameEn: json["nameEn"],
        activityTypeId: json["activityTypeId"],
        craft: json["craft"],
        craftMessage: json["craftMessage"],
      );
}

class SubSubActivityModel extends SubSubActivity {
  SubSubActivityModel({
    super.id,
    super.nameAr,
    super.nameEn,
  });

  factory SubSubActivityModel.fromJson(Map<String, dynamic> json) =>
      SubSubActivityModel(
        id: json["id"],
        nameAr: json["nameAr"],
        nameEn: json["nameEn"],
      );
}

class StatusDetailsModel extends StatusDetails {
  StatusDetailsModel({
    super.code,
    super.message,
  });

  factory StatusDetailsModel.fromJson(Map<String, dynamic> json) =>
      StatusDetailsModel(
        code: json["code"],
        message: json["message"],
      );
}
