import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CommercialLicenceDetails {
  int? requestId;
  double? mainActivityArea;
  DateTime? creationDate;
  String? entityType;
  int? currentTabId;
  int? statusId;
  String? statusName;
  int? typeId;
  String? typeName;
  int? licensePeriod;
  int? originalLicensePeriod;
  int? sadadPeriod;
  int? entryMode;
  String? cleanOptions;
  bool? groceryActivity;
  bool? municipalityApproval;
  String? notes;
  dynamic employeeNotes;
  dynamic clientNotes;
  dynamic objectionNotesInfo;
  dynamic warningMessages;
  dynamic warningInfo;
  dynamic latestRequestId;
  bool? isRejectedStatus;
  bool? isSalamaStatus;
  bool? isCanceledByObservationStatus;
  dynamic renewMode;
  bool? investmentSite;
  String? billUrl;
  bool? fawryWithSalama;
  String? requestPathType;
  dynamic engineeringOffice;
  List<dynamic>? shopReviews;
  dynamic transactionsList;
  dynamic issuingMunicipalityId;
  dynamic issuingMunicipalityName;
  dynamic requestApprovals;
  dynamic facilityChangeMsg;
  dynamic period;
  String? endorsementText;
  dynamic refuseShopReviewsList;
  dynamic etmamOrderInfo;
  String? boardContractSetting;
  String? selectedBoardContractOption;
  dynamic boardContractNumber;
  dynamic modificationReason;
  dynamic warnings;
  dynamic requestSource;
  dynamic rejectionInfo;
  dynamic showSalamaPermit;
  dynamic requestNotesList;
  dynamic notificationHubAllowed;
  dynamic commercialOwnershipResponseDto;
  dynamic commercialCleanContractResponseDto;
  dynamic commercialSalamaResponseDto;
  bool? craft;
  dynamic craftMessage;
  dynamic contactInfo;
  bool? selectLicYears;
  bool? showTillActive;
  dynamic observationProviderType;
  dynamic salamaDetails;
  dynamic licenseCancellationInfo;

  List<LicenseAllowedPermitsInfo>? licenseAllowedPermitsInfo;
  ActivityInfo? activityInfo;
  LocationInfo? locationInfo;
  List<BillsInfo>? billsInfo;
  LicenceHoldInfoStatusResponseDto? licenceHoldInfoStatusResponseDto;

  LicenseInfo? licenseInfo;
  SalamaInfo? salamaInfo;
  SubmitterInfo? submitterInfo;
  ShopInfo? shopInfo;
  SalamaDetailsInfo? salamaDetailsInfo;
  OwnershipInfo? ownershipInfo;
  CleanContractInfo? cleanContractInfo;

  CommercialLicenceDetails({
    this.requestId,
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
    this.notificationHubAllowed,
    this.commercialOwnershipResponseDto,
    this.commercialCleanContractResponseDto,
    this.commercialSalamaResponseDto,
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
    this.salamaDetails,
    this.licenseCancellationInfo,
    this.licenseAllowedPermitsInfo,
  });

  CommercialLicenceDetails.fromJson(dynamic json) {
    requestId = json['requestId'];
    mainActivityArea = (json['mainActivityArea'] ?? 0.0) + 0.0;

    creationDate = json["creationDate"] != null
        ? DateFormat("yyyy/MM/dd ").parse(json["creationDate"])
        : null;
    entityType = json['entityType'];
    currentTabId = json['currentTabId'];
    statusId = json['statusId'];
    statusName = json['statusName'];
    typeId = json['typeId'];

    typeName = json['typeName'];
    licensePeriod = json['licensePeriod'];
    originalLicensePeriod = json['originalLicensePeriod'];
    sadadPeriod = json['sadadPeriod'];
    entryMode = json['entryMode'];
    cleanOptions = json['cleanOptions'];
    groceryActivity = json['groceryActivity'];
    municipalityApproval = json['municipalityApproval'];
    notes = json['notes'];
    employeeNotes = json['employeeNotes'];
    clientNotes = json['clientNotes'];
    objectionNotesInfo = json['objectionNotesInfo'];
    warningMessages = json['warningMessages'];
    warningInfo = json['warningInfo'];
    latestRequestId = json['latestRequestId'];
    isRejectedStatus = json['isRejectedStatus'];
    isSalamaStatus = json['isSalamaStatus'];
    isCanceledByObservationStatus = json['isCanceledByObservationStatus'];
    renewMode = json['renewMode'];
    investmentSite = json['investmentSite'];
    billUrl = json['billUrl'];
    fawryWithSalama = json['fawryWithSalama'];
    requestPathType = json['requestPathType'];
    engineeringOffice = json['engineeringOffice'];
    // if (json['shopReviews'] != null) {
    //   shopReviews = [];
    //   json['shopReviews'].forEach((v) {
    //     shopReviews?.add(Dynamic.fromJson(v));
    //   });
    // }
    transactionsList = json['transactionsList'];
    issuingMunicipalityId = json['issuingMunicipalityId'];
    issuingMunicipalityName = json['issuingMunicipalityName'];
    requestApprovals = json['requestApprovals'];
    facilityChangeMsg = json['facilityChangeMsg'];
    period = json['period'];
    endorsementText = json['endorsementText'];
    refuseShopReviewsList = json['refuseShopReviewsList'];
    etmamOrderInfo = json['etmamOrderInfo'];
    boardContractSetting = json['boardContractSetting'];
    selectedBoardContractOption = json['selectedBoardContractOption'];
    boardContractNumber = json['boardContractNumber'];
    modificationReason = json['modificationReason'];
    warnings = json['warnings'];
    requestSource = json['requestSource'];
    rejectionInfo = json['rejectionInfo'];
    showSalamaPermit = json['showSalamaPermit'];
    requestNotesList = json['requestNotesList'];
    notificationHubAllowed = json['notificationHubAllowed'];
    commercialOwnershipResponseDto = json['commercialOwnershipResponseDto'];
    commercialCleanContractResponseDto =
        json['commercialCleanContractResponseDto'];
    commercialSalamaResponseDto = json['commercialSalamaResponseDto'];
    craft = json['craft'];
    craftMessage = json['craftMessage'];
    contactInfo = json['contactInfo'];

    selectLicYears = json['selectLicYears'];
    showTillActive = json['showTillActive'];
    observationProviderType = json['observationProviderType'];
    salamaDetails = json['salamaDetails'];
    licenseCancellationInfo = json['licenseCancellationInfo'];
    if (json['licenseAllowedPermitsInfo'] != null) {
      licenseAllowedPermitsInfo = [];
      json['licenseAllowedPermitsInfo'].forEach((v) {
        licenseAllowedPermitsInfo?.add(LicenseAllowedPermitsInfo.fromJson(v));
      });
    }
    activityInfo = json['activityInfo'] != null
        ? ActivityInfo.fromJson(json['activityInfo'])
        : null;
    locationInfo = json['locationInfo'] != null
        ? LocationInfo.fromJson(json['locationInfo'])
        : null;
    submitterInfo = json['submitterInfo'] != null
        ? SubmitterInfo.fromJson(json['submitterInfo'])
        : null;
    shopInfo =
        json['shopInfo'] != null ? ShopInfo.fromJson(json['shopInfo']) : null;
    if (json['billsInfo'] != null) {
      billsInfo = [];
      json['billsInfo'].forEach((v) {
        billsInfo?.add(BillsInfo.fromJson(v));
      });
    }

    licenceHoldInfoStatusResponseDto =
        json['licenceHoldInfoStatusResponseDto'] != null
            ? LicenceHoldInfoStatusResponseDto.fromJson(
                json['licenceHoldInfoStatusResponseDto'])
            : null;

    licenseInfo = json['licenseInfo'] != null
        ? LicenseInfo.fromJson(json['licenseInfo'])
        : null;
    salamaInfo = json['salamaInfo'] != null
        ? SalamaInfo.fromJson(json['salamaInfo'])
        : null;
    salamaDetailsInfo = json['salamaDetailsInfo'] != null
        ? SalamaDetailsInfo.fromJson(json['salamaDetailsInfo'])
        : null;
    ownershipInfo = json['ownershipInfo'] != null
        ? OwnershipInfo.fromJson(json['ownershipInfo'])
        : null;

    cleanContractInfo = json['cleaningInfo'] != null
        ? CleanContractInfo.fromJson(json['cleaningInfo'])
        : null;
  }
}

