// To parse this JSON data, do
//
//     final licenseDetails = licenseDetailsFromJson(jsonString);

import 'dart:convert';

LicenseDetails licenseDetailsFromJson(String str) =>
    LicenseDetails.fromJson(json.decode(str));

String licenseDetailsToJson(LicenseDetails data) => json.encode(data.toJson());

class LicenseDetails {
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
  final dynamic employeeNotes;
  final dynamic clientNotes;
  final LicenseInfo? licenseInfo;
  final dynamic objectionNotesInfo;
  final dynamic warningMessages;
  final dynamic warningInfo;
  final dynamic latestRequestId;
  final bool? isRejectedStatus;
  final bool? isSalamaStatus;
  final bool? isCanceledByObservationStatus;
  final dynamic renewMode;
  final bool? investmentSite;
  final String? billUrl;
  final bool? fawryWithSalama;
  final String? requestPathType;
  final dynamic engineeringOffice;
  final List<dynamic>? shopReviews;
  final dynamic transactionsList;
  final dynamic issuingMunicipalityId;
  final dynamic issuingMunicipalityName;
  final dynamic requestApprovals;
  final String? facilityChangeMsg;
  final dynamic period;
  final String? endorsementText;
  final dynamic refuseShopReviewsList;
  final dynamic etmamOrderInfo;
  final LicenceHoldInfoStatusResponseDto? licenceHoldInfoStatusResponseDto;
  final String? boardContractSetting;
  final String? selectedBoardContractOption;
  final dynamic boardContractNumber;
  final dynamic modificationReason;
  final dynamic requestSource;
  final dynamic rejectionInfo;
  final dynamic showSalamaPermit;
  final dynamic requestNotesList;
  final dynamic notificationHubAllowed;
  final dynamic siteConfigInfo;
  final dynamic gisProviderType;
  final dynamic requestGisProviderType;
  final dynamic shopMaximumArea;
  final bool? craft;
  final dynamic craftMessage;
  final dynamic contactInfo;
  final ActivityInfo? activityInfo;
  final LocationInfo? locationInfo;
  final ShopInfo? shopInfo;
  final bool? selectLicYears;
  final bool? showTillActive;
  final dynamic observationProviderType;
  final dynamic salamaDetails;
  final dynamic modifyFlow;
  final bool? disableLocationEdit;
  final dynamic splInfoResponseDto;
  final dynamic disableLocationEditMsg;
  final dynamic licenseCancellationInfo;
  final List<LicenseAllowedPermitsInfo>? licenseAllowedPermitsInfo;
  final CleaningInfo? cleaningInfo;
  final OwnershipInfo? ownershipInfo;

  LicenseDetails({
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
    this.employeeNotes,
    this.clientNotes,
    this.licenseInfo,
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
    this.requestSource,
    this.rejectionInfo,
    this.showSalamaPermit,
    this.requestNotesList,
    this.notificationHubAllowed,
    this.siteConfigInfo,
    this.gisProviderType,
    this.requestGisProviderType,
    this.shopMaximumArea,
    this.craft,
    this.craftMessage,
    this.contactInfo,
    this.activityInfo,
    this.locationInfo,
    this.shopInfo,
    this.selectLicYears,
    this.showTillActive,
    this.observationProviderType,
    this.salamaDetails,
    this.modifyFlow,
    this.disableLocationEdit,
    this.splInfoResponseDto,
    this.disableLocationEditMsg,
    this.licenseCancellationInfo,
    this.licenseAllowedPermitsInfo,
    this.cleaningInfo,
    this.ownershipInfo,
  });

