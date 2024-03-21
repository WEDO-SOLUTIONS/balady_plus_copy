class CommercialLicenceDetails {
  int requestId;
  double mainActivityArea;
  String creationDate;
  String entityType;
  int currentTabId;
  int statusId;
  String statusName;
  int typeId;
  String typeName;
  int licensePeriod;
  int originalLicensePeriod;
  int sadadPeriod;
  int entryMode;
  String cleanOptions;
  bool groceryActivity;
  bool municipalityApproval;
  String notes;
  String employeeNotes;
  // dynamic clientNotes;
  LicenseInfo licenseInfo;
  // SalamaInfo salamaInfo;
  // dynamic objectionNotesInfo;
  // dynamic warningMessages;
  // dynamic warningInfo;
  // dynamic latestRequestId;
  // bool isRejectedStatus;
  // bool isSalamaStatus;
  // bool isCanceledByObservationStatus;
  // dynamic renewMode;
  // bool investmentSite;
  // String billUrl;
  // bool fawryWithSalama;
  // dynamic requestPathType;
  // dynamic engineeringOffice;
  // List<dynamic> shopReviews;
  // dynamic transactionsList;
  // dynamic issuingMunicipalityId;
  // dynamic issuingMunicipalityName;
  // dynamic requestApprovals;
  // dynamic facilityChangeMsg;
  // dynamic period;
  // String endorsementText;
  // dynamic refuseShopReviewsList;
  // dynamic etmamOrderInfo;
  // LicenceHoldInfoStatusResponseDto licenceHoldInfoStatusResponseDto;
  // String boardContractSetting;
  // String selectedBoardContractOption;
  // dynamic boardContractNumber;
  // dynamic modificationReason;
  // Warnings warnings;
  // dynamic requestSource;
  // dynamic rejectionInfo;
  // bool craft;
  // dynamic craftMessage;
  // dynamic contactInfo;
  ActivityInfo activityInfo;
  LocationInfo locationInfo;
  SubmitterInfo submitterInfo;
  ShopInfo shopInfo;
  final List<LicensePermit>? licensePermits;

  // List<BillsInfo> billsInfo;
  // bool selectLicYears;
  // bool showTillActive;
  // dynamic observationProviderType;
  // List<Activity> activities;

  CommercialLicenceDetails(
      {required this.requestId,
      required this.mainActivityArea,
      required this.creationDate,
      required this.entityType,
      required this.currentTabId,
      required this.statusId,
      required this.statusName,
      required this.typeId,
      required this.typeName,
      required this.licensePeriod,
      required this.originalLicensePeriod,
      required this.sadadPeriod,
      required this.entryMode,
      required this.cleanOptions,
      required this.groceryActivity,
      required this.municipalityApproval,
      required this.notes,
      required this.employeeNotes,
      // required this.clientNotes,
      required this.licenseInfo,
      // required this.salamaInfo,
      // required this.objectionNotesInfo,
      // required this.warningMessages,
      // required this.warningInfo,
      // required this.latestRequestId,
      // required this.isRejectedStatus,
      // required this.isSalamaStatus,
      // required this.isCanceledByObservationStatus,
      // required this.renewMode,
      // required this.investmentSite,
      // required this.billUrl,
      // required this.fawryWithSalama,
      // required this.requestPathType,
      // required this.engineeringOffice,
      // required this.shopReviews,
      // required this.transactionsList,
      // required this.issuingMunicipalityId,
      // required this.issuingMunicipalityName,
      // required this.requestApprovals,
      // required this.facilityChangeMsg,
      // required this.period,
      // required this.endorsementText,
      // required this.refuseShopReviewsList,
      // required this.etmamOrderInfo,
      // required this.licenceHoldInfoStatusResponseDto,
      // required this.boardContractSetting,
      // required this.selectedBoardContractOption,
      // required this.boardContractNumber,
      // required this.modificationReason,
      // required this.warnings,
      // required this.requestSource,
      // required this.rejectionInfo,
      // required this.craft,
      // required this.craftMessage,
      // required this.contactInfo,
      required this.activityInfo,
      required this.locationInfo,
      required this.submitterInfo,
      required this.shopInfo,
      this.licensePermits
      // required this.billsInfo,
      // required this.selectLicYears,
      // required this.showTillActive,
      // required this.observationProviderType,
      // required this.activities,
      });

  factory CommercialLicenceDetails.fromJson(Map<String, dynamic> json) =>
      CommercialLicenceDetails(
        requestId: json["requestId"],
        mainActivityArea: json["mainActivityArea"],
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
        // clientNotes: json["clientNotes"],
        licenseInfo: LicenseInfo.fromJson(json["licenseInfo"]),
        // salamaInfo: SalamaInfo.fromJson(json["salamaInfo"]),
        // objectionNotesInfo: json["objectionNotesInfo"],
        // warningMessages: json["warningMessages"],
        // warningInfo: json["warningInfo"],
        // latestRequestId: json["latestRequestId"],
        // isRejectedStatus: json["isRejectedStatus"],
        // isSalamaStatus: json["isSalamaStatus"],
        // isCanceledByObservationStatus: json["isCanceledByObservationStatus"],
        // renewMode: json["renewMode"],
        // investmentSite: json["investmentSite"],
        // billUrl: json["billUrl"],
        // fawryWithSalama: json["fawryWithSalama"],
        // requestPathType: json["requestPathType"],
        // engineeringOffice: json["engineeringOffice"],
        // shopReviews: List<dynamic>.from(json["shopReviews"].map((x) => x)),
        // transactionsList: json["transactionsList"],
        // issuingMunicipalityId: json["issuingMunicipalityId"],
        // issuingMunicipalityName: json["issuingMunicipalityName"],
        // requestApprovals: json["requestApprovals"],
        // facilityChangeMsg: json["facilityChangeMsg"],
        // period: json["period"],
        // endorsementText: json["endorsementText"],
        // refuseShopReviewsList: json["refuseShopReviewsList"],
        // etmamOrderInfo: json["etmamOrderInfo"],
        // licenceHoldInfoStatusResponseDto: LicenceHoldInfoStatusResponseDto.fromJson(json["licenceHoldInfoStatusResponseDto"]),
        // boardContractSetting: json["boardContractSetting"],
        // selectedBoardContractOption: json["selectedBoardContractOption"],
        // boardContractNumber: json["boardContractNumber"],
        // modificationReason: json["modificationReason"],
        // warnings: Warnings.fromJson(json["warnings"]),
        // requestSource: json["requestSource"],
        // rejectionInfo: json["rejectionInfo"],
        // craft: json["craft"],
        // craftMessage: json["craftMessage"],
        // contactInfo: json["contactInfo"],
        activityInfo: ActivityInfo.fromJson(json["activityInfo"]),
        locationInfo: LocationInfo.fromJson(json["locationInfo"]),
        submitterInfo: SubmitterInfo.fromJson(json["submitterInfo"]),
        shopInfo: ShopInfo.fromJson(json["shopInfo"]),
        licensePermits: json["licensePermits"] == null
            ? []
            : List<LicensePermit>.from(
                json["licensePermits"]!.map((x) => LicensePermit.fromJson(x))),

        // billsInfo: List<BillsInfo>.from(json["billsInfo"].map((x) => BillsInfo.fromJson(x))),
        // selectLicYears: json["selectLicYears"],
        // showTillActive: json["showTillActive"],
        // observationProviderType: json["observationProviderType"],
        // activities: List<Activity>.from(json["activities"].map((x) => Activity.fromJson(x))),
      );
}