class LicenseAllowedPermitsInfo {
  LicenseAllowedPermitsInfo({
    this.id,
    this.name,
    this.baladyWorkFlow,
    this.withFees,
  });

  LicenseAllowedPermitsInfo.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    baladyWorkFlow = json['baladyWorkFlow'] != null
        ? BaladyWorkFlow.fromJson(json['baladyWorkFlow'])
        : null;
    withFees = json['withFees'];
  }

  int? id;
  String? name;
  BaladyWorkFlow? baladyWorkFlow;
  bool? withFees;
}

class BaladyWorkFlow {
  BaladyWorkFlow({
    this.id,
    this.name,
  });

  BaladyWorkFlow.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  String? id;
  String? name;
}

class BillsInfo {
  BillsInfo({
    this.billNumber,
    this.billAmount,
    this.paymentDate,
    this.isSadadPaid,
    this.billFees,
  });

  BillsInfo.fromJson(dynamic json) {
    billNumber = json['billNumber'];
    billAmount = (json['billAmount'] ?? 0.0).toDouble();
    paymentDate = json['paymentDate'];
    isSadadPaid = json['isSadadPaid'];
    if (json['billFees'] != null) {
      billFees = [];
      json['billFees'].forEach((v) {
        billFees?.add(BillFees.fromJson(v));
      });
    }
  }

