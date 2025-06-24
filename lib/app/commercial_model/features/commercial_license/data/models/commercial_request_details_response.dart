// To parse this JSON data, do
//
//     final commercialRequestDetailsResponse = commercialRequestDetailsResponseFromJson(jsonString);

import 'dart:convert';

CommercialRequestDetailsResponse commercialRequestDetailsResponseFromJson(
        String str) =>
    CommercialRequestDetailsResponse.fromJson(json.decode(str));

String commercialRequestDetailsResponseToJson(
        CommercialRequestDetailsResponse data) =>
    json.encode(data.toJson());

class CommercialRequestDetailsResponse {
  final int? requestId;
  final double? mainActivityArea;
  final String? creationDate;
  final String? entityType;
  final int? currentTabId;
  final int? statusId;
  final String? statusName;
  final int? typeId;
  final String? typeName;
  final int? licensePeriod;
  final int? originalLicensePeriod;
  final int? sadadPeriod;
  final int? entryMode;
  final String? cleanOptions;
  final bool? groceryActivity;
  final bool? municipalityApproval;
  final String? notes;
  final dynamic employeeNotes;
  final String? clientNotes;
  final LicenseInfo? licenseInfo;
  final SalamaInfo? salamaInfo;
  final dynamic objectionNotesInfo;
  final dynamic warningMessages;
  final dynamic warningInfo;
  final dynamic latestRequestId;
  final bool? isRejectedStatus;
  final bool? isSalamaStatus;
  final bool? isCanceledByObservationStatus;
  final dynamic renewMode;
  final bool? investmentSite;
  final dynamic billUrl;
  final bool? fawryWithSalama;
  final dynamic requestPathType;
  final dynamic engineeringOffice;
  final List<dynamic>? shopReviews;
  final List<TransactionsList>? transactionsList;
  final dynamic issuingMunicipalityId;
  final dynamic issuingMunicipalityName;
  final dynamic requestApprovals;
  final dynamic facilityChangeMsg;
  final dynamic period;
  final String? endorsementText;
  final dynamic refuseShopReviewsList;
  final dynamic etmamOrderInfo;
  final dynamic licenceHoldInfoStatusResponseDto;
  final String? boardContractSetting;
  final String? selectedBoardContractOption;
  final dynamic boardContractNumber;
  final dynamic modificationReason;
  final Warnings? warnings;
  final dynamic requestSource;
  final dynamic rejectionInfo;
  final bool? showSalamaPermit;
  final List<dynamic>? requestNotesList;
  final bool? craft;
  final dynamic craftMessage;
  final dynamic contactInfo;
  final ActivityInfo? activityInfo;
  final LocationInfo? locationInfo;
  final SubmitterInfo? submitterInfo;
  final ShopInfo? shopInfo;
  final dynamic billsInfo;
  final bool? selectLicYears;
  final bool? showTillActive;
  final dynamic observationProviderType;
  final List<Activity>? activities;
  final bool? insidePetrolStation;
  final double? shopArea;

  CommercialRequestDetailsResponse(
      {this.requestId,
      this.mainActivityArea,
      this.creationDate,
      this.entityType,
      this.currentTabId,
      this.statusId,
      this.statusName,
      this.typeId,
      this.typeName,
      this.licensePeriod,
      this.originalLicensePeriod,
      this.sadadPeriod,
      this.entryMode,
      this.cleanOptions,
      this.groceryActivity,
      this.municipalityApproval,
      this.notes,
      this.employeeNotes,
      this.clientNotes,
      this.licenseInfo,
      this.salamaInfo,
      this.objectionNotesInfo,
      this.warningMessages,
      this.warningInfo,
      this.latestRequestId,
      this.isRejectedStatus,
      this.isSalamaStatus,
      this.isCanceledByObservationStatus,
      this.renewMode,
      this.investmentSite,
      this.billUrl,
      this.fawryWithSalama,
      this.requestPathType,
      this.engineeringOffice,
      this.shopReviews,
      this.transactionsList,
      this.issuingMunicipalityId,
      this.issuingMunicipalityName,
      this.requestApprovals,
      this.facilityChangeMsg,
      this.period,
      this.endorsementText,
      this.refuseShopReviewsList,
      this.etmamOrderInfo,
      this.licenceHoldInfoStatusResponseDto,
      this.boardContractSetting,
      this.selectedBoardContractOption,
      this.boardContractNumber,
      this.modificationReason,
      this.warnings,
      this.requestSource,
      this.rejectionInfo,
      this.showSalamaPermit,
      this.requestNotesList,
      this.craft,
      this.craftMessage,
      this.contactInfo,
      this.activityInfo,
      this.locationInfo,
      this.submitterInfo,
      this.shopInfo,
      this.billsInfo,
      this.selectLicYears,
      this.showTillActive,
      this.observationProviderType,
      this.activities,
      this.insidePetrolStation,
      this.shopArea
      });