class LicensePermit {
  final int? id;
  final String? name;
  final BaladyWorkFlow? baladyWorkFlow;
  final bool? withFees;

  LicensePermit({
    this.id,
    this.name,
    this.baladyWorkFlow,
    this.withFees,
  });

  factory LicensePermit.fromJson(Map<String, dynamic> json) => LicensePermit(
        id: json["id"],
        name: json["name"],
        baladyWorkFlow: json["baladyWorkFlow"] == null
            ? null
            : BaladyWorkFlow.fromJson(json["baladyWorkFlow"]),
        withFees: json["withFees"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "baladyWorkFlow": baladyWorkFlow?.toJson(),
        "withFees": withFees,
      };
}

class BaladyWorkFlow {
  final String? id;
  final String? name;

  BaladyWorkFlow({
    this.id,
    this.name,
  });

  factory BaladyWorkFlow.fromJson(Map<String, dynamic> json) => BaladyWorkFlow(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Activity {
  String isicCode;
  String isicName;
  bool existInBalady;
  bool atmActivity;
  bool valid;
  dynamic message;

  Activity({
    required this.isicCode,
    required this.isicName,
    required this.existInBalady,
    required this.atmActivity,
    required this.valid,
    required this.message,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        isicCode: json["isicCode"],
        isicName: json["isicName"],
        existInBalady: json["existInBalady"],
        atmActivity: json["atmActivity"],
        valid: json["valid"],
        message: json["message"],
      );
}

class ActivityInfo {
  MainActivity mainActivity;
  dynamic additionalActivities;
  // bool foreignInvistor;
  // int workerTypeId;
  // String workerTypeName;
  // dynamic activityChangeReason;
  // bool showAtmFeesOption;
  // bool atmFeesPaid;
  // bool atmActivity;
  // dynamic inHomogenusActivities;

  ActivityInfo({
    required this.mainActivity,
    required this.additionalActivities,
    // required this.foreignInvistor,
    // required this.workerTypeId,
    // required this.workerTypeName,
    // required this.activityChangeReason,
    // required this.showAtmFeesOption,
    // required this.atmFeesPaid,
    // required this.atmActivity,
    // required this.inHomogenusActivities,
  });

  factory ActivityInfo.fromJson(Map<String, dynamic> json) => ActivityInfo(
        mainActivity: MainActivity.fromJson(json["mainActivity"]),
        additionalActivities: json["additionalActivities"],
        // foreignInvistor: json["foreignInvistor"],
        // workerTypeId: json["workerTypeId"],
        // workerTypeName: json["workerTypeName"],
        // activityChangeReason: json["activityChangeReason"],
        // showAtmFeesOption: json["showAtmFeesOption"],
        // atmFeesPaid: json["atmFeesPaid"],
        // atmActivity: json["atmActivity"],
        // inHomogenusActivities: json["inHomogenusActivities"],
      );
}

class MainActivity {
  int detailedActivityId;
  double area;
  // dynamic unitCount;
  // dynamic accommodationTypeId;
  // dynamic accommodationTypeName;
  String detailedActivityName;
  // int isicActivityId;
  // int mainActivityId;
  String isicActivityName;
  // int minYears;
  // int maxYears;
  // bool removed;
  // ActivitySettingDto activitySettingDto;
  // dynamic minArea;
  // dynamic maxArea;
  // int facilityId;
  // String facilityName;

  MainActivity({
    required this.detailedActivityId,
    required this.area,
    // required this.unitCount,
    // required this.accommodationTypeId,
    // required this.accommodationTypeName,
    required this.detailedActivityName,
    // required this.isicActivityId,
    // required this.mainActivityId,
    required this.isicActivityName,
    // required this.minYears,
    // required this.maxYears,
    // required this.removed,
    // required this.activitySettingDto,
    // required this.minArea,
    // required this.maxArea,
    // required this.facilityId,
    // required this.facilityName,
  });

  factory MainActivity.fromJson(Map<String, dynamic> json) => MainActivity(
        detailedActivityId: json["detailedActivityId"],
        area: json["area"],
        // unitCount: json["unitCount"],
        // accommodationTypeId: json["accommodationTypeId"],
        // accommodationTypeName: json["accommodationTypeName"],
        detailedActivityName: json["detailedActivityName"],
        // isicActivityId: json["isicActivityId"],
        // mainActivityId: json["mainActivityId"],
        isicActivityName: json["isicActivityName"],
        // minYears: json["minYears"],
        // maxYears: json["maxYears"],
        // removed: json["removed"],
        // activitySettingDto: ActivitySettingDto.fromJson(json["activitySettingDto"]),
        // minArea: json["minArea"],
        // maxArea: json["maxArea"],
        // facilityId: json["facilityId"],
        // facilityName: json["facilityName"],
      );
}

class ActivitySettingDto {
  int entityType;
  int vehicleType;
  int pathType;
  bool foodActivity;
  int ownershipType;
  int requestFlow;

  ActivitySettingDto({
    required this.entityType,
    required this.vehicleType,
    required this.pathType,
    required this.foodActivity,
    required this.ownershipType,
    required this.requestFlow,
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
}

// class BillsInfo {
//   String billNumber;
//   int billAmount;
//   String paymentDate;
//   bool isSadadPaid;
//   List<BillFee> billFees;
//
//   BillsInfo({
//     required this.billNumber,
//     required this.billAmount,
//     required this.paymentDate,
//     required this.isSadadPaid,
//     required this.billFees,
//   });
//
//   factory BillsInfo.fromJson(Map<String, dynamic> json) => BillsInfo(
//     billNumber: json["billNumber"],
//     billAmount: json["billAmount"],
//     paymentDate: json["paymentDate"],
//     isSadadPaid: json["isSadadPaid"],
//     billFees: List<BillFee>.from(json["billFees"].map((x) => BillFee.fromJson(x))),
//   );
//
// }
//
// class BillFee {
//   int costItemValue;
//   int costItemTypeId;
//   String costItemDescription;
//
//   BillFee({
//     required this.costItemValue,
//     required this.costItemTypeId,
//     required this.costItemDescription,
//   });
//
//   factory BillFee.fromJson(Map<String, dynamic> json) => BillFee(
//     costItemValue: json["costItemValue"],
//     costItemTypeId: json["costItemTypeId"],
//     costItemDescription: json["costItemDescription"],
//   );
//
// }

// class LicenceHoldInfoStatusResponseDto {
//   bool hold;
//   int licenseId;
//   dynamic holdReason;
//   dynamic holdType;
//   dynamic holdedSevices;
//   String holdSource;
//
//   LicenceHoldInfoStatusResponseDto({
//     required this.hold,
//     required this.licenseId,
//     required this.holdReason,
//     required this.holdType,
//     required this.holdedSevices,
//     required this.holdSource,
//   });
//
//   factory LicenceHoldInfoStatusResponseDto.fromJson(Map<String, dynamic> json) => LicenceHoldInfoStatusResponseDto(
//     hold: json["hold"],
//     licenseId: json["licenseId"],
//     holdReason: json["holdReason"],
//     holdType: json["holdType"],
//     holdedSevices: json["holdedSevices"],
//     holdSource: json["holdSource"],
//   );
//
// }

class LicenseInfo {
  String licenseEndDate;
  String licenseSadadEndDate;
  dynamic licensePeriod;
  dynamic sadadPeriod;
  int licenseId;
  int statusId;
  int expireInDays;
  dynamic oldLicenseNo;
  String issueDate;
  bool expired;
  String printUrl;
  dynamic qrCodeUrl;
  dynamic qrRequestId;
  String statusDesc;

  LicenseInfo({
    required this.licenseEndDate,
    required this.licenseSadadEndDate,
    required this.licensePeriod,
    required this.sadadPeriod,
    required this.licenseId,
    required this.statusId,
    required this.expireInDays,
    required this.oldLicenseNo,
    required this.issueDate,
    required this.expired,
    required this.printUrl,
    required this.qrCodeUrl,
    required this.qrRequestId,
    required this.statusDesc,
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
}

class LocationInfo {
  String subMunicipalityGisCode;
  int districtCode;
  int streetCode;
  String latitude;
  String longitude;
  String mapNo;
  String landNo;
  String streetName;
  String districtName;
  String subMunicipalityName;
  String municipalityId;
  String municipalityName;
  String subMunicipalityId;
  int regionId;
  String regionName;
  dynamic vehiclePathDesc;
  String krokiUrl;

  LocationInfo({
    required this.subMunicipalityGisCode,
    required this.districtCode,
    required this.streetCode,
    required this.latitude,
    required this.longitude,
    required this.mapNo,
    required this.landNo,
    required this.streetName,
    required this.districtName,
    required this.subMunicipalityName,
    required this.municipalityId,
    required this.municipalityName,
    required this.subMunicipalityId,
    required this.regionId,
    required this.regionName,
    required this.vehiclePathDesc,
    required this.krokiUrl,
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
      );
}

class SalamaInfo {
  dynamic salamaIssueDate;
  dynamic salamaIssueNo;
  dynamic salamaApprovedCenterId;
  dynamic salamaApprovedCenterName;

  SalamaInfo({
    required this.salamaIssueDate,
    required this.salamaIssueNo,
    required this.salamaApprovedCenterId,
    required this.salamaApprovedCenterName,
  });

  factory SalamaInfo.fromJson(Map<String, dynamic> json) => SalamaInfo(
        salamaIssueDate: json["salamaIssueDate"],
        salamaIssueNo: json["salamaIssueNo"],
        salamaApprovedCenterId: json["salamaApprovedCenterId"],
        salamaApprovedCenterName: json["salamaApprovedCenterName"],
      );
}

class ShopInfo {
  String shopName;
  int shopUnitNumber;
  int holesCount;
  bool existInMall;
  dynamic floorNumber;
  int floorCount;
  // bool hasElevator;
  // bool isCitizenPledgedToClean;
  // dynamic cleanContractEndDate;
  // dynamic buildingLicenseDate;
  // dynamic buildingLicenseNo;
  // dynamic buildingOwnerIdno;
  // dynamic buildingOwnerName;
  String landNumber;
  String planNumber;
  // dynamic salamaBillNumber;
  // List<BoardsInfo> boardsInfo;
  // ContractInfoResponseDto contractInfoResponseDto;
  // bool showShopOwnership;
  // dynamic slamaBillOptions;
  String cameraBillOptions;
  String endorsementText;
  // dynamic slamaReportOptions;
  // dynamic slamaReportNumber;
  // dynamic cleanContractInfo;
  // CleanContractOptions cleanContractOptions;
  // bool showActivityCancellationDate;
  // dynamic activityCancellationDate;
  // dynamic mallDto;
  int blockNumber;
  // dynamic cancelReasonDto;
  // bool brand;
  // dynamic salamaPermitNumber;
  // bool licenseBrand;
  int noOfCameras;

  ShopInfo({
    required this.shopName,
    required this.shopUnitNumber,
    required this.holesCount,
    required this.existInMall,
    required this.floorNumber,
    required this.floorCount,
    // required this.hasElevator,
    // required this.isCitizenPledgedToClean,
    // required this.cleanContractEndDate,
    // required this.buildingLicenseDate,
    // required this.buildingLicenseNo,
    // required this.buildingOwnerIdno,
    // required this.buildingOwnerName,
    required this.landNumber,
    required this.planNumber,
    // required this.salamaBillNumber,
    // required this.boardsInfo,
    // required this.contractInfoResponseDto,
    // required this.showShopOwnership,
    // required this.slamaBillOptions,
    required this.cameraBillOptions,
    required this.endorsementText,
    // required this.slamaReportOptions,
    // required this.slamaReportNumber,
    // required this.cleanContractInfo,
    // required this.cleanContractOptions,
    // required this.showActivityCancellationDate,
    // required this.activityCancellationDate,
    // required this.mallDto,
    required this.blockNumber,
    // required this.cancelReasonDto,
    // required this.brand,
    // required this.salamaPermitNumber,
    // required this.licenseBrand,
    required this.noOfCameras,
  });

  factory ShopInfo.fromJson(Map<String, dynamic> json) => ShopInfo(
        shopName: json["shopName"],
        shopUnitNumber: json["shopUnitNumber"],
        holesCount: json["holesCount"],
        existInMall: json["existInMall"],
        floorNumber: json["floorNumber"],
        floorCount: json["floorCount"],
        // hasElevator: json["hasElevator"],
        // isCitizenPledgedToClean: json["isCitizenPledgedToClean"],
        // cleanContractEndDate: json["cleanContractEndDate"],
        // buildingLicenseDate: json["buildingLicenseDate"],
        // buildingLicenseNo: json["buildingLicenseNo"],
        // buildingOwnerIdno: json["buildingOwnerIdno"],
        // buildingOwnerName: json["buildingOwnerName"],
        landNumber: json["landNumber"],
        planNumber: json["planNumber"],
        // salamaBillNumber: json["salamaBillNumber"],
        // boardsInfo: List<BoardsInfo>.from(json["boardsInfo"].map((x) => BoardsInfo.fromJson(x))),
        // contractInfoResponseDto: ContractInfoResponseDto.fromJson(json["contractInfoResponseDto"]),
        // showShopOwnership: json["showShopOwnership"],
        // slamaBillOptions: json["slamaBillOptions"],
        cameraBillOptions: json["cameraBillOptions"],
        endorsementText: json["endorsementText"],
        // slamaReportOptions: json["slamaReportOptions"],
        // slamaReportNumber: json["slamaReportNumber"],
        // cleanContractInfo: json["cleanContractInfo"],
        // cleanContractOptions: CleanContractOptions.fromJson(json["cleanContractOptions"]),
        // showActivityCancellationDate: json["showActivityCancellationDate"],
        // activityCancellationDate: json["activityCancellationDate"],
        // mallDto: json["mallDto"],
        blockNumber: json["blockNumber"],
        // cancelReasonDto: json["cancelReasonDto"],
        // brand: json["brand"],
        // salamaPermitNumber: json["salamaPermitNumber"],
        // licenseBrand: json["licenseBrand"],
        noOfCameras: json["noOfCameras"],
      );
}

class BoardsInfo {
  int typeId;
  String typeName;
  int area;

  BoardsInfo({
    required this.typeId,
    required this.typeName,
    required this.area,
  });

  factory BoardsInfo.fromJson(Map<String, dynamic> json) => BoardsInfo(
        typeId: json["typeId"],
        typeName: json["typeName"],
        area: json["area"],
      );
}

class CleanContractOptions {
  String cleanOption;
  String contractOption;

  CleanContractOptions({
    required this.cleanOption,
    required this.contractOption,
  });

  factory CleanContractOptions.fromJson(Map<String, dynamic> json) =>
      CleanContractOptions(
        cleanOption: json["cleanOption"],
        contractOption: json["contractOption"],
      );
}

class ContractInfoResponseDto {
  String contractType;
  String contractOption;
  dynamic tenancyContractInfo;
  dynamic deedInfoResponse;
  String contractDate;
  String contractNumber;
  ContractOptionsResponseDto contractOptionsResponseDto;
  dynamic investmentContractNumber;

  ContractInfoResponseDto({
    required this.contractType,
    required this.contractOption,
    required this.tenancyContractInfo,
    required this.deedInfoResponse,
    required this.contractDate,
    required this.contractNumber,
    required this.contractOptionsResponseDto,
    required this.investmentContractNumber,
  });

  factory ContractInfoResponseDto.fromJson(Map<String, dynamic> json) =>
      ContractInfoResponseDto(
        contractType: json["contractType"],
        contractOption: json["contractOption"],
        tenancyContractInfo: json["tenancyContractInfo"],
        deedInfoResponse: json["deedInfoResponse"],
        contractDate: json["contractDate"],
        contractNumber: json["contractNumber"],
        contractOptionsResponseDto: ContractOptionsResponseDto.fromJson(
            json["contractOptionsResponseDto"]),
        investmentContractNumber: json["investmentContractNumber"],
      );
}

class ContractOptionsResponseDto {
  List<String> ejarOptions;
  List<String> deedOptions;
  List<String> investOptions;

  ContractOptionsResponseDto({
    required this.ejarOptions,
    required this.deedOptions,
    required this.investOptions,
  });

  factory ContractOptionsResponseDto.fromJson(Map<String, dynamic> json) =>
      ContractOptionsResponseDto(
        ejarOptions: List<String>.from(json["ejarOptions"].map((x) => x)),
        deedOptions: List<String>.from(json["deedOptions"].map((x) => x)),
        investOptions: List<String>.from(json["investOptions"].map((x) => x)),
      );
}

class SubmitterInfo {
  String entityType;
  String submitterType;
  String crNumber;
  String crType;
  int submitterIdNumber;
  String submitterBirthDate;
  String mobile;
  int gender;
  String submitterName;
  String entityName;
  dynamic crIssueDate;
  String crSource;
  String genderDesc;
  dynamic submitterIdType;
  int crEntityType;

  SubmitterInfo({
    required this.entityType,
    required this.submitterType,
    required this.crNumber,
    required this.crType,
    required this.submitterIdNumber,
    required this.submitterBirthDate,
    required this.mobile,
    required this.gender,
    required this.submitterName,
    required this.entityName,
    required this.crIssueDate,
    required this.crSource,
    required this.genderDesc,
    required this.submitterIdType,
    required this.crEntityType,
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
}

class Warnings {
  Warnings();

  factory Warnings.fromJson(Map<String, dynamic> json) => Warnings();

  Map<String, dynamic> toJson() => {};
}