  String? billNumber;
  double? billAmount;
  String? paymentDate;
  bool? isSadadPaid;
  List<BillFees>? billFees;
}

class BillFees {
  BillFees({
    this.costItemValue,
    this.costItemTypeId,
    this.costItemDescription,
  });

  BillFees.fromJson(dynamic json) {
    costItemValue = (json['costItemValue'] ?? 0.0).toDouble();
    costItemTypeId = json['costItemTypeId'];
    costItemDescription = json['costItemDescription'];
  }

  double? costItemValue;
  int? costItemTypeId;
  String? costItemDescription;
}

class ShopInfo {
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
    this.isSalamaPermitMandatory,
    this.cleanContractOptions,
    this.showActivityCancellationDate,
    this.activityCancellationDate,
    this.mallDto,
    this.blockNumber,
    this.cancelReasonDto,
    this.brand,
    this.salamaPermitNumber,
    this.licenseBrand,
    this.insidePetrolStation,
    this.noOfCameras,
  });

  ShopInfo.fromJson(dynamic json) {
    shopName = json['shopName'];
    shopUnitNumber = json['shopUnitNumber'];
    holesCount = json['holesCount'];
    existInMall = json['existInMall'];
    floorNumber = json['floorNumber'];
    floorCount = json['floorCount'];
    hasElevator = json['hasElevator'] ?? false;
    isCitizenPledgedToClean = json['isCitizenPledgedToClean'];
    cleanContractEndDate = json['cleanContractEndDate'];
    buildingLicenseDate = json['buildingLicenseDate'];
    buildingLicenseNo = json['buildingLicenseNo'];
    buildingOwnerIdno = json['buildingOwnerIdno'];
    buildingOwnerName = json['buildingOwnerName'];
    landNumber = json['landNumber'];
    planNumber = json['planNumber'];
    salamaBillNumber = json['salamaBillNumber'];
    if (json['boardsInfo'] != null) {
      boardsInfo = [];
      json['boardsInfo'].forEach((v) {
        boardsInfo?.add(BoardsInfomation.fromJson(v));
      });
    }
    contractInfoResponseDto = json['contractInfoResponseDto'] != null
        ? ContractInfo.fromJson(json['contractInfoResponseDto'])
        : null;
    showShopOwnership = json['showShopOwnership'];
    slamaBillOptions = json['slamaBillOptions'] != null
        ? json['slamaBillOptions'].cast<String>()
        : [];
    cameraBillOptions = json['cameraBillOptions'];
    endorsementText = json['endorsementText'];
    slamaReportOptions = json['slamaReportOptions'] != null
        ? json['slamaReportOptions'].cast<String>()
        : [];
    slamaReportNumber = json['slamaReportNumber'];
    isFawryWithSalamaBill = json['isFawryWithSalamaBill'];
    isFawryWithSalamaReport = json['isFawryWithSalamaReport'];
    isSalamaPermitMandatory = json['isSalamaPermitMandatory'];
    cleanContractOptions = json['cleanContractOptions'] != null
        ? CleanContractOptions.fromJson(json['cleanContractOptions'])
        : null;
    showActivityCancellationDate = json['showActivityCancellationDate'];
    activityCancellationDate = json['activityCancellationDate'];
    mallDto = json['mallDto'];
    blockNumber = json['blockNumber'];
    cancelReasonDto = json['cancelReasonDto'];
    brand = json['brand'];
    salamaPermitNumber = json['salamaPermitNumber'];
    licenseBrand = json['licenseBrand'];
    insidePetrolStation = json['insidePetrolStation'] ?? false;
    noOfCameras = json['noOfCameras'];
  }

  String? shopName;
  int? shopUnitNumber;
  int? holesCount;
  bool? existInMall;
  dynamic floorNumber;
  int? floorCount;
  bool? hasElevator;
  bool? isCitizenPledgedToClean;
  dynamic cleanContractEndDate;
  dynamic buildingLicenseDate;
  dynamic buildingLicenseNo;
  dynamic buildingOwnerIdno;
  dynamic buildingOwnerName;
  String? landNumber;
  String? planNumber;
  dynamic salamaBillNumber;
  List<BoardsInfomation>? boardsInfo;
  ContractInfo? contractInfoResponseDto;
  bool? showShopOwnership;
  List<String>? slamaBillOptions;
  String? cameraBillOptions;
  String? endorsementText;
  List<String>? slamaReportOptions;
  dynamic slamaReportNumber;
  dynamic isFawryWithSalamaBill;
  dynamic isFawryWithSalamaReport;
  dynamic isSalamaPermitMandatory;
  CleanContractOptions? cleanContractOptions;
  bool? showActivityCancellationDate;
  dynamic activityCancellationDate;
  dynamic mallDto;
  dynamic blockNumber;
  dynamic cancelReasonDto;
  bool? brand;
  dynamic salamaPermitNumber;
  dynamic licenseBrand;
  bool? insidePetrolStation;
  int? noOfCameras;
}

