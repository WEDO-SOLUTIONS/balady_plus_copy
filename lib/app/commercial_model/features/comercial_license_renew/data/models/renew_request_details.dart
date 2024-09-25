
class RenewRequestDetails {
  final int? requestId;
  final int? statusId;
  final String? statusName;
  final String? subMunicipalityId;
  final String? subMunicipalityName;
  final int? typeId;
  final String? typeName;
  final int? licenseTypeId;
  final String? licenseTypeName;
  final String? lastUpdateDate;
  final LicenseInfo? licenseInfo;
  final List<AttachmentsInfo>? attachmentsInfo;
  final List<dynamic>? requestNotesInfo;
  final CalculatorResponse? calculatorResponse;
  final bool? insidePetrolStation;

  RenewRequestDetails(
      {this.requestId,
      this.statusId,
      this.statusName,
      this.subMunicipalityId,
      this.subMunicipalityName,
      this.typeId,
      this.typeName,
      this.licenseTypeId,
      this.licenseTypeName,
      this.lastUpdateDate,
      this.licenseInfo,
      this.attachmentsInfo,
      this.requestNotesInfo,
      this.calculatorResponse,
      this.insidePetrolStation});

  factory RenewRequestDetails.fromJson(Map<String, dynamic> json) =>
      RenewRequestDetails(
          requestId: json["requestId"],
          statusId: json["statusId"],
          statusName: json["statusName"],
          subMunicipalityId: json["subMunicipalityId"],
          subMunicipalityName: json["subMunicipalityName"],
          typeId: json["typeId"],
          typeName: json["typeName"],
          licenseTypeId: json["licenseTypeId"],
          licenseTypeName: json["licenseTypeName"],
          lastUpdateDate: json["lastUpdateDate"],
          licenseInfo: json["licenseInfo"] == null
              ? null
              : LicenseInfo.fromJson(json["licenseInfo"]),
          attachmentsInfo: json["attachmentsInfo"] == null
              ? []
              : List<AttachmentsInfo>.from(json["attachmentsInfo"]!
                  .map((x) => AttachmentsInfo.fromJson(x))),
          requestNotesInfo: json["requestNotesInfo"] == null
              ? []
              : List<dynamic>.from(json["requestNotesInfo"]!.map((x) => x)),
          calculatorResponse: json["calculatorResponse"] == null
              ? null
              : CalculatorResponse.fromJson(json["calculatorResponse"]),
          insidePetrolStation: json["insidePetrolStation"]);

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "statusId": statusId,
        "statusName": statusName,
        "subMunicipalityId": subMunicipalityId,
        "subMunicipalityName": subMunicipalityName,
        "typeId": typeId,
        "typeName": typeName,
        "licenseTypeId": licenseTypeId,
        "licenseTypeName": licenseTypeName,
        "lastUpdateDate": lastUpdateDate,
        "licenseInfo": licenseInfo?.toJson(),
        "attachmentsInfo": attachmentsInfo == null
            ? []
            : List<dynamic>.from(attachmentsInfo!.map((x) => x.toJson())),
        "requestNotesInfo": requestNotesInfo == null
            ? []
            : List<dynamic>.from(requestNotesInfo!.map((x) => x)),
        "calculatorResponse": calculatorResponse?.toJson(),
      };
}

class AttachmentsInfo {
  final int? id;
  final String? name;
  final String? allowedFilesExtension;
  final bool? attached;
  final bool? approved;
  final String? attachUrl;
  final int? maxSize;
  final dynamic notes;
  final String? attachDescription;
  final String? originFileName;

  AttachmentsInfo({
    this.id,
    this.name,
    this.allowedFilesExtension,
    this.attached,
    this.approved,
    this.attachUrl,
    this.maxSize,
    this.notes,
    this.attachDescription,
    this.originFileName,
  });