  LicenseDetails copyWith({
    int? requestId,
    double? mainActivityArea,
    String? creationDate,
    String? entityType,
    int? currentTabId,
    int? statusId,
    String? statusName,
    int? typeId,
    String? typeName,
    int? licensePeriod,
    int? originalLicensePeriod,
    int? sadadPeriod,
    int? entryMode,
    String? cleanOptions,
    bool? groceryActivity,
    bool? municipalityApproval,
    dynamic employeeNotes,
    dynamic clientNotes,
    LicenseInfo? licenseInfo,
    dynamic objectionNotesInfo,
    dynamic warningMessages,
    dynamic warningInfo,
    dynamic latestRequestId,
    bool? isRejectedStatus,
    bool? isSalamaStatus,
    bool? isCanceledByObservationStatus,
    dynamic renewMode,
    bool? investmentSite,
    String? billUrl,
    bool? fawryWithSalama,
    String? requestPathType,
    dynamic engineeringOffice,
    List<dynamic>? shopReviews,
    dynamic transactionsList,
    dynamic issuingMunicipalityId,
    dynamic issuingMunicipalityName,
    dynamic requestApprovals,
    String? facilityChangeMsg,
    dynamic period,
    String? endorsementText,
    dynamic refuseShopReviewsList,
    dynamic etmamOrderInfo,
    LicenceHoldInfoStatusResponseDto? licenceHoldInfoStatusResponseDto,
    String? boardContractSetting,
    String? selectedBoardContractOption,
    dynamic boardContractNumber,
    dynamic modificationReason,
    dynamic requestSource,
    dynamic rejectionInfo,
    dynamic showSalamaPermit,
    dynamic requestNotesList,
    dynamic notificationHubAllowed,
    dynamic siteConfigInfo,
    dynamic gisProviderType,
    dynamic requestGisProviderType,
    dynamic shopMaximumArea,
    bool? craft,
    dynamic craftMessage,
    dynamic contactInfo,
    ActivityInfo? activityInfo,
    LocationInfo? locationInfo,
    ShopInfo? shopInfo,
    bool? selectLicYears,
    bool? showTillActive,
    dynamic observationProviderType,
    dynamic salamaDetails,
    dynamic modifyFlow,
    bool? disableLocationEdit,
    dynamic splInfoResponseDto,
    dynamic disableLocationEditMsg,
    dynamic licenseCancellationInfo,
    List<LicenseAllowedPermitsInfo>? licenseAllowedPermitsInfo,
    CleaningInfo? cleaningInfo,
    OwnershipInfo? ownershipInfo,
  }) =>
      LicenseDetails(
        requestId: requestId ?? this.requestId,
        mainActivityArea: mainActivityArea ?? this.mainActivityArea,
        creationDate: creationDate ?? this.creationDate,
        entityType: entityType ?? this.entityType,
        currentTabId: currentTabId ?? this.currentTabId,
        statusId: statusId ?? this.statusId,
        statusName: statusName ?? this.statusName,
        typeId: typeId ?? this.typeId,
        typeName: typeName ?? this.typeName,
        licensePeriod: licensePeriod ?? this.licensePeriod,
        originalLicensePeriod:
            originalLicensePeriod ?? this.originalLicensePeriod,
        sadadPeriod: sadadPeriod ?? this.sadadPeriod,
        entryMode: entryMode ?? this.entryMode,
        cleanOptions: cleanOptions ?? this.cleanOptions,
        groceryActivity: groceryActivity ?? this.groceryActivity,
        municipalityApproval: municipalityApproval ?? this.municipalityApproval,
        employeeNotes: employeeNotes ?? this.employeeNotes,
        clientNotes: clientNotes ?? this.clientNotes,
        licenseInfo: licenseInfo ?? this.licenseInfo,
        objectionNotesInfo: objectionNotesInfo ?? this.objectionNotesInfo,
        warningMessages: warningMessages ?? this.warningMessages,
        latestRequestId: latestRequestId ?? this.latestRequestId,
        isRejectedStatus: isRejectedStatus ?? this.isRejectedStatus,
        isSalamaStatus: isSalamaStatus ?? this.isSalamaStatus,
        isCanceledByObservationStatus:
            isCanceledByObservationStatus ?? this.isCanceledByObservationStatus,
        renewMode: renewMode ?? this.renewMode,
        investmentSite: investmentSite ?? this.investmentSite,
        billUrl: billUrl ?? this.billUrl,
        fawryWithSalama: fawryWithSalama ?? this.fawryWithSalama,
        requestPathType: requestPathType ?? this.requestPathType,
        engineeringOffice: engineeringOffice ?? this.engineeringOffice,
        shopReviews: shopReviews ?? this.shopReviews,
        transactionsList: transactionsList ?? this.transactionsList,
        issuingMunicipalityId:
            issuingMunicipalityId ?? this.issuingMunicipalityId,
        issuingMunicipalityName:
            issuingMunicipalityName ?? this.issuingMunicipalityName,
        requestApprovals: requestApprovals ?? this.requestApprovals,
        facilityChangeMsg: facilityChangeMsg ?? this.facilityChangeMsg,
        period: period ?? this.period,
        endorsementText: endorsementText ?? this.endorsementText,
        refuseShopReviewsList:
            refuseShopReviewsList ?? this.refuseShopReviewsList,
        etmamOrderInfo: etmamOrderInfo ?? this.etmamOrderInfo,
        licenceHoldInfoStatusResponseDto: licenceHoldInfoStatusResponseDto ??
            this.licenceHoldInfoStatusResponseDto,
        boardContractSetting: boardContractSetting ?? this.boardContractSetting,
        selectedBoardContractOption:
            selectedBoardContractOption ?? this.selectedBoardContractOption,
        boardContractNumber: boardContractNumber ?? this.boardContractNumber,
        modificationReason: modificationReason ?? this.modificationReason,
        requestSource: requestSource ?? this.requestSource,
        rejectionInfo: rejectionInfo ?? this.rejectionInfo,
        showSalamaPermit: showSalamaPermit ?? this.showSalamaPermit,
        requestNotesList: requestNotesList ?? this.requestNotesList,
        notificationHubAllowed:
            notificationHubAllowed ?? this.notificationHubAllowed,
        siteConfigInfo: siteConfigInfo ?? this.siteConfigInfo,
        gisProviderType: gisProviderType ?? this.gisProviderType,
        requestGisProviderType:
            requestGisProviderType ?? this.requestGisProviderType,
        shopMaximumArea: shopMaximumArea ?? this.shopMaximumArea,
        craft: craft ?? this.craft,
        craftMessage: craftMessage ?? this.craftMessage,
        contactInfo: contactInfo ?? this.contactInfo,
        activityInfo: activityInfo ?? this.activityInfo,
        locationInfo: locationInfo ?? this.locationInfo,
        shopInfo: shopInfo ?? this.shopInfo,
        selectLicYears: selectLicYears ?? this.selectLicYears,
        showTillActive: showTillActive ?? this.showTillActive,
        observationProviderType:
            observationProviderType ?? this.observationProviderType,
        salamaDetails: salamaDetails ?? this.salamaDetails,
        modifyFlow: modifyFlow ?? this.modifyFlow,
        disableLocationEdit: disableLocationEdit ?? this.disableLocationEdit,
        splInfoResponseDto: splInfoResponseDto ?? this.splInfoResponseDto,
        disableLocationEditMsg:
            disableLocationEditMsg ?? this.disableLocationEditMsg,
        licenseCancellationInfo:
            licenseCancellationInfo ?? this.licenseCancellationInfo,
        licenseAllowedPermitsInfo:
            licenseAllowedPermitsInfo ?? this.licenseAllowedPermitsInfo,
        cleaningInfo: cleaningInfo ?? this.cleaningInfo,
        ownershipInfo: ownershipInfo ?? this.ownershipInfo,
      );