class CleanContractOptions {
  CleanContractOptions({
    this.cleanOption,
    this.contractOption,
  });

  CleanContractOptions.fromJson(dynamic json) {
    cleanOption = json['cleanOption'];
    contractOption = json['contractOption'];
  }

  String? cleanOption;
  String? contractOption;
}

class ContractInfo {
  ContractInfo({
    this.contractType,
    this.contractOption,
    this.tenancyContractInfo,
    this.deedInfoResponse,
    this.contractDate,
    this.contractNumber,
    this.contractOptionsResponseDto,
    this.investmentContractNumber,
  });

  ContractInfo.fromJson(dynamic json) {
    contractType = json['contractType'];
    contractOption = json['contractOption'];
    tenancyContractInfo = json['tenancyContractInfo'];
    deedInfoResponse = json['deedInfoResponse'];
    contractDate = json['contractDate'];
    contractNumber = json['contractNumber'];
    contractOptionsResponseDto = json['contractOptionsResponseDto'] != null
        ? ContractOptionsResponseDto.fromJson(
            json['contractOptionsResponseDto'])
        : null;
    investmentContractNumber = json['investmentContractNumber'];
  }

  String? contractType;
  String? contractOption;
  dynamic tenancyContractInfo;
  dynamic deedInfoResponse;
  String? contractDate;
  String? contractNumber;
  ContractOptionsResponseDto? contractOptionsResponseDto;
  dynamic investmentContractNumber;