  factory CommercialRequestDetailsResponse.fromJson(
          Map<String, dynamic> json) =>
      CommercialRequestDetailsResponse(
        requestId: json["requestId"],
        mainActivityArea: json["mainActivityArea"]?.toDouble(),
        creationDate: json["creationDate"],
        entityType: json["entityType"],
        currentTabId: json["currentTabId"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        typeId: json["typeId"],
        typeName: json["typeName"],
        licensePeriod: json["licensePeriod"],
        originalLicensePeriod: json["originalLicensePeriod"],
        sadadPeriod: json["sadadPeriod"],
        entryMode: json["entryMode"],
        cleanOptions: json["cleanOptions"],
        groceryActivity: json["groceryActivity"],
        municipalityApproval: json["municipalityApproval"],
        notes: json["notes"],
        employeeNotes: json["employeeNotes"],
        clientNotes: json["clientNotes"],
        licenseInfo: json["licenseInfo"] == null
            ? null
            : LicenseInfo.fromJson(json["licenseInfo"]),
        salamaInfo: json["salamaInfo"] == null
            ? null
            : SalamaInfo.fromJson(json["salamaInfo"]),
        objectionNotesInfo: json["objectionNotesInfo"],
        warningMessages: json["warningMessages"],
        warningInfo: json["warningInfo"],
        latestRequestId: json["latestRequestId"],
        isRejectedStatus: json["isRejectedStatus"],
        isSalamaStatus: json["isSalamaStatus"],
        isCanceledByObservationStatus: json["isCanceledByObservationStatus"],
        renewMode: json["renewMode"],
        investmentSite: json["investmentSite"],
        billUrl: json["billUrl"],
        fawryWithSalama: json["fawryWithSalama"],
        requestPathType: json["requestPathType"],
        engineeringOffice: json["engineeringOffice"],
        insidePetrolStation: json["insidePetrolStation"],
        shopReviews: json["shopReviews"] == null
            ? []
            : List<dynamic>.from(json["shopReviews"]!.map((x) => x)),
        transactionsList: json["transactionsList"] == null
            ? []
            : List<TransactionsList>.from(json["transactionsList"]!
                .map((x) => TransactionsList.fromJson(x))),
        issuingMunicipalityId: json["issuingMunicipalityId"],
        issuingMunicipalityName: json["issuingMunicipalityName"],
        requestApprovals: json["requestApprovals"],
        facilityChangeMsg: json["facilityChangeMsg"],
        period: json["period"],
        endorsementText: json["endorsementText"],
        refuseShopReviewsList: json["refuseShopReviewsList"],
        etmamOrderInfo: json["etmamOrderInfo"],
        licenceHoldInfoStatusResponseDto:
            json["licenceHoldInfoStatusResponseDto"],
        boardContractSetting: json["boardContractSetting"],
        selectedBoardContractOption: json["selectedBoardContractOption"],
        boardContractNumber: json["boardContractNumber"],
        modificationReason: json["modificationReason"],
        warnings: json["warnings"] == null
            ? null
            : Warnings.fromJson(json["warnings"]),
        requestSource: json["requestSource"],
        rejectionInfo: json["rejectionInfo"],
        showSalamaPermit: json["showSalamaPermit"],
        requestNotesList: json["requestNotesList"] == null
            ? []
            : List<dynamic>.from(json["requestNotesList"]!.map((x) => x)),
        craft: json["craft"],
        craftMessage: json["craftMessage"],
        contactInfo: json["contactInfo"],
        activityInfo: json["activityInfo"] == null
            ? null
            : ActivityInfo.fromJson(json["activityInfo"]),
        locationInfo: json["locationInfo"] == null
            ? null
            : LocationInfo.fromJson(json["locationInfo"]),
        submitterInfo: json["submitterInfo"] == null
            ? null
            : SubmitterInfo.fromJson(json["submitterInfo"]),
        shopInfo: json["shopInfo"] == null
            ? null
            : ShopInfo.fromJson(json["shopInfo"]),
        billsInfo: json["billsInfo"],
        selectLicYears: json["selectLicYears"],
        showTillActive: json["showTillActive"],
        observationProviderType: json["observationProviderType"],
        activities: json["activities"] == null
            ? []
            : List<Activity>.from(
                json["activities"]!.map((x) => Activity.fromJson(x))),
                shopArea: json["shopArea"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "mainActivityArea": mainActivityArea,
        "creationDate": creationDate,
        "entityType": entityType,
        "currentTabId": currentTabId,
        "statusId": statusId,
        "statusName": statusName,
        "typeId": typeId,
        "typeName": typeName,
        "licensePeriod": licensePeriod,
        "originalLicensePeriod": originalLicensePeriod,
        "sadadPeriod": sadadPeriod,
        "entryMode": entryMode,
        "cleanOptions": cleanOptions,
        "groceryActivity": groceryActivity,
        "municipalityApproval": municipalityApproval,
        "notes": notes,
        "employeeNotes": employeeNotes,
        "clientNotes": clientNotes,
        "licenseInfo": licenseInfo?.toJson(),
        "salamaInfo": salamaInfo?.toJson(),
        "objectionNotesInfo": objectionNotesInfo,
        "warningMessages": warningMessages,
        "warningInfo": warningInfo,
        "latestRequestId": latestRequestId,
        "isRejectedStatus": isRejectedStatus,
        "isSalamaStatus": isSalamaStatus,
        "isCanceledByObservationStatus": isCanceledByObservationStatus,
        "renewMode": renewMode,
        "investmentSite": investmentSite,
        "billUrl": billUrl,
        "fawryWithSalama": fawryWithSalama,
        "requestPathType": requestPathType,
        "engineeringOffice": engineeringOffice,
        "shopReviews": shopReviews == null
            ? []
            : List<dynamic>.from(shopReviews!.map((x) => x)),
        "transactionsList": transactionsList == null
            ? []
            : List<dynamic>.from(transactionsList!.map((x) => x.toJson())),
        "issuingMunicipalityId": issuingMunicipalityId,
        "issuingMunicipalityName": issuingMunicipalityName,
        "requestApprovals": requestApprovals,
        "facilityChangeMsg": facilityChangeMsg,
        "period": period,
        "endorsementText": endorsementText,
        "refuseShopReviewsList": refuseShopReviewsList,
        "etmamOrderInfo": etmamOrderInfo,
        "licenceHoldInfoStatusResponseDto": licenceHoldInfoStatusResponseDto,
        "boardContractSetting": boardContractSetting,
        "selectedBoardContractOption": selectedBoardContractOption,
        "boardContractNumber": boardContractNumber,
        "modificationReason": modificationReason,
        "warnings": warnings?.toJson(),
        "requestSource": requestSource,
        "rejectionInfo": rejectionInfo,
        "showSalamaPermit": showSalamaPermit,
        "requestNotesList": requestNotesList == null
            ? []
            : List<dynamic>.from(requestNotesList!.map((x) => x)),
        "craft": craft,
        "craftMessage": craftMessage,
        "contactInfo": contactInfo,
        "activityInfo": activityInfo?.toJson(),
        "locationInfo": locationInfo?.toJson(),
        "submitterInfo": submitterInfo?.toJson(),
        "shopInfo": shopInfo?.toJson(),
        "billsInfo": billsInfo,
        "selectLicYears": selectLicYears,
        "showTillActive": showTillActive,
        "observationProviderType": observationProviderType,
        "activities": activities == null
            ? []
            : List<dynamic>.from(activities!.map((x) => x.toJson())),
            "shopArea": shopArea,
      };
}

class Activity {
  final String? isicCode;
  final String? isicName;
  final bool? existInBalady;
  final bool? atmActivity;
  final bool? valid;
  final dynamic message;

  Activity({
    this.isicCode,
    this.isicName,
    this.existInBalady,
    this.atmActivity,
    this.valid,
    this.message,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        isicCode: json["isicCode"],
        isicName: json["isicName"],
        existInBalady: json["existInBalady"],
        atmActivity: json["atmActivity"],
        valid: json["valid"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "isicCode": isicCode,
        "isicName": isicName,
        "existInBalady": existInBalady,
        "atmActivity": atmActivity,
        "valid": valid,
        "message": message,
      };
}

class ActivityInfo {
  final MainActivityElement? mainActivity;
  final List<MainActivityElement>? additionalActivities;
  final bool? foreignInvistor;
  final int? workerTypeId;
  final String? workerTypeName;
  final dynamic activityChangeReason;
  final bool? showAtmFeesOption;
  final bool? atmFeesPaid;
  final bool? atmActivity;
  final List<dynamic>? inHomogenusActivities;
  final String? salamaWorkflowWarningMessage;

  ActivityInfo({
    this.mainActivity,
    this.additionalActivities,
    this.foreignInvistor,
    this.workerTypeId,
    this.workerTypeName,
    this.activityChangeReason,
    this.showAtmFeesOption,
    this.atmFeesPaid,
    this.atmActivity,
    this.inHomogenusActivities,
    this.salamaWorkflowWarningMessage,
  });

  factory ActivityInfo.fromJson(Map<String, dynamic> json) => ActivityInfo(
        mainActivity: json["mainActivity"] == null
            ? null
            : MainActivityElement.fromJson(json["mainActivity"]),
        additionalActivities: json["additionalActivities"] == null
            ? []
            : List<MainActivityElement>.from(json["additionalActivities"]!
                .map((x) => MainActivityElement.fromJson(x))),
        foreignInvistor: json["foreignInvistor"],
        workerTypeId: json["workerTypeId"],
        workerTypeName: json["workerTypeName"],
        activityChangeReason: json["activityChangeReason"],
        showAtmFeesOption: json["showAtmFeesOption"],
        atmFeesPaid: json["atmFeesPaid"],
        atmActivity: json["atmActivity"],
        inHomogenusActivities: json["inHomogenusActivities"] == null
            ? []
            : List<dynamic>.from(json["inHomogenusActivities"]!.map((x) => x)),
        salamaWorkflowWarningMessage: json["salamaWorkflowWarningMessage"],
      );

  Map<String, dynamic> toJson() => {
        "mainActivity": mainActivity?.toJson(),
        "additionalActivities": additionalActivities == null
            ? []
            : List<dynamic>.from(additionalActivities!.map((x) => x.toJson())),
        "foreignInvistor": foreignInvistor,
        "workerTypeId": workerTypeId,
        "workerTypeName": workerTypeName,
        "activityChangeReason": activityChangeReason,
        "showAtmFeesOption": showAtmFeesOption,
        "atmFeesPaid": atmFeesPaid,
        "atmActivity": atmActivity,
        "inHomogenusActivities": inHomogenusActivities == null
            ? []
            : List<dynamic>.from(inHomogenusActivities!.map((x) => x)),
        "salamaWorkflowWarningMessage": salamaWorkflowWarningMessage,
      };
}

class MainActivityElement {
  final int? detailedActivityId;
  final double? area;
  final dynamic unitCount;
  final dynamic accommodationTypeId;
  final dynamic accommodationTypeName;
  final String? detailedActivityName;
  final int? isicActivityId;
  final int? mainActivityId;
  final String? isicActivityName;
  final int? minYears;
  final int? maxYears;
  final bool? removed;
  final ActivitySettingDto? activitySettingDto;
  final dynamic minArea;
  final dynamic maxArea;
  final int? facilityId;
  final String? facilityName;
  final String? salamaWorkflow;

  MainActivityElement({
    this.detailedActivityId,
    this.area,
    this.unitCount,
    this.accommodationTypeId,
    this.accommodationTypeName,
    this.detailedActivityName,
    this.isicActivityId,
    this.mainActivityId,
    this.isicActivityName,
    this.minYears,
    this.maxYears,
    this.removed,
    this.activitySettingDto,
    this.minArea,
    this.maxArea,
    this.facilityId,
    this.facilityName,
    this.salamaWorkflow,
  });

  factory MainActivityElement.fromJson(Map<String, dynamic> json) =>
      MainActivityElement(
        detailedActivityId: json["detailedActivityId"],
        area: json["area"]?.toDouble(),
        unitCount: json["unitCount"],
        accommodationTypeId: json["accommodationTypeId"],
        accommodationTypeName: json["accommodationTypeName"],
        detailedActivityName: json["detailedActivityName"],
        isicActivityId: json["isicActivityId"],
        mainActivityId: json["mainActivityId"],
        isicActivityName: json["isicActivityName"],
        minYears: json["minYears"],
        maxYears: json["maxYears"],
        removed: json["removed"],
        activitySettingDto: json["activitySettingDto"] == null
            ? null
            : ActivitySettingDto.fromJson(json["activitySettingDto"]),
        minArea: json["minArea"],
        maxArea: json["maxArea"],
        facilityId: json["facilityId"],
        facilityName: json["facilityName"],
        salamaWorkflow: json["salamaWorkflow"],
      );

  Map<String, dynamic> toJson() => {
        "detailedActivityId": detailedActivityId,
        "area": area,
        "unitCount": unitCount,
        "accommodationTypeId": accommodationTypeId,
        "accommodationTypeName": accommodationTypeName,
        "detailedActivityName": detailedActivityName,
        "isicActivityId": isicActivityId,
        "mainActivityId": mainActivityId,
        "isicActivityName": isicActivityName,
        "minYears": minYears,
        "maxYears": maxYears,
        "removed": removed,
        "activitySettingDto": activitySettingDto?.toJson(),
        "minArea": minArea,
        "maxArea": maxArea,
        "facilityId": facilityId,
        "facilityName": facilityName,
        "salamaWorkflow": salamaWorkflow,
      };
}

class ActivitySettingDto {
  final int? entityType;
  final int? vehicleType;
  final int? pathType;
  final bool? foodActivity;
  final int? ownershipType;
  final int? requestFlow;

  ActivitySettingDto({
    this.entityType,
    this.vehicleType,
    this.pathType,
    this.foodActivity,
    this.ownershipType,
    this.requestFlow,
  });

  factory ActivitySettingDto.fromJson(Map<String, dynamic> json) =>
      ActivitySettingDto(
        entityType: json["entityType"],
        vehicleType: json["vehicleType"],
        pathType: json["pathType"],
        foodActivity: json["foodActivity"],
        ownershipType: json["ownershipType"],
        requestFlow: json["requestFlow"],
      );

  Map<String, dynamic> toJson() => {
        "entityType": entityType,
        "vehicleType": vehicleType,
        "pathType": pathType,
        "foodActivity": foodActivity,
        "ownershipType": ownershipType,
        "requestFlow": requestFlow,
      };
}

class LicenseInfo {
  final dynamic licenseEndDate;
  final dynamic licenseSadadEndDate;
  final dynamic licensePeriod;
  final dynamic sadadPeriod;
  final int? licenseId;
  final int? statusId;
  final dynamic expireInDays;
  final dynamic oldLicenseNo;
  final dynamic issueDate;
  final bool? expired;
  final String? printUrl;
  final String? qrCodeUrl;
  final int? qrRequestId;
  final String? statusDesc;

  LicenseInfo({
    this.licenseEndDate,
    this.licenseSadadEndDate,
    this.licensePeriod,
    this.sadadPeriod,
    this.licenseId,
    this.statusId,
    this.expireInDays,
    this.oldLicenseNo,
    this.issueDate,
    this.expired,
    this.printUrl,
    this.qrCodeUrl,
    this.qrRequestId,
    this.statusDesc,
  });

  factory LicenseInfo.fromJson(Map<String, dynamic> json) => LicenseInfo(
        licenseEndDate: json["licenseEndDate"],
        licenseSadadEndDate: json["licenseSadadEndDate"],
        licensePeriod: json["licensePeriod"],
        sadadPeriod: json["sadadPeriod"],
        licenseId: json["licenseId"],
        statusId: json["statusId"],
        expireInDays: json["expireInDays"],
        oldLicenseNo: json["oldLicenseNo"],
        issueDate: json["issueDate"],
        expired: json["expired"],
        printUrl: json["printUrl"],
        qrCodeUrl: json["qrCodeUrl"],
        qrRequestId: json["qrRequestId"],
        statusDesc: json["statusDesc"],
      );

  Map<String, dynamic> toJson() => {
        "licenseEndDate": licenseEndDate,
        "licenseSadadEndDate": licenseSadadEndDate,
        "licensePeriod": licensePeriod,
        "sadadPeriod": sadadPeriod,
        "licenseId": licenseId,
        "statusId": statusId,
        "expireInDays": expireInDays,
        "oldLicenseNo": oldLicenseNo,
        "issueDate": issueDate,
        "expired": expired,
        "printUrl": printUrl,
        "qrCodeUrl": qrCodeUrl,
        "qrRequestId": qrRequestId,
        "statusDesc": statusDesc,
      };
}

class LocationInfo {
  final String? subMunicipalityGisCode;
  final int? districtCode;
  final int? streetCode;
  final String? latitude;
  final String? longitude;
  final String? mapNo;
  final String? landNo;
  final String? streetName;
  final String? districtName;
  final String? subMunicipalityName;
  final String? municipalityId;
  final String? municipalityName;
  final String? subMunicipalityId;
  final int? regionId;
  final String? regionName;
  final dynamic vehiclePathDesc;
  final String? krokiUrl;
  final StatusDto? status;

  LocationInfo({
    this.status,
    this.subMunicipalityGisCode,
    this.districtCode,
    this.streetCode,
    this.latitude,
    this.longitude,
    this.mapNo,
    this.landNo,
    this.streetName,
    this.districtName,
    this.subMunicipalityName,
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.regionId,
    this.regionName,
    this.vehiclePathDesc,
    this.krokiUrl,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
      subMunicipalityGisCode: json["subMunicipalityGisCode"],
      districtCode: json["districtCode"],
      streetCode: json["streetCode"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      mapNo: json["mapNo"],
      landNo: json["landNo"],
      streetName: json["streetName"],
      districtName: json["districtName"],
      subMunicipalityName: json["subMunicipalityName"],
      municipalityId: json["municipalityId"],
      municipalityName: json["municipalityName"],
      subMunicipalityId: json["subMunicipalityId"],
      regionId: json["regionId"],
      regionName: json["regionName"],
      vehiclePathDesc: json["vehiclePathDesc"],
      krokiUrl: json["krokiUrl"],
      status:
          json["status"] != null ? StatusDto.fromJson(json["status"]) : null);

  Map<String, dynamic> toJson() => {
        "subMunicipalityGisCode": subMunicipalityGisCode,
        "districtCode": districtCode,
        "streetCode": streetCode,
        "latitude": latitude,
        "longitude": longitude,
        "mapNo": mapNo,
        "landNo": landNo,
        "streetName": streetName,
        "districtName": districtName,
        "subMunicipalityName": subMunicipalityName,
        "municipalityId": municipalityId,
        "municipalityName": municipalityName,
        "subMunicipalityId": subMunicipalityId,
        "regionId": regionId,
        "regionName": regionName,
        "vehiclePathDesc": vehiclePathDesc,
        "krokiUrl": krokiUrl,
      };
}

class SalamaInfo {
  final dynamic salamaIssueDate;
  final dynamic salamaIssueNo;
  final dynamic salamaApprovedCenterId;
  final dynamic salamaApprovedCenterName;

  SalamaInfo({
    this.salamaIssueDate,
    this.salamaIssueNo,
    this.salamaApprovedCenterId,
    this.salamaApprovedCenterName,
  });

  factory SalamaInfo.fromJson(Map<String, dynamic> json) => SalamaInfo(
        salamaIssueDate: json["salamaIssueDate"],
        salamaIssueNo: json["salamaIssueNo"],
        salamaApprovedCenterId: json["salamaApprovedCenterId"],
        salamaApprovedCenterName: json["salamaApprovedCenterName"],
      );

  Map<String, dynamic> toJson() => {
        "salamaIssueDate": salamaIssueDate,
        "salamaIssueNo": salamaIssueNo,
        "salamaApprovedCenterId": salamaApprovedCenterId,
        "salamaApprovedCenterName": salamaApprovedCenterName,
      };
}

class ShopInfo {
  final String? shopName;
  final int? shopUnitNumber;
  final int? holesCount;
  final bool? existInMall;
  final dynamic floorNumber;
  final int? floorCount;
  final bool? hasElevator;
  final bool? isCitizenPledgedToClean;
  final dynamic cleanContractEndDate;
  final dynamic buildingLicenseDate;
  final dynamic buildingLicenseNo;
  final dynamic buildingOwnerIdno;
  final dynamic buildingOwnerName;
  final String? landNumber;
  final String? planNumber;
  final dynamic salamaBillNumber;
  final List<BoardsInfo>? boardsInfo;
  final ContractInfoResponseDto? contractInfoResponseDto;
  final bool? showShopOwnership;
  final List<String>? slamaBillOptions;
  final String? cameraBillOptions;
  final String? endorsementText;
  final List<String>? slamaReportOptions;
  final dynamic slamaReportNumber;
  final dynamic isFawryWithSalamaBill;
  final dynamic isFawryWithSalamaReport;
  final dynamic cleanContractInfo;
  final CleanContractOptions? cleanContractOptions;
  final bool? showActivityCancellationDate;
  final dynamic activityCancellationDate;
  final dynamic mallDto;
  final dynamic blockNumber;
  final dynamic cancelReasonDto;
  final bool? brand;
  final dynamic salamaPermitNumber;
  final dynamic licenseBrand;
  final int? noOfCameras;

  ShopInfo({
    this.shopName,
    this.shopUnitNumber,
    this.holesCount,
    this.existInMall,
    this.floorNumber,
    this.floorCount,
    this.hasElevator,
    this.isCitizenPledgedToClean,
    this.cleanContractEndDate,
    this.buildingLicenseDate,
    this.buildingLicenseNo,
    this.buildingOwnerIdno,
    this.buildingOwnerName,
    this.landNumber,
    this.planNumber,
    this.salamaBillNumber,
    this.boardsInfo,
    this.contractInfoResponseDto,
    this.showShopOwnership,
    this.slamaBillOptions,
    this.cameraBillOptions,
    this.endorsementText,
    this.slamaReportOptions,
    this.slamaReportNumber,
    this.isFawryWithSalamaBill,
    this.isFawryWithSalamaReport,
    this.cleanContractInfo,
    this.cleanContractOptions,
    this.showActivityCancellationDate,
    this.activityCancellationDate,
    this.mallDto,
    this.blockNumber,
    this.cancelReasonDto,
    this.brand,
    this.salamaPermitNumber,
    this.licenseBrand,
    this.noOfCameras,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        shopName: json["shopName"],
        shopUnitNumber: json["shopUnitNumber"],
        holesCount: json["holesCount"],
        existInMall: json["existInMall"],
        floorNumber: json["floorNumber"],
        floorCount: json["floorCount"],
        hasElevator: json["hasElevator"],
        isCitizenPledgedToClean: json["isCitizenPledgedToClean"],
        cleanContractEndDate: json["cleanContractEndDate"],
        buildingLicenseDate: json["buildingLicenseDate"],
        buildingLicenseNo: json["buildingLicenseNo"],
        buildingOwnerIdno: json["buildingOwnerIdno"],
        buildingOwnerName: json["buildingOwnerName"],
        landNumber: json["landNumber"],
        planNumber: json["planNumber"],
        salamaBillNumber: json["salamaBillNumber"],
        boardsInfo: json["boardsInfo"] == null
            ? []
            : List<BoardsInfo>.from(
                json["boardsInfo"]!.map((x) => BoardsInfo.fromJson(x))),
        contractInfoResponseDto: json["contractInfoResponseDto"] == null
            ? null
            : ContractInfoResponseDto.fromJson(json["contractInfoResponseDto"]),
        showShopOwnership: json["showShopOwnership"],
        slamaBillOptions: json["slamaBillOptions"] == null
            ? []
            : List<String>.from(json["slamaBillOptions"]!.map((x) => x)),
        cameraBillOptions: json["cameraBillOptions"],
        endorsementText: json["endorsementText"],
        slamaReportOptions: json["slamaReportOptions"] == null
            ? []
            : List<String>.from(json["slamaReportOptions"]!.map((x) => x)),
        slamaReportNumber: json["slamaReportNumber"],
        isFawryWithSalamaBill: json["isFawryWithSalamaBill"],
        isFawryWithSalamaReport: json["isFawryWithSalamaReport"],
        cleanContractInfo: json["cleanContractInfo"],
        cleanContractOptions: json["cleanContractOptions"] == null
            ? null
            : CleanContractOptions.fromJson(json["cleanContractOptions"]),
        showActivityCancellationDate: json["showActivityCancellationDate"],
        activityCancellationDate: json["activityCancellationDate"],
        mallDto: json["mallDto"],
        blockNumber: json["blockNumber"],
        cancelReasonDto: json["cancelReasonDto"],
        brand: json["brand"],
        salamaPermitNumber: json["salamaPermitNumber"],
        licenseBrand: json["licenseBrand"],
        noOfCameras: json["noOfCameras"],
      );

  Map<String, dynamic> toJson() => {
        "shopName": shopName,
        "shopUnitNumber": shopUnitNumber,
        "holesCount": holesCount,
        "existInMall": existInMall,
        "floorNumber": floorNumber,
        "floorCount": floorCount,
        "hasElevator": hasElevator,
        "isCitizenPledgedToClean": isCitizenPledgedToClean,
        "cleanContractEndDate": cleanContractEndDate,
        "buildingLicenseDate": buildingLicenseDate,
        "buildingLicenseNo": buildingLicenseNo,
        "buildingOwnerIdno": buildingOwnerIdno,
        "buildingOwnerName": buildingOwnerName,
        "landNumber": landNumber,
        "planNumber": planNumber,
        "salamaBillNumber": salamaBillNumber,
        "boardsInfo": boardsInfo == null
            ? []
            : List<dynamic>.from(boardsInfo!.map((x) => x.toJson())),
        "contractInfoResponseDto": contractInfoResponseDto?.toJson(),
        "showShopOwnership": showShopOwnership,
        "slamaBillOptions": slamaBillOptions == null
            ? []
            : List<dynamic>.from(slamaBillOptions!.map((x) => x)),
        "cameraBillOptions": cameraBillOptions,
        "endorsementText": endorsementText,
        "slamaReportOptions": slamaReportOptions == null
            ? []
            : List<dynamic>.from(slamaReportOptions!.map((x) => x)),
        "slamaReportNumber": slamaReportNumber,
        "isFawryWithSalamaBill": isFawryWithSalamaBill,
        "isFawryWithSalamaReport": isFawryWithSalamaReport,
        "cleanContractInfo": cleanContractInfo,
        "cleanContractOptions": cleanContractOptions?.toJson(),
        "showActivityCancellationDate": showActivityCancellationDate,
        "activityCancellationDate": activityCancellationDate,
        "mallDto": mallDto,
        "blockNumber": blockNumber,
        "cancelReasonDto": cancelReasonDto,
        "brand": brand,
        "salamaPermitNumber": salamaPermitNumber,
        "licenseBrand": licenseBrand,
        "noOfCameras": noOfCameras,
      };
}

class BoardsInfo {
  final int? typeId;
  final String? typeName;
  final double? area;

  BoardsInfo({
    this.typeId,
    this.typeName,
    this.area,
  });

  factory BoardsInfo.fromJson(Map<String, dynamic> json) => BoardsInfo(
        typeId: json["typeId"],
        typeName: json["typeName"],
        area: json["area"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "typeId": typeId,
        "typeName": typeName,
        "area": area,
      };
}

class CleanContractOptions {
  final String? cleanOption;
  final String? contractOption;

  CleanContractOptions({
    this.cleanOption,
    this.contractOption,
  });

  factory CleanContractOptions.fromJson(Map<String, dynamic> json) =>
      CleanContractOptions(
        cleanOption: json["cleanOption"],
        contractOption: json["contractOption"],
      );

  Map<String, dynamic> toJson() => {
        "cleanOption": cleanOption,
        "contractOption": contractOption,
      };
}

class ContractInfoResponseDto {
  final String? contractType;
  final String? contractOption;
  final dynamic tenancyContractInfo;
  final dynamic deedInfoResponse;
  final String? contractDate;
  final String? contractNumber;
  final ContractOptionsResponseDto? contractOptionsResponseDto;
  final dynamic investmentContractNumber;

  ContractInfoResponseDto({
    this.contractType,
    this.contractOption,
    this.tenancyContractInfo,
    this.deedInfoResponse,
    this.contractDate,
    this.contractNumber,
    this.contractOptionsResponseDto,
    this.investmentContractNumber,
  });

  factory ContractInfoResponseDto.fromJson(Map<String, dynamic> json) =>
      ContractInfoResponseDto(
        contractType: json["contractType"],
        contractOption: json["contractOption"],
        tenancyContractInfo: json["tenancyContractInfo"],
        deedInfoResponse: json["deedInfoResponse"],
        contractDate: json["contractDate"],
        contractNumber: json["contractNumber"],
        contractOptionsResponseDto: json["contractOptionsResponseDto"] == null
            ? null
            : ContractOptionsResponseDto.fromJson(
                json["contractOptionsResponseDto"]),
        investmentContractNumber: json["investmentContractNumber"],
      );

  Map<String, dynamic> toJson() => {
        "contractType": contractType,
        "contractOption": contractOption,
        "tenancyContractInfo": tenancyContractInfo,
        "deedInfoResponse": deedInfoResponse,
        "contractDate": contractDate,
        "contractNumber": contractNumber,
        "contractOptionsResponseDto": contractOptionsResponseDto?.toJson(),
        "investmentContractNumber": investmentContractNumber,
      };
}

class StatusDto {
  int? id;
  String? name;

  StatusDto({
    this.id,
    this.name,
  });

  factory StatusDto.fromJson(Map<String, dynamic> json) =>
      StatusDto(id: json["id"], name: json['name']);
}

class ContractOptionsResponseDto {
  final List<String>? ejarOptions;
  final List<String>? deedOptions;
  final List<String>? investOptions;

  ContractOptionsResponseDto({
    this.ejarOptions,
    this.deedOptions,
    this.investOptions,
  });

  factory ContractOptionsResponseDto.fromJson(Map<String, dynamic> json) =>
      ContractOptionsResponseDto(
        ejarOptions: json["ejarOptions"] == null
            ? []
            : List<String>.from(json["ejarOptions"]!.map((x) => x)),
        deedOptions: json["deedOptions"] == null
            ? []
            : List<String>.from(json["deedOptions"]!.map((x) => x)),
        investOptions: json["investOptions"] == null
            ? []
            : List<String>.from(json["investOptions"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "ejarOptions": ejarOptions == null
            ? []
            : List<dynamic>.from(ejarOptions!.map((x) => x)),
        "deedOptions": deedOptions == null
            ? []
            : List<dynamic>.from(deedOptions!.map((x) => x)),
        "investOptions": investOptions == null
            ? []
            : List<dynamic>.from(investOptions!.map((x) => x)),
      };
}

class SubmitterInfo {
  final String? entityType;
  final String? submitterType;
  final String? crNumber;
  final String? crType;
  final int? submitterIdNumber;
  final String? submitterBirthDate;
  final String? mobile;
  final int? gender;
  final String? submitterName;
  final String? entityName;
  final String? crIssueDate;
  final String? crSource;
  final String? genderDesc;
  final dynamic submitterIdType;
  final int? crEntityType;

  SubmitterInfo({
    this.entityType,
    this.submitterType,
    this.crNumber,
    this.crType,
    this.submitterIdNumber,
    this.submitterBirthDate,
    this.mobile,
    this.gender,
    this.submitterName,
    this.entityName,
    this.crIssueDate,
    this.crSource,
    this.genderDesc,
    this.submitterIdType,
    this.crEntityType,
  });

  factory SubmitterInfo.fromJson(Map<String, dynamic> json) => SubmitterInfo(
        entityType: json["entityType"],
        submitterType: json["submitterType"],
        crNumber: json["crNumber"],
        crType: json["crType"],
        submitterIdNumber: json["submitterIdNumber"],
        submitterBirthDate: json["submitterBirthDate"],
        mobile: json["mobile"],
        gender: json["gender"],
        submitterName: json["submitterName"],
        entityName: json["entityName"],
        crIssueDate: json["crIssueDate"],
        crSource: json["crSource"],
        genderDesc: json["genderDesc"],
        submitterIdType: json["submitterIdType"],
        crEntityType: json["crEntityType"],
      );

  Map<String, dynamic> toJson() => {
        "entityType": entityType,
        "submitterType": submitterType,
        "crNumber": crNumber,
        "crType": crType,
        "submitterIdNumber": submitterIdNumber,
        "submitterBirthDate": submitterBirthDate,
        "mobile": mobile,
        "gender": gender,
        "submitterName": submitterName,
        "entityName": entityName,
        "crIssueDate": crIssueDate,
        "crSource": crSource,
        "genderDesc": genderDesc,
        "submitterIdType": submitterIdType,
        "crEntityType": crEntityType,
      };
}

class TransactionsList {
  final String? actorName;
  final int? statusId;
  final String? statusName;
  final int? oldStatusId;
  final String? oldStatusName;
  final String? creationDate;
  final dynamic notes;

  TransactionsList({
    this.actorName,
    this.statusId,
    this.statusName,
    this.oldStatusId,
    this.oldStatusName,
    this.creationDate,
    this.notes,
  });

  factory TransactionsList.fromJson(Map<String, dynamic> json) =>
      TransactionsList(
        actorName: json["actorName"],
        statusId: json["statusId"],
        statusName: json["statusName"],
        oldStatusId: json["oldStatusId"],
        oldStatusName: json["oldStatusName"],
        creationDate: json["creationDate"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "actorName": actorName,
        "statusId": statusId,
        "statusName": statusName,
        "oldStatusId": oldStatusId,
        "oldStatusName": oldStatusName,
        "creationDate": creationDate,
        "notes": notes,
      };
}

class Warnings {
  Warnings();

  factory Warnings.fromJson(Map<String, dynamic> json) => Warnings();

  Map<String, dynamic> toJson() => {};
}