  factory LicenseDetails.fromJson(Map<String, dynamic> json) => LicenseDetails(
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
        employeeNotes: json["employeeNotes"],
        clientNotes: json["clientNotes"],
        licenseInfo: json["licenseInfo"] == null
            ? null
            : LicenseInfo.fromJson(json["licenseInfo"]),
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
        shopReviews: json["shopReviews"] == null
            ? []
            : List<dynamic>.from(json["shopReviews"]!.map((x) => x)),
        transactionsList: json["transactionsList"],
        issuingMunicipalityId: json["issuingMunicipalityId"],
        issuingMunicipalityName: json["issuingMunicipalityName"],
        requestApprovals: json["requestApprovals"],
        facilityChangeMsg: json["facilityChangeMsg"],
        period: json["period"],
        endorsementText: json["endorsementText"],
        refuseShopReviewsList: json["refuseShopReviewsList"],
        etmamOrderInfo: json["etmamOrderInfo"],
        licenceHoldInfoStatusResponseDto:
            json["licenceHoldInfoStatusResponseDto"] == null
                ? null
                : LicenceHoldInfoStatusResponseDto.fromJson(
                    json["licenceHoldInfoStatusResponseDto"]),
        boardContractSetting: json["boardContractSetting"],
        selectedBoardContractOption: json["selectedBoardContractOption"],
        boardContractNumber: json["boardContractNumber"],
        modificationReason: json["modificationReason"],
        requestSource: json["requestSource"],
        rejectionInfo: json["rejectionInfo"],
        showSalamaPermit: json["showSalamaPermit"],
        requestNotesList: json["requestNotesList"],
        notificationHubAllowed: json["notificationHubAllowed"],
        siteConfigInfo: json["siteConfigInfo"],
        gisProviderType: json["gisProviderType"],
        requestGisProviderType: json["requestGisProviderType"],
        shopMaximumArea: json["shopMaximumArea"],
        craft: json["craft"],
        craftMessage: json["craftMessage"],
        contactInfo: json["contactInfo"],
        activityInfo: json["activityInfo"] == null
            ? null
            : ActivityInfo.fromJson(json["activityInfo"]),
        locationInfo: json["locationInfo"] == null
            ? null
            : LocationInfo.fromJson(json["locationInfo"]),
        shopInfo: json["shopInfo"] == null
            ? null
            : ShopInfo.fromJson(json["shopInfo"]),
        selectLicYears: json["selectLicYears"],
        showTillActive: json["showTillActive"],
        observationProviderType: json["observationProviderType"],
        salamaDetails: json["salamaDetails"],
        modifyFlow: json["modifyFlow"],
        disableLocationEdit: json["disableLocationEdit"],
        splInfoResponseDto: json["splInfoResponseDto"],
        disableLocationEditMsg: json["disableLocationEditMsg"],
        licenseCancellationInfo: json["licenseCancellationInfo"],
        licenseAllowedPermitsInfo: json["licenseAllowedPermitsInfo"] == null
            ? []
            : List<LicenseAllowedPermitsInfo>.from(
                json["licenseAllowedPermitsInfo"]!
                    .map((x) => LicenseAllowedPermitsInfo.fromJson(x))),
        cleaningInfo: json["cleaningInfo"] == null
            ? null
            : CleaningInfo.fromJson(json["cleaningInfo"]),
        ownershipInfo: json["ownershipInfo"] == null
            ? null
            : OwnershipInfo.fromJson(json["ownershipInfo"]),
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
        "employeeNotes": employeeNotes,
        "clientNotes": clientNotes,
        "licenseInfo": licenseInfo?.toJson(),
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
        "transactionsList": transactionsList,
        "issuingMunicipalityId": issuingMunicipalityId,
        "issuingMunicipalityName": issuingMunicipalityName,
        "requestApprovals": requestApprovals,
        "facilityChangeMsg": facilityChangeMsg,
        "period": period,
        "endorsementText": endorsementText,
        "refuseShopReviewsList": refuseShopReviewsList,
        "etmamOrderInfo": etmamOrderInfo,
        "licenceHoldInfoStatusResponseDto":
            licenceHoldInfoStatusResponseDto?.toJson(),
        "boardContractSetting": boardContractSetting,
        "selectedBoardContractOption": selectedBoardContractOption,
        "boardContractNumber": boardContractNumber,
        "modificationReason": modificationReason,
        "requestSource": requestSource,
        "rejectionInfo": rejectionInfo,
        "showSalamaPermit": showSalamaPermit,
        "requestNotesList": requestNotesList,
        "notificationHubAllowed": notificationHubAllowed,
        "siteConfigInfo": siteConfigInfo,
        "gisProviderType": gisProviderType,
        "requestGisProviderType": requestGisProviderType,
        "shopMaximumArea": shopMaximumArea,
        "craft": craft,
        "craftMessage": craftMessage,
        "contactInfo": contactInfo,
        "activityInfo": activityInfo?.toJson(),
        "locationInfo": locationInfo?.toJson(),
        "shopInfo": shopInfo?.toJson(),
        "selectLicYears": selectLicYears,
        "showTillActive": showTillActive,
        "observationProviderType": observationProviderType,
        "salamaDetails": salamaDetails,
        "modifyFlow": modifyFlow,
        "disableLocationEdit": disableLocationEdit,
        "splInfoResponseDto": splInfoResponseDto,
        "disableLocationEditMsg": disableLocationEditMsg,
        "licenseCancellationInfo": licenseCancellationInfo,
        "licenseAllowedPermitsInfo": licenseAllowedPermitsInfo == null
            ? []
            : List<dynamic>.from(
                licenseAllowedPermitsInfo!.map((x) => x.toJson())),
        "cleaningInfo": cleaningInfo?.toJson(),
        "ownershipInfo": ownershipInfo?.toJson(),
      };
}