  String? getDisplayContractTypeName() {
    switch (contractType) {
      case "EJAR":
        return "Lease_Contract".tr();
      case "INVEST":
        return "Investment_Contract".tr();
      case "DEED":
        return "Ownership_Contract".tr();
    }
    return contractType;
  }

  String? getDisplayCleanContractName() {
    if (contractType == "EJAR" && contractOption == "ATTACH")
      return "Attach_Lease_Contract".tr();

    if (contractType == "EJAR" && contractOption == "SERVICE")
      return "Electronic_Lease_Contract".tr();

    if (contractType == "INVEST" && contractOption == "ATTACH")
      return "Attach_Investment_Contract".tr();

    if (contractType == "INVEST" && contractOption == "SERVICE")
      return "Electronic_Investment_Contract".tr();

    if (contractType == "DEED" && contractOption == "ATTACH")
      return "Attach_Ownership_Contract".tr();

    if (contractType == "DEED" && contractOption == "SERVICE")
      return "Electronic_Ownership_Contract".tr();

    return contractType;
  }
}

class ContractOptionsResponseDto {
  ContractOptionsResponseDto({
    this.ejarOptions,
    this.deedOptions,
    this.investOptions,
  });

  ContractOptionsResponseDto.fromJson(dynamic json) {
    ejarOptions =
        json['ejarOptions'] != null ? json['ejarOptions'].cast<String>() : [];
    deedOptions =
        json['deedOptions'] != null ? json['deedOptions'].cast<String>() : [];
    investOptions = json['investOptions'] != null
        ? json['investOptions'].cast<String>()
        : [];
  }

  List<String>? ejarOptions;
  List<String>? deedOptions;
  List<String>? investOptions;
}

class BoardsInfomation {
  BoardsInfomation({
    this.typeId,
    this.typeName,
    this.area,
  });

  BoardsInfomation.fromJson(dynamic json) {
    typeId = json['typeId'];
    typeName = json['typeName'];
    area = (json['area'] ?? 0.0).toDouble();
  }

  int? typeId;
  String? typeName;
  double? area;
}

class SubmitterInfo {
  SubmitterInfo({
    this.entityType,
    this.submitterType,
    this.crNumber,
    this.crType,
    this.submitterIdNumber,
    this.submitterBirthDate,
    this.mobile,
    this.gender,
    this.crTypeId,
    this.submitterName,
    this.entityName,
    this.crIssueDate,
    this.crSource,
    this.genderDesc,
    this.submitterIdType,
    this.crEntityType,
  });

  SubmitterInfo.fromJson(dynamic json) {
    entityType = json['entityType'];
    submitterType = json['submitterType'];
    crNumber = json['crNumber'];
    crType = json['crType'];
    submitterIdNumber = json['submitterIdNumber']?.toString() ?? "";
    submitterBirthDate = json['submitterBirthDate'];
    mobile = json['mobile'];
    gender = json['gender'];
    crTypeId = json['crTypeId'];
    submitterName = json['submitterName'];
    entityName = json['entityName'];
    crIssueDate = json['crIssueDate'];
    crSource = json['crSource'];
    genderDesc = json['genderDesc'];
    submitterIdType = json['submitterIdType'];
    crEntityType = json['crEntityType'];
  }

  String? entityType;
  String? submitterType;
  String? crNumber;
  String? crType;
  String? submitterIdNumber;
  String? submitterBirthDate;
  String? mobile;
  int? gender;
  dynamic crTypeId;
  String? submitterName;
  String? entityName;
  String? crIssueDate;
  String? crSource;
  String? genderDesc;
  dynamic submitterIdType;
  int? crEntityType;
}

class LocationInfo {
  LocationInfo(
      {this.subMunicipalityGisCode,
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
      this.cityName});