  factory AttachmentsInfo.fromJson(Map<String, dynamic> json) =>
      AttachmentsInfo(
        id: json["id"],
        name: json["name"],
        allowedFilesExtension: json["allowedFilesExtension"],
        attached: json["attached"],
        approved: json["approved"],
        attachUrl: json["attachUrl"],
        maxSize: json["maxSize"],
        notes: json["notes"],
        attachDescription: json["attachDescription"],
        originFileName: json["originFileName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "allowedFilesExtension": allowedFilesExtension,
        "attached": attached,
        "approved": approved,
        "attachUrl": attachUrl,
        "maxSize": maxSize,
        "notes": notes,
        "attachDescription": attachDescription,
        "originFileName": originFileName,
      };
}

class CalculatorResponse {
  final double? totalCost;
  final List<CostsInfo>? costsInfo;
  final dynamic detailedCostList;
  final int? paymentYearsCount;
  final double? renewYearsCount;
  final List<ActivitiesCostDetaile>? activitiesCostDetailes;

  CalculatorResponse({
    this.totalCost,
    this.costsInfo,
    this.detailedCostList,
    this.paymentYearsCount,
    this.renewYearsCount,
    this.activitiesCostDetailes,
  });

  factory CalculatorResponse.fromJson(Map<String, dynamic> json) =>
      CalculatorResponse(
        totalCost: json["TotalCost"]?.toDouble(),
        costsInfo: json["CostsInfo"] == null
            ? []
            : List<CostsInfo>.from(
                json["CostsInfo"]!.map((x) => CostsInfo.fromJson(x))),
        detailedCostList: json["DetailedCostList"],
        paymentYearsCount: json["PaymentYearsCount"],
        renewYearsCount: json["RenewYearsCount"]?.toDouble(),
        activitiesCostDetailes: json["ActivitiesCostDetailes"] == null
            ? []
            : List<ActivitiesCostDetaile>.from(json["ActivitiesCostDetailes"]!
                .map((x) => ActivitiesCostDetaile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "TotalCost": totalCost,
        "CostsInfo": costsInfo == null
            ? []
            : List<dynamic>.from(costsInfo!.map((x) => x.toJson())),
        "DetailedCostList": detailedCostList,
        "PaymentYearsCount": paymentYearsCount,
        "RenewYearsCount": renewYearsCount,
        "ActivitiesCostDetailes": activitiesCostDetailes == null
            ? []
            : List<dynamic>.from(
                activitiesCostDetailes!.map((x) => x.toJson())),
      };
}

class ActivitiesCostDetaile {
  final String? refrence;
  final double? activtyCost;
  final double? cleaningCost;

  ActivitiesCostDetaile({
    this.refrence,
    this.activtyCost,
    this.cleaningCost,
  });

  factory ActivitiesCostDetaile.fromJson(Map<String, dynamic> json) =>
      ActivitiesCostDetaile(
        refrence: json["Refrence"],
        activtyCost: json["ActivtyCost"]?.toDouble(),
        cleaningCost: json["CleaningCost"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Refrence": refrence,
        "ActivtyCost": activtyCost,
        "CleaningCost": cleaningCost,
      };
}

class CostsInfo {
  final String? costItemDescription;
  final int? costItemTypeId;
  final double? costItemValue;

  CostsInfo({
    this.costItemDescription,
    this.costItemTypeId,
    this.costItemValue,
  });

  factory CostsInfo.fromJson(Map<String, dynamic> json) => CostsInfo(
        costItemDescription: json["CostItemDescription"],
        costItemTypeId: json["CostItemTypeId"],
        costItemValue: json["CostItemValue"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "CostItemDescription": costItemDescription,
        "CostItemTypeId": costItemTypeId,
        "CostItemValue": costItemValue,
      };
}

class LicenseInfo {
  final int? licenseId;
  final int? statusId;
  final String? statusName;
  final String? issueDate;
  final String? licenseEndDate;
  final String? licenseSadadEndDate;

  LicenseInfo({
    this.licenseId,
    this.statusId,
    this.statusName,
    this.issueDate,
    this.licenseEndDate,
    this.licenseSadadEndDate,
  });

  factory LicenseInfo.fromJson(Map<String, dynamic> json) => LicenseInfo(
        licenseId: json["licenseId"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        issueDate: json["issueDate"],
        licenseEndDate: json["licenseEndDate"],
        licenseSadadEndDate: json["licenseSadadEndDate"],
      );

  Map<String, dynamic> toJson() => {
        "licenseId": licenseId,
        "statusId": statusId,
        "statusName": statusName,
        "issueDate": issueDate,
        "licenseEndDate": licenseEndDate,
        "licenseSadadEndDate": licenseSadadEndDate,
      };
}