class ActivityInfo {
  final MainActivity? mainActivity;
  final dynamic additionalActivities;
  final bool? foreignInvistor;
  final int? workerTypeId;
  final String? workerTypeName;
  final dynamic activityChangeReason;
  final bool? showAtmFeesOption;
  final bool? atmFeesPaid;
  final bool? atmActivity;
  final dynamic inHomogenusActivities;
  final dynamic salamaWorkflowWarningMessage;

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

  ActivityInfo copyWith({
    MainActivity? mainActivity,
    dynamic additionalActivities,
    bool? foreignInvistor,
    int? workerTypeId,
    String? workerTypeName,
    dynamic activityChangeReason,
    bool? showAtmFeesOption,
    bool? atmFeesPaid,
    bool? atmActivity,
    dynamic inHomogenusActivities,
    dynamic salamaWorkflowWarningMessage,
  }) =>
      ActivityInfo(
        mainActivity: mainActivity ?? this.mainActivity,
        additionalActivities: additionalActivities ?? this.additionalActivities,
        foreignInvistor: foreignInvistor ?? this.foreignInvistor,
        workerTypeId: workerTypeId ?? this.workerTypeId,
        workerTypeName: workerTypeName ?? this.workerTypeName,
        activityChangeReason: activityChangeReason ?? this.activityChangeReason,
        showAtmFeesOption: showAtmFeesOption ?? this.showAtmFeesOption,
        atmFeesPaid: atmFeesPaid ?? this.atmFeesPaid,
        atmActivity: atmActivity ?? this.atmActivity,
        inHomogenusActivities:
            inHomogenusActivities ?? this.inHomogenusActivities,
        salamaWorkflowWarningMessage:
            salamaWorkflowWarningMessage ?? this.salamaWorkflowWarningMessage,
      );

  factory ActivityInfo.fromJson(Map<String, dynamic> json) => ActivityInfo(
        mainActivity: json["mainActivity"] == null
            ? null
            : MainActivity.fromJson(json["mainActivity"]),
        additionalActivities: json["additionalActivities"],
        foreignInvistor: json["foreignInvistor"],
        workerTypeId: json["workerTypeId"],
        workerTypeName: json["workerTypeName"],
        activityChangeReason: json["activityChangeReason"],
        showAtmFeesOption: json["showAtmFeesOption"],
        atmFeesPaid: json["atmFeesPaid"],
        atmActivity: json["atmActivity"],
        inHomogenusActivities: json["inHomogenusActivities"],
        salamaWorkflowWarningMessage: json["salamaWorkflowWarningMessage"],
      );

  Map<String, dynamic> toJson() => {
        "mainActivity": mainActivity?.toJson(),
        "additionalActivities": additionalActivities,
        "foreignInvistor": foreignInvistor,
        "workerTypeId": workerTypeId,
        "workerTypeName": workerTypeName,
        "activityChangeReason": activityChangeReason,
        "showAtmFeesOption": showAtmFeesOption,
        "atmFeesPaid": atmFeesPaid,
        "atmActivity": atmActivity,
        "inHomogenusActivities": inHomogenusActivities,
        "salamaWorkflowWarningMessage": salamaWorkflowWarningMessage,
      };
}

class MainActivity {
  final int? detailedActivityId;
  final double? area;
  final dynamic unitCount;
  final dynamic accommodationTypeId;
  final dynamic accommodationTypeName;
  final String? detailedActivityName;
  final int? isicActivityId;
  final int? mainActivityId;
  final String? mainActivityName;
  final String? isicActivityName;
  final int? minYears;
  final int? maxYears;
  final bool? removed;
  final ActivitySettingDto? activitySettingDto;
  final double? minArea;
  final double? maxArea;
  final int? facilityId;
  final String? facilityName;
  final String? salamaWorkflow;