  LocationInfo.fromJson(dynamic json) {
    subMunicipalityGisCode = json['subMunicipalityGisCode'];
    districtCode = json['districtCode'];
    streetCode = json['streetCode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapNo = json['mapNo'];
    landNo = json['landNo'];
    streetName = json['streetName'];
    districtName = json['districtName'];
    subMunicipalityName = json['subMunicipalityName'];
    municipalityId = json['municipalityId'];
    municipalityName = json['municipalityName'];
    subMunicipalityId = json['subMunicipalityId'];
    regionId = json['regionId'];
    regionName = json['regionName'];
    vehiclePathDesc = json['vehiclePathDesc'];
    krokiUrl = json['krokiUrl'];
    cityName = json['cityName'];
  }

  String? subMunicipalityGisCode;
  int? districtCode;
  int? streetCode;
  String? latitude;
  String? longitude;
  String? mapNo;
  String? landNo;
  String? streetName;
  String? districtName;
  String? subMunicipalityName;
  String? municipalityId;
  String? municipalityName;
  String? subMunicipalityId;
  int? regionId;
  String? regionName;
  dynamic vehiclePathDesc;
  String? krokiUrl;
  String? cityName;
}

class ActivityInfo {
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

  ActivityInfo.fromJson(dynamic json) {
    mainActivity = json['mainActivity'] != null
        ? MainActivity.fromJson(json['mainActivity'])
        : null;
    additionalActivities = json['additionalActivities'];
    foreignInvistor = json['foreignInvistor'];
    workerTypeId = json['workerTypeId'];
    workerTypeName = json['workerTypeName'];
    activityChangeReason = json['activityChangeReason'];
    showAtmFeesOption = json['showAtmFeesOption'];
    atmFeesPaid = json['atmFeesPaid'];
    atmActivity = json['atmActivity'];
    inHomogenusActivities = json['inHomogenusActivities'];
    salamaWorkflowWarningMessage = json['salamaWorkflowWarningMessage'];
  }

  MainActivity? mainActivity;
  dynamic additionalActivities;
  bool? foreignInvistor;
  int? workerTypeId;
  String? workerTypeName;
  dynamic activityChangeReason;
  bool? showAtmFeesOption;
  bool? atmFeesPaid;
  bool? atmActivity;
  dynamic inHomogenusActivities;
  dynamic salamaWorkflowWarningMessage;
}

class MainActivity {
  MainActivity({
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

  MainActivity.fromJson(dynamic json) {
    detailedActivityId = json['detailedActivityId'];
    area = (json['area'] ?? 0.0) + 0.0;
    unitCount = json['unitCount'];
    accommodationTypeId = json['accommodationTypeId'];
    accommodationTypeName = json['accommodationTypeName'];
    detailedActivityName = json['detailedActivityName'];
    isicActivityId = json['isicActivityId'];
    mainActivityId = json['mainActivityId'];
    mainActivityName = json['mainActivityName'];
    isicActivityName = json['isicActivityName'];
    minYears = json['minYears'];
    maxYears = json['maxYears'];
    removed = json['removed'];
    activitySettingDto = json['activitySettingDto'] != null
        ? ActivitySettingDto.fromJson(json['activitySettingDto'])
        : null;
    minArea = json['minArea'];
    maxArea = json['maxArea'];
    facilityId = json['facilityId'];
    facilityName = json['facilityName'];
    salamaWorkflow = json['salamaWorkflow'];
  }

  int? detailedActivityId;
  double? area;
  dynamic unitCount;
  dynamic accommodationTypeId;
  dynamic accommodationTypeName;
  String? detailedActivityName;
  int? isicActivityId;
  int? mainActivityId;
  String? isicActivityName;
  String? mainActivityName;
  int? minYears;
  int? maxYears;
  bool? removed;
  ActivitySettingDto? activitySettingDto;
  dynamic minArea;
  dynamic maxArea;
  int? facilityId;
  String? facilityName;
  String? salamaWorkflow;
}

class ActivitySettingDto {
  ActivitySettingDto({
    this.entityType,
    this.vehicleType,
    this.pathType,
    this.foodActivity,
    this.ownershipType,
    this.requestFlow,
  });

  ActivitySettingDto.fromJson(dynamic json) {
    entityType = json['entityType'];
    vehicleType = json['vehicleType'];
    pathType = json['pathType'];
    foodActivity = json['foodActivity'];
    ownershipType = json['ownershipType'];
    requestFlow = json['requestFlow'];
  }

  int? entityType;
  dynamic vehicleType;
  dynamic pathType;
  bool? foodActivity;
  dynamic ownershipType;
  dynamic requestFlow;
}

class AdditionalActivities {
  String detailedActivityName;
  double area;
  String isicActivityName;

  AdditionalActivities({
    required this.detailedActivityName,
    required this.area,
    required this.isicActivityName,
  });

  factory AdditionalActivities.fromJson(Map<String, dynamic> json) =>
      AdditionalActivities(
        detailedActivityName: json["detailedActivityName"] ?? "",
        area: (json["area"] ?? 0) + 0.0,
        isicActivityName: json["isicActivityName"] ?? "",
      );
}

class LicenceHoldInfoStatusResponseDto {
  LicenceHoldInfoStatusResponseDto({
    this.hold,
    this.licenseId,
    this.holdReason,
    this.holdType,
    this.holdedSevices,
    this.holdSource,
  });

  LicenceHoldInfoStatusResponseDto.fromJson(dynamic json) {
    hold = json['hold'];
    licenseId = json['licenseId'];
    holdReason = json['holdReason'];
    holdType = json['holdType'];
    holdedSevices = json['holdedSevices'];
    holdSource = json['holdSource'];
  }

  bool? hold;
  int? licenseId;
  dynamic holdReason;
  dynamic holdType;
  dynamic holdedSevices;
  String? holdSource;
}

class SalamaInfo {
  SalamaInfo({
    this.salamaIssueDate,
    this.salamaIssueNo,
    this.salamaApprovedCenterId,
    this.salamaApprovedCenterName,
  });

  SalamaInfo.fromJson(dynamic json) {
    salamaIssueDate = json['salamaIssueDate'];
    salamaIssueNo = json['salamaIssueNo'];
    salamaApprovedCenterId = json['salamaApprovedCenterId'];
    salamaApprovedCenterName = json['salamaApprovedCenterName'];
  }

  dynamic salamaIssueDate;
  dynamic salamaIssueNo;
  dynamic salamaApprovedCenterId;
  dynamic salamaApprovedCenterName;
}

class CleanContractInfo {
  int? contractNumber;
  String cleanOption;
  String contractOption;
  String cleanOptionName;
  String cleanOptionDesc;
  String? cleanContractEndDate;

  CleanContractInfo({
    this.contractNumber,
    required this.cleanOption,
    required this.contractOption,
    required this.cleanOptionName,
    required this.cleanOptionDesc,
    required this.cleanContractEndDate,
  });


  factory CleanContractInfo.fromJson(Map<String, dynamic> json) =>
      CleanContractInfo(
        contractNumber: json['contractNumber'],
        cleanOption: json['cleanOption'] ?? "",
        contractOption: json['contractOption'] ?? "",
        cleanOptionName: json['cleanOptionName'] ?? "",
        cleanOptionDesc: json['cleanOptionDesc'] ?? "",
        cleanContractEndDate: json['cleanContractEndDate'],
      );
}

class SalamaDetailsInfo {
  final String workFlow;
  final dynamic salamaReportNumber;
  final dynamic salamaBillNumber;
  final dynamic salamaPermitNumber;
  final String? documentName;
  final String? documentDesc;

  SalamaDetailsInfo({
    required this.workFlow,
    required this.salamaReportNumber,
    required this.salamaBillNumber,
    required this.salamaPermitNumber,
    required this.documentName,
    required this.documentDesc,
  });

  factory SalamaDetailsInfo.fromJson(Map<String, dynamic> json) =>
      SalamaDetailsInfo(
        workFlow: json['workFlow'] ?? "",
        salamaReportNumber: json['salamaReportNumber'],
        salamaBillNumber: json['salamaBillNumber'],
        salamaPermitNumber: json['salamaPermitNumber'],
        documentName: json['documentName'] ?? "",
        documentDesc: json['documentDesc'] ?? "",
      );
}

class OwnershipInfo {
  final ContractType? contractType;
  final TenancyContractInfo? tenancyContractInfo;
  final DeedInfo? deedInfo;
  final InvestmentContractInfo? investmentContractInfo;

  OwnershipInfo({
    required this.contractType,
    required this.tenancyContractInfo,
    required this.deedInfo,
    required this.investmentContractInfo,
  });

  factory OwnershipInfo.fromJson(Map<String, dynamic> json) => OwnershipInfo(
        contractType: json['contractType'] != null
            ? ContractType.fromJson(json['contractType'])
            : null,
        tenancyContractInfo: json['tenancyContractInfo'] != null
            ? TenancyContractInfo.fromJson(json['tenancyContractInfo'])
            : null,
        deedInfo: json['deedInfo'] != null
            ? DeedInfo.fromJson(json['deedInfo'])
            : null,
        investmentContractInfo: json['investmentContractInfo'] != null
            ? InvestmentContractInfo.fromJson(json['investmentContractInfo'])
            : null,
      );
}

class InvestmentContractInfo {
  final String investmentContractNumber;
  final String investContractName;
  final ContractType? type;

  InvestmentContractInfo({
    required this.investmentContractNumber,
    required this.investContractName,
    required this.type,
  });

  factory InvestmentContractInfo.fromJson(Map<String, dynamic> json) =>
      InvestmentContractInfo(
        investmentContractNumber: json['investmentContractNumber'] ?? "",
        investContractName: json['investContractName'] ?? "",
        type: json['type'] != null ? ContractType.fromJson(json['type']) : null,
      );
}

class DeedInfo {
  final String deedNumber;
  final String deedDate;

  DeedInfo({
    required this.deedNumber,
    required this.deedDate,
  });

  factory DeedInfo.fromJson(Map<String, dynamic> json) => DeedInfo(
        deedNumber: json['deedNumber'] ?? "",
        deedDate: json['deedDate'] ?? "",
      );
}

class ContractType {
  final String id;
  final String name;

  ContractType({
    required this.id,
    required this.name,
  });

  factory ContractType.fromJson(Map<String, dynamic> json) => ContractType(
        id: json['id'],
        name: json['name'] ?? "",
      );
}

class TenancyContractInfo {
  final String tenancyContractNumber;
  final dynamic versionNumber;
  final dynamic nationalId;
  final String contractEndDate;

  TenancyContractInfo({
    required this.tenancyContractNumber,
    required this.versionNumber,
    required this.nationalId,
    required this.contractEndDate,
  });

  factory TenancyContractInfo.fromJson(Map<String, dynamic> json) =>
      TenancyContractInfo(
        tenancyContractNumber: json['tenancyContractNumber'] ?? "",
        versionNumber: json['versionNumber'] ?? "",
        nationalId: json['nationalId'] ?? "",
        contractEndDate: json['contractEndDate'] ?? "",
      );
}

class LicenseInfo {
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

  LicenseInfo.fromJson(dynamic json) {
    licenseEndDate = json['licenseEndDate'];
    licenseSadadEndDate = json['licenseSadadEndDate'];
    licensePeriod = json['licensePeriod'];
    sadadPeriod = json['sadadPeriod'];
    licenseId = json['licenseId'];
    statusId = json['statusId'];
    expireInDays = json['expireInDays'];
    oldLicenseNo = json['oldLicenseNo'];
    issueDate = json['issueDate'];
    expired = json['expired'];
    printUrl = json['printUrl'];
    qrCodeUrl = json['qrCodeUrl'];
    qrRequestId = json['qrRequestId'];
    statusDesc = json['statusDesc'];
  }

  String? licenseEndDate;
  String? licenseSadadEndDate;
  dynamic licensePeriod;
  dynamic sadadPeriod;
  int? licenseId;
  int? statusId;
  int? expireInDays;
  dynamic oldLicenseNo;
  String? issueDate;
  bool? expired;
  String? printUrl;
  String? qrCodeUrl;
  int? qrRequestId;
  String? statusDesc;
}