  MainActivity({
    this.detailedActivityId,
    this.area,
    this.unitCount,
    this.accommodationTypeId,
    this.accommodationTypeName,
    this.detailedActivityName,
    this.isicActivityId,
    this.mainActivityId,
    this.mainActivityName,
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

  MainActivity copyWith({
    int? detailedActivityId,
    double? area,
    dynamic unitCount,
    dynamic accommodationTypeId,
    dynamic accommodationTypeName,
    String? detailedActivityName,
    int? isicActivityId,
    int? mainActivityId,
    String? mainActivityName,
    String? isicActivityName,
    int? minYears,
    int? maxYears,
    bool? removed,
    ActivitySettingDto? activitySettingDto,
    double? minArea,
    double? maxArea,
    int? facilityId,
    String? facilityName,
    String? salamaWorkflow,
  }) =>
      MainActivity(
        detailedActivityId: detailedActivityId ?? this.detailedActivityId,
        area: area ?? this.area,
        unitCount: unitCount ?? this.unitCount,
        accommodationTypeId: accommodationTypeId ?? this.accommodationTypeId,
        accommodationTypeName:
            accommodationTypeName ?? this.accommodationTypeName,
        detailedActivityName: detailedActivityName ?? this.detailedActivityName,
        isicActivityId: isicActivityId ?? this.isicActivityId,
        mainActivityId: mainActivityId ?? this.mainActivityId,
        mainActivityName: mainActivityName ?? this.mainActivityName,
        isicActivityName: isicActivityName ?? this.isicActivityName,
        minYears: minYears ?? this.minYears,
        maxYears: maxYears ?? this.maxYears,
        removed: removed ?? this.removed,
        activitySettingDto: activitySettingDto ?? this.activitySettingDto,
        minArea: minArea ?? this.minArea,
        maxArea: maxArea ?? this.maxArea,
        facilityId: facilityId ?? this.facilityId,
        facilityName: facilityName ?? this.facilityName,
        salamaWorkflow: salamaWorkflow ?? this.salamaWorkflow,
      );

  factory MainActivity.fromJson(Map<String, dynamic> json) => MainActivity(
        detailedActivityId: json["detailedActivityId"],
        area: json["area"]?.toDouble(),
        unitCount: json["unitCount"],
        accommodationTypeId: json["accommodationTypeId"],
        accommodationTypeName: json["accommodationTypeName"],
        detailedActivityName: json["detailedActivityName"],
        isicActivityId: json["isicActivityId"],
        mainActivityId: json["mainActivityId"],
        mainActivityName: json["mainActivityName"],
        isicActivityName: json["isicActivityName"],
        minYears: json["minYears"],
        maxYears: json["maxYears"],
        removed: json["removed"],
        activitySettingDto: json["activitySettingDto"] == null
            ? null
            : ActivitySettingDto.fromJson(json["activitySettingDto"]),
        minArea: json["minArea"]?.toDouble(),
        maxArea: json["maxArea"]?.toDouble(),
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
        "mainActivityName": mainActivityName,
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
  final dynamic vehicleType;
  final dynamic pathType;
  final bool? foodActivity;
  final dynamic ownershipType;
  final dynamic requestFlow;

  ActivitySettingDto({
    this.entityType,
    this.vehicleType,
    this.pathType,
    this.foodActivity,
    this.ownershipType,
    this.requestFlow,
  });

  ActivitySettingDto copyWith({
    int? entityType,
    dynamic vehicleType,
    dynamic pathType,
    bool? foodActivity,
    dynamic ownershipType,
    dynamic requestFlow,
  }) =>
      ActivitySettingDto(
        entityType: entityType ?? this.entityType,
        vehicleType: vehicleType ?? this.vehicleType,
        pathType: pathType ?? this.pathType,
        foodActivity: foodActivity ?? this.foodActivity,
        ownershipType: ownershipType ?? this.ownershipType,
        requestFlow: requestFlow ?? this.requestFlow,
      );

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

class CleaningInfo {
  final dynamic contractNumber;
  final String? cleanOption;
  final dynamic contractOption;
  final String? cleanOptionName;
  final String? cleanOptionDesc;
  final dynamic cleanContractEndDate;

  CleaningInfo({
    this.contractNumber,
    this.cleanOption,
    this.contractOption,
    this.cleanOptionName,
    this.cleanOptionDesc,
    this.cleanContractEndDate,
  });

  CleaningInfo copyWith({
    dynamic contractNumber,
    String? cleanOption,
    dynamic contractOption,
    String? cleanOptionName,
    String? cleanOptionDesc,
    dynamic cleanContractEndDate,
  }) =>
      CleaningInfo(
        contractNumber: contractNumber ?? this.contractNumber,
        cleanOption: cleanOption ?? this.cleanOption,
        contractOption: contractOption ?? this.contractOption,
        cleanOptionName: cleanOptionName ?? this.cleanOptionName,
        cleanOptionDesc: cleanOptionDesc ?? this.cleanOptionDesc,
        cleanContractEndDate: cleanContractEndDate ?? this.cleanContractEndDate,
      );

  factory CleaningInfo.fromJson(Map<String, dynamic> json) => CleaningInfo(
        contractNumber: json["contractNumber"],
        cleanOption: json["cleanOption"],
        contractOption: json["contractOption"],
        cleanOptionName: json["cleanOptionName"],
        cleanOptionDesc: json["cleanOptionDesc"],
        cleanContractEndDate: json["cleanContractEndDate"],
      );

  Map<String, dynamic> toJson() => {
        "contractNumber": contractNumber,
        "cleanOption": cleanOption,
        "contractOption": contractOption,
        "cleanOptionName": cleanOptionName,
        "cleanOptionDesc": cleanOptionDesc,
        "cleanContractEndDate": cleanContractEndDate,
      };
}

class LicenceHoldInfoStatusResponseDto {
  final bool? hold;
  final int? licenseId;
  final dynamic holdReason;
  final dynamic holdType;
  final dynamic holdedSevices;
  final String? holdSource;

  LicenceHoldInfoStatusResponseDto({
    this.hold,
    this.licenseId,
    this.holdReason,
    this.holdType,
    this.holdedSevices,
    this.holdSource,
  });

  LicenceHoldInfoStatusResponseDto copyWith({
    bool? hold,
    int? licenseId,
    dynamic holdReason,
    dynamic holdType,
    dynamic holdedSevices,
    String? holdSource,
  }) =>
      LicenceHoldInfoStatusResponseDto(
        hold: hold ?? this.hold,
        licenseId: licenseId ?? this.licenseId,
        holdReason: holdReason ?? this.holdReason,
        holdType: holdType ?? this.holdType,
        holdedSevices: holdedSevices ?? this.holdedSevices,
        holdSource: holdSource ?? this.holdSource,
      );

  factory LicenceHoldInfoStatusResponseDto.fromJson(
          Map<String, dynamic> json) =>
      LicenceHoldInfoStatusResponseDto(
        hold: json["hold"],
        licenseId: json["licenseId"],
        holdReason: json["holdReason"],
        holdType: json["holdType"],
        holdedSevices: json["holdedSevices"],
        holdSource: json["holdSource"],
      );

  Map<String, dynamic> toJson() => {
        "hold": hold,
        "licenseId": licenseId,
        "holdReason": holdReason,
        "holdType": holdType,
        "holdedSevices": holdedSevices,
        "holdSource": holdSource,
      };
}

class LicenseAllowedPermitsInfo {
  final int? id;
  final String? name;
  final ContractType? baladyWorkFlow;
  final bool? withFees;

  LicenseAllowedPermitsInfo({
    this.id,
    this.name,
    this.baladyWorkFlow,
    this.withFees,
  });

  LicenseAllowedPermitsInfo copyWith({
    int? id,
    String? name,
    ContractType? baladyWorkFlow,
    bool? withFees,
  }) =>
      LicenseAllowedPermitsInfo(
        id: id ?? this.id,
        name: name ?? this.name,
        baladyWorkFlow: baladyWorkFlow ?? this.baladyWorkFlow,
        withFees: withFees ?? this.withFees,
      );

  factory LicenseAllowedPermitsInfo.fromJson(Map<String, dynamic> json) =>
      LicenseAllowedPermitsInfo(
        id: json["id"],
        name: json["name"],
        baladyWorkFlow: json["baladyWorkFlow"] == null
            ? null
            : ContractType.fromJson(json["baladyWorkFlow"]),
        withFees: json["withFees"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "baladyWorkFlow": baladyWorkFlow?.toJson(),
        "withFees": withFees,
      };
}

class ContractType {
  final String? id;
  final String? name;

  ContractType({
    this.id,
    this.name,
  });

  ContractType copyWith({
    String? id,
    String? name,
  }) =>
      ContractType(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory ContractType.fromJson(Map<String, dynamic> json) => ContractType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class LicenseInfo {
  final String? licenseEndDate;
  final String? licenseSadadEndDate;
  final dynamic licensePeriod;
  final dynamic sadadPeriod;
  final int? licenseId;
  final int? statusId;
  final int? expireInDays;
  final dynamic oldLicenseNo;
  final String? issueDate;
  final bool? expired;
  final String? printUrl;
  final dynamic qrCodeUrl;
  final dynamic qrRequestId;
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

  LicenseInfo copyWith({
    String? licenseEndDate,
    String? licenseSadadEndDate,
    dynamic licensePeriod,
    dynamic sadadPeriod,
    int? licenseId,
    int? statusId,
    int? expireInDays,
    dynamic oldLicenseNo,
    String? issueDate,
    bool? expired,
    String? printUrl,
    dynamic qrCodeUrl,
    dynamic qrRequestId,
    String? statusDesc,
  }) =>
      LicenseInfo(
        licenseEndDate: licenseEndDate ?? this.licenseEndDate,
        licenseSadadEndDate: licenseSadadEndDate ?? this.licenseSadadEndDate,
        licensePeriod: licensePeriod ?? this.licensePeriod,
        sadadPeriod: sadadPeriod ?? this.sadadPeriod,
        licenseId: licenseId ?? this.licenseId,
        statusId: statusId ?? this.statusId,
        expireInDays: expireInDays ?? this.expireInDays,
        oldLicenseNo: oldLicenseNo ?? this.oldLicenseNo,
        issueDate: issueDate ?? this.issueDate,
        expired: expired ?? this.expired,
        printUrl: printUrl ?? this.printUrl,
        qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
        qrRequestId: qrRequestId ?? this.qrRequestId,
        statusDesc: statusDesc ?? this.statusDesc,
      );

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
  final dynamic urbiBuildingNumber;
  final String? streetName;
  final String? districtName;
  final String? subMunicipalityName;
  final String? municipalityId;
  final String? municipalityName;
  final String? subMunicipalityId;
  final int? regionId;
  final String? regionName;
  final dynamic vehiclePathDesc;
  final int? cityId;
  final String? cityName;
  final dynamic krokiUrl;

  LocationInfo({
    this.subMunicipalityGisCode,
    this.districtCode,
    this.streetCode,
    this.latitude,
    this.longitude,
    this.mapNo,
    this.landNo,
    this.urbiBuildingNumber,
    this.streetName,
    this.districtName,
    this.subMunicipalityName,
    this.municipalityId,
    this.municipalityName,
    this.subMunicipalityId,
    this.regionId,
    this.regionName,
    this.vehiclePathDesc,
    this.cityId,
    this.cityName,
    this.krokiUrl,
  });

  LocationInfo copyWith({
    String? subMunicipalityGisCode,
    int? districtCode,
    int? streetCode,
    String? latitude,
    String? longitude,
    String? mapNo,
    String? landNo,
    dynamic urbiBuildingNumber,
    String? streetName,
    String? districtName,
    String? subMunicipalityName,
    String? municipalityId,
    String? municipalityName,
    String? subMunicipalityId,
    int? regionId,
    String? regionName,
    dynamic vehiclePathDesc,
    int? cityId,
    String? cityName,
    dynamic krokiUrl,
  }) =>
      LocationInfo(
        subMunicipalityGisCode:
            subMunicipalityGisCode ?? this.subMunicipalityGisCode,
        districtCode: districtCode ?? this.districtCode,
        streetCode: streetCode ?? this.streetCode,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        mapNo: mapNo ?? this.mapNo,
        landNo: landNo ?? this.landNo,
        urbiBuildingNumber: urbiBuildingNumber ?? this.urbiBuildingNumber,
        streetName: streetName ?? this.streetName,
        districtName: districtName ?? this.districtName,
        subMunicipalityName: subMunicipalityName ?? this.subMunicipalityName,
        municipalityId: municipalityId ?? this.municipalityId,
        municipalityName: municipalityName ?? this.municipalityName,
        subMunicipalityId: subMunicipalityId ?? this.subMunicipalityId,
        regionId: regionId ?? this.regionId,
        regionName: regionName ?? this.regionName,
        vehiclePathDesc: vehiclePathDesc ?? this.vehiclePathDesc,
        cityId: cityId ?? this.cityId,
        cityName: cityName ?? this.cityName,
        krokiUrl: krokiUrl ?? this.krokiUrl,
      );

  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
        subMunicipalityGisCode: json["subMunicipalityGisCode"],
        districtCode: json["districtCode"],
        streetCode: json["streetCode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        mapNo: json["mapNo"],
        landNo: json["landNo"],
        urbiBuildingNumber: json["urbiBuildingNumber"],
        streetName: json["streetName"],
        districtName: json["districtName"],
        subMunicipalityName: json["subMunicipalityName"],
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        subMunicipalityId: json["subMunicipalityId"],
        regionId: json["regionId"],
        regionName: json["regionName"],
        vehiclePathDesc: json["vehiclePathDesc"],
        cityId: json["cityId"],
        cityName: json["cityName"],
        krokiUrl: json["krokiUrl"],
      );

  Map<String, dynamic> toJson() => {
        "subMunicipalityGisCode": subMunicipalityGisCode,
        "districtCode": districtCode,
        "streetCode": streetCode,
        "latitude": latitude,
        "longitude": longitude,
        "mapNo": mapNo,
        "landNo": landNo,
        "urbiBuildingNumber": urbiBuildingNumber,
        "streetName": streetName,
        "districtName": districtName,
        "subMunicipalityName": subMunicipalityName,
        "municipalityId": municipalityId,
        "municipalityName": municipalityName,
        "subMunicipalityId": subMunicipalityId,
        "regionId": regionId,
        "regionName": regionName,
        "vehiclePathDesc": vehiclePathDesc,
        "cityId": cityId,
        "cityName": cityName,
        "krokiUrl": krokiUrl,
      };
}

class OwnershipInfo {
  final ContractType? contractType;
  final TenancyContractInfo? tenancyContractInfo;
  final dynamic deedInfo;
  final dynamic investmentContractInfo;

  OwnershipInfo({
    this.contractType,
    this.tenancyContractInfo,
    this.deedInfo,
    this.investmentContractInfo,
  });

  OwnershipInfo copyWith({
    ContractType? contractType,
    TenancyContractInfo? tenancyContractInfo,
    dynamic deedInfo,
    dynamic investmentContractInfo,
  }) =>
      OwnershipInfo(
        contractType: contractType ?? this.contractType,
        tenancyContractInfo: tenancyContractInfo ?? this.tenancyContractInfo,
        deedInfo: deedInfo ?? this.deedInfo,
        investmentContractInfo:
            investmentContractInfo ?? this.investmentContractInfo,
      );

  factory OwnershipInfo.fromJson(Map<String, dynamic> json) => OwnershipInfo(
        contractType: json["contractType"] == null
            ? null
            : ContractType.fromJson(json["contractType"]),
        tenancyContractInfo: json["tenancyContractInfo"] == null
            ? null
            : TenancyContractInfo.fromJson(json["tenancyContractInfo"]),
        deedInfo: json["deedInfo"],
        investmentContractInfo: json["investmentContractInfo"],
      );

  Map<String, dynamic> toJson() => {
        "contractType": contractType?.toJson(),
        "tenancyContractInfo": tenancyContractInfo?.toJson(),
        "deedInfo": deedInfo,
        "investmentContractInfo": investmentContractInfo,
      };
}

class TenancyContractInfo {
  final String? tenancyContractNumber;
  final dynamic versionNumber;
  final dynamic nationalId;
  final dynamic contractEndDate;

  TenancyContractInfo({
    this.tenancyContractNumber,
    this.versionNumber,
    this.nationalId,
    this.contractEndDate,
  });

  TenancyContractInfo copyWith({
    String? tenancyContractNumber,
    dynamic versionNumber,
    dynamic nationalId,
    dynamic contractEndDate,
  }) =>
      TenancyContractInfo(
        tenancyContractNumber:
            tenancyContractNumber ?? this.tenancyContractNumber,
        versionNumber: versionNumber ?? this.versionNumber,
        nationalId: nationalId ?? this.nationalId,
        contractEndDate: contractEndDate ?? this.contractEndDate,
      );

  factory TenancyContractInfo.fromJson(Map<String, dynamic> json) =>
      TenancyContractInfo(
        tenancyContractNumber: json["tenancyContractNumber"],
        versionNumber: json["versionNumber"],
        nationalId: json["nationalId"],
        contractEndDate: json["contractEndDate"],
      );

  Map<String, dynamic> toJson() => {
        "tenancyContractNumber": tenancyContractNumber,
        "versionNumber": versionNumber,
        "nationalId": nationalId,
        "contractEndDate": contractEndDate,
      };
}

class ShopInfo {
  final String? shopName;
  final dynamic? shopUnitNumber;
  final dynamic? holesCount;
  final bool? existInMall;
  final dynamic? floorNumber;
  final dynamic? floorCount;
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
  final dynamic? slamaReportNumber;
  final dynamic isFawryWithSalamaBill;
  final dynamic isFawryWithSalamaReport;
  final dynamic isSalamaPermitMandatory;
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
  final dynamic insidePetrolStation;
  final dynamic? noOfCameras;

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
    this.insidePetrolStation,
    this.noOfCameras,
  });

  ShopInfo copyWith({
    String? shopName,
    int? shopUnitNumber,
    int? holesCount,
    bool? existInMall,
    int? floorNumber,
    int? floorCount,
    bool? hasElevator,
    bool? isCitizenPledgedToClean,
    dynamic cleanContractEndDate,
    dynamic buildingLicenseDate,
    dynamic buildingLicenseNo,
    dynamic buildingOwnerIdno,
    dynamic buildingOwnerName,
    String? landNumber,
    String? planNumber,
    dynamic salamaBillNumber,
    List<BoardsInfo>? boardsInfo,
    ContractInfoResponseDto? contractInfoResponseDto,
    bool? showShopOwnership,
    List<String>? slamaBillOptions,
    String? cameraBillOptions,
    String? endorsementText,
    List<String>? slamaReportOptions,
    int? slamaReportNumber,
    dynamic isFawryWithSalamaBill,
    dynamic isFawryWithSalamaReport,
    dynamic isSalamaPermitMandatory,
    dynamic cleanContractInfo,
    CleanContractOptions? cleanContractOptions,
    bool? showActivityCancellationDate,
    dynamic activityCancellationDate,
    dynamic mallDto,
    dynamic blockNumber,
    dynamic cancelReasonDto,
    bool? brand,
    dynamic salamaPermitNumber,
    dynamic licenseBrand,
    dynamic insidePetrolStation,
    int? noOfCameras,
  }) =>
      ShopInfo(
        shopName: shopName ?? this.shopName,
        shopUnitNumber: shopUnitNumber ?? this.shopUnitNumber,
        holesCount: holesCount ?? this.holesCount,
        existInMall: existInMall ?? this.existInMall,
        floorNumber: floorNumber ?? this.floorNumber,
        floorCount: floorCount ?? this.floorCount,
        hasElevator: hasElevator ?? this.hasElevator,
        isCitizenPledgedToClean:
            isCitizenPledgedToClean ?? this.isCitizenPledgedToClean,
        cleanContractEndDate: cleanContractEndDate ?? this.cleanContractEndDate,
        buildingLicenseDate: buildingLicenseDate ?? this.buildingLicenseDate,
        buildingLicenseNo: buildingLicenseNo ?? this.buildingLicenseNo,
        buildingOwnerIdno: buildingOwnerIdno ?? this.buildingOwnerIdno,
        buildingOwnerName: buildingOwnerName ?? this.buildingOwnerName,
        landNumber: landNumber ?? this.landNumber,
        planNumber: planNumber ?? this.planNumber,
        salamaBillNumber: salamaBillNumber ?? this.salamaBillNumber,
        boardsInfo: boardsInfo ?? this.boardsInfo,
        contractInfoResponseDto:
            contractInfoResponseDto ?? this.contractInfoResponseDto,
        showShopOwnership: showShopOwnership ?? this.showShopOwnership,
        slamaBillOptions: slamaBillOptions ?? this.slamaBillOptions,
        cameraBillOptions: cameraBillOptions ?? this.cameraBillOptions,
        endorsementText: endorsementText ?? this.endorsementText,
        slamaReportOptions: slamaReportOptions ?? this.slamaReportOptions,
        slamaReportNumber: slamaReportNumber ?? this.slamaReportNumber,
        isFawryWithSalamaBill:
            isFawryWithSalamaBill ?? this.isFawryWithSalamaBill,
        isFawryWithSalamaReport:
            isFawryWithSalamaReport ?? this.isFawryWithSalamaReport,
        isSalamaPermitMandatory:
            isSalamaPermitMandatory ?? this.isSalamaPermitMandatory,
        cleanContractInfo: cleanContractInfo ?? this.cleanContractInfo,
        cleanContractOptions: cleanContractOptions ?? this.cleanContractOptions,
        showActivityCancellationDate:
            showActivityCancellationDate ?? this.showActivityCancellationDate,
        activityCancellationDate:
            activityCancellationDate ?? this.activityCancellationDate,
        mallDto: mallDto ?? this.mallDto,
        blockNumber: blockNumber ?? this.blockNumber,
        cancelReasonDto: cancelReasonDto ?? this.cancelReasonDto,
        brand: brand ?? this.brand,
        salamaPermitNumber: salamaPermitNumber ?? this.salamaPermitNumber,
        licenseBrand: licenseBrand ?? this.licenseBrand,
        insidePetrolStation: insidePetrolStation ?? this.insidePetrolStation,
        noOfCameras: noOfCameras ?? this.noOfCameras,
      );

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
        isSalamaPermitMandatory: json["isSalamaPermitMandatory"],
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
        insidePetrolStation: json["insidePetrolStation"],
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
        "isSalamaPermitMandatory": isSalamaPermitMandatory,
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
        "insidePetrolStation": insidePetrolStation,
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

  BoardsInfo copyWith({
    int? typeId,
    String? typeName,
    double? area,
  }) =>
      BoardsInfo(
        typeId: typeId ?? this.typeId,
        typeName: typeName ?? this.typeName,
        area: area ?? this.area,
      );

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

  CleanContractOptions copyWith({
    String? cleanOption,
    String? contractOption,
  }) =>
      CleanContractOptions(
        cleanOption: cleanOption ?? this.cleanOption,
        contractOption: contractOption ?? this.contractOption,
      );

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
  final dynamic contractDate;
  final dynamic contractNumber;
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

  ContractInfoResponseDto copyWith({
    String? contractType,
    String? contractOption,
    dynamic tenancyContractInfo,
    dynamic deedInfoResponse,
    dynamic contractDate,
    dynamic contractNumber,
    ContractOptionsResponseDto? contractOptionsResponseDto,
    dynamic investmentContractNumber,
  }) =>
      ContractInfoResponseDto(
        contractType: contractType ?? this.contractType,
        contractOption: contractOption ?? this.contractOption,
        tenancyContractInfo: tenancyContractInfo ?? this.tenancyContractInfo,
        deedInfoResponse: deedInfoResponse ?? this.deedInfoResponse,
        contractDate: contractDate ?? this.contractDate,
        contractNumber: contractNumber ?? this.contractNumber,
        contractOptionsResponseDto:
            contractOptionsResponseDto ?? this.contractOptionsResponseDto,
        investmentContractNumber:
            investmentContractNumber ?? this.investmentContractNumber,
      );

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

class ContractOptionsResponseDto {
  final List<String>? ejarOptions;
  final List<String>? deedOptions;
  final List<String>? investOptions;

  ContractOptionsResponseDto({
    this.ejarOptions,
    this.deedOptions,
    this.investOptions,
  });

  ContractOptionsResponseDto copyWith({
    List<String>? ejarOptions,
    List<String>? deedOptions,
    List<String>? investOptions,
  }) =>
      ContractOptionsResponseDto(
        ejarOptions: ejarOptions ?? this.ejarOptions,
        deedOptions: deedOptions ?? this.deedOptions,
        investOptions: investOptions ?? this.investOptions,
      );

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
