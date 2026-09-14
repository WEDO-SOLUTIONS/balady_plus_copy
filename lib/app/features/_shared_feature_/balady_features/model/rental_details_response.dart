import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class RentalDetailsResponse {
  RentalDetailsResponse({this.statusDetails, this.data});

  List<StatusDetail>? statusDetails;
  Data? data;

  factory RentalDetailsResponse.fromJson(Map<String, dynamic> json) => RentalDetailsResponse(
    statusDetails: json["statusDetails"] == null
        ? null
        : List<StatusDetail>.from(json["statusDetails"].map((x) => StatusDetail.fromJson(x))),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  Data({this.responseCode, this.responseMessage, this.details});

  dynamic responseCode;
  String? responseMessage;
  Details? details;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    responseCode: json["responseCode"],
    responseMessage: json["responseMessage"],
    details: json["result"] == null ? null : Details.fromJson(json["result"]),
  );
}

class TempRentalData {
  TempRentalData({this.responseCode, this.responseMessage, this.details});
  dynamic responseCode;
  String? responseMessage;
  TempRentalResult? details;

  TempRentalData.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    details = json['result'] != null ? TempRentalResult.fromJson(json['result']) : null;
  }
}

class TempRentalResult {
  String? caseID;
  String? assignmentKey;
  String? message;

  TempRentalResult({required this.caseID, required this.assignmentKey, this.message});

  factory TempRentalResult.fromJson(Map<String, dynamic> json) =>
      TempRentalResult(assignmentKey: json["Assignmentkey"], caseID: json["ID"], message: json["message"]);

  String getID() {
    String id = caseID ?? "";
    try {
      id = id.split(" ").last;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }

    return id;
  }
}

class CreateTempRentalResponse {
  CreateTempRentalResponse({this.statusDetails, this.data});

  List<StatusDetails>? statusDetails;
  TempRentalData? data;

  CreateTempRentalResponse.fromJson(Map<String, dynamic> json) {
    statusDetails = json['statusDetails'] != null
        ? List.from(json['statusDetails']).map((e) => StatusDetails.fromJson(e)).toList()
        : null;
    data = json['data'] != null ? TempRentalData.fromJson(json['data']) : null;
  }
}

class StatusDetails {
  StatusDetails({this.code, this.message});
  int? code;
  String? message;

  StatusDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}

class Details {
  Details({
    this.sourceCaseKey,
    this.plotNumberList,
    this.siteArea,
    this.isAddInfoVisibleToInvestor,
    this.isSTRPCreated,
    this.totalContractTerm,
    this.attachmentShownToInvestors,
    this.technicalRequirementsNeeded,
    this.blockedPeriodList,
    this.annualRentalValue,
    this.municipalityId,
    this.isFavourite,
    this.orgSketchNumber,
    this.startDate,
    this.numberOfDays,
    this.rentPeriodList,
    this.rentPeriodList1,
    this.announcementDateTime,
    this.annualRentalWithVat,
    this.subMunicipality,
    this.otherData,
    this.vatAmount,
    this.street,
    this.id,
    this.totalRentalValue,
    this.landNumber,
    this.seasonalOpportunity,
    this.selectedLocationTypeList,
    this.targetedTourismActivities,
    this.subMunicipalityId,
    this.municipality,
    this.siteAddress,
    this.preparationPeriod,
    this.opportunityNumber,
    this.attachmentNeededFromInvestor,
    this.totalRentalWithVat,
    this.sketchNumber,
    this.sourceCaseId,
    this.opportunityName,
    this.message,
    this.mainActivityId,
    this.pricePerSquareMeter,
    this.siteDescription,
    this.locationType,
    this.coOrdinatesList,
    this.blockedPeriodList1,
    this.cityCode,
    this.regionCode,
    this.entityName,
    this.entityID,
    this.cities,
    this.isEntityOpportunity,
    this.regions,
  });

  String? sourceCaseKey;
  String? message;
  String? mainActivityId;
  List<String>? plotNumberList;
  dynamic siteArea;
  dynamic isAddInfoVisibleToInvestor;
  dynamic isSTRPCreated;
  dynamic totalContractTerm;
  List<AttachmentShownToInvestor>? attachmentShownToInvestors;
  List<dynamic>? blockedPeriodList;
  dynamic annualRentalValue;
  String? municipalityId;
  String? orgSketchNumber;
  String? startDate;
  bool? isFavourite;
  dynamic numberOfDays;
  List<RentPeriodList>? rentPeriodList;
  List<RentalAndBlockedPeriod>? rentPeriodList1;
  List<RentalAndBlockedPeriod>? blockedPeriodList1;

  String? announcementDateTime;
  dynamic annualRentalWithVat;
  String? subMunicipality;
  String? otherData;
  dynamic vatAmount;
  String? street;
  String? id;
  dynamic totalRentalValue;
  String? landNumber;
  bool? seasonalOpportunity;
  List<SelectedLocationTypeList>? selectedLocationTypeList;
  String? subMunicipalityId;
  String? municipality;
  String? siteAddress;
  dynamic preparationPeriod;
  String? opportunityNumber;
  List<AttachmentNeededFromInvestor>? attachmentNeededFromInvestor;
  dynamic totalRentalWithVat;
  String? sketchNumber;
  String? sourceCaseId;
  String? opportunityName;
  dynamic pricePerSquareMeter;
  String? siteDescription;
  String? locationType;
  List<CoOrdinatesList>? coOrdinatesList;
  List<TargetedTourismActivity>? targetedTourismActivities;
  List<TargetedTourismActivity>? technicalRequirementsNeeded;

  String? cityCode;
  String? regionCode;
  String? entityName;
  String? entityID;
  String? cities;
  bool? isEntityOpportunity;
  String? regions;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
    sourceCaseKey: json["SourceCaseKey"],
    plotNumberList: json["PlotNumberList"] == null ? null : List<String>.from(json["PlotNumberList"].map((x) => x)),
    siteArea: json["SiteArea"],
    message: json["message"],
    isAddInfoVisibleToInvestor: json["IsAddInfoVisibleToInvestor"],
    isSTRPCreated: json["IsSTRPCreated"],
    totalContractTerm: json["TotalContractTerm"],
    attachmentShownToInvestors: json["AttachmentShownToInvestors"] == null
        ? null
        : List<AttachmentShownToInvestor>.from(
            json["AttachmentShownToInvestors"].map((x) => AttachmentShownToInvestor.fromJson(x)),
          ),
    technicalRequirementsNeeded: json["TechnicalRequirementsNeeded"] == null
        ? null
        : List<TargetedTourismActivity>.from(
            json["TechnicalRequirementsNeeded"].map((x) => TargetedTourismActivity.fromJson(x)),
          ),
    targetedTourismActivities: json["TargetedTourismActivities"] == null
        ? null
        : List<TargetedTourismActivity>.from(
            json["TargetedTourismActivities"].map((x) => TargetedTourismActivity.fromJson(x)),
          ),
    blockedPeriodList: json["BlockedPeriodList"] == null
        ? null
        : List.castFrom<dynamic, dynamic>(json['BlockedPeriodList']!),
    annualRentalValue: json["AnnualRentalValue"],
    municipalityId: json["MunicipalityID"],
    orgSketchNumber: json["OrgSketchNumber"],
    startDate: json["StartDate"],
    mainActivityId: json["MainActivityID"],
    numberOfDays: json["NumberOfDays"],
    rentPeriodList1: json["RentPeriodList"] == null
        ? []
        : List<RentalAndBlockedPeriod>.from(json["RentPeriodList"].map((x) => RentalAndBlockedPeriod.fromJson(x))),
    blockedPeriodList1: json["BlockedPeriodList"] == null
        ? []
        : List<RentalAndBlockedPeriod>.from(json["BlockedPeriodList"].map((x) => RentalAndBlockedPeriod.fromJson(x))),
    rentPeriodList: json["RentPeriodList"] == null
        ? []
        : List<RentPeriodList>.from(json["RentPeriodList"].map((x) => RentPeriodList.fromJson(x))),
    isFavourite: json["IsFavourite"],
    announcementDateTime: json["AnnouncementDateTime"],
    annualRentalWithVat: json["AnnualRentalWithVat"],
    subMunicipality: json["SubMunicipality"],
    otherData: json["OtherData"],
    vatAmount: json["VATAmount"],
    street: json["Street"],
    id: json["ID"],
    totalRentalValue: json["TotalRentalValue"],
    landNumber: json["LandNumber"],
    seasonalOpportunity: json["SeasonalOpportunity"],
    selectedLocationTypeList: json["SelectedLocationTypeList"] == null
        ? []
        : List<SelectedLocationTypeList>.from(
            json["SelectedLocationTypeList"].map((x) => SelectedLocationTypeList.fromJson(x)),
          ),
    subMunicipalityId: json["SubMunicipalityID"],
    municipality: json["Municipality"],
    siteAddress: json["SiteAddress"],
    preparationPeriod: json["PreparationPeriod"],
    opportunityNumber: json["OpportunityNumber"],
    attachmentNeededFromInvestor: json["AttachmentNeededFromInvestor"] == null
        ? null
        : List<AttachmentNeededFromInvestor>.from(
            json["AttachmentNeededFromInvestor"].map((x) => AttachmentNeededFromInvestor.fromJson(x)),
          ),
    totalRentalWithVat: json["TotalRentalWithVat"],
    sketchNumber: json["SketchNumber"],
    sourceCaseId: json["SourceCaseID"],
    opportunityName: json["OpportunityName"],
    pricePerSquareMeter: json["PricePerSquareMeter"],
    siteDescription: json["SiteDescription"],
    locationType: json["LocationType"],
    coOrdinatesList: json["CoOrdinatesList"] == null
        ? null
        : List<CoOrdinatesList>.from(json["CoOrdinatesList"].map((x) => CoOrdinatesList.fromJson(x))),
    cityCode: json["CityCode"],
    regionCode: json["RegionCode"],
    entityName: json["EntityName"],
    entityID: json["EntityID"],
    cities: json["Cities"],
    isEntityOpportunity: json["IsEntityOpportunity"],
    regions: json["Regions"],
  );

  LatLng? getLocation() {
    double? xCoordinate = coOrdinatesList?[0].xCoordinate;
    double? yCoordinate = coOrdinatesList?[0].yCoordinate;
    if (xCoordinate != null && yCoordinate != null) {
      return LatLng(latitude: yCoordinate, longitude: xCoordinate);
    }

    return null;
  }

  bool isSeasonal() {
    if (seasonalOpportunity != null && seasonalOpportunity!) return true;
    return false;
  }

  List<LatLng> getAllLocationsPins() {
    List<LatLng> locations = [];
    int maxLength = 0;
    if (coOrdinatesList != null) {
      maxLength = coOrdinatesList!.length > 100 ? 100 : coOrdinatesList!.length;
    }
    for (int i = 0; i < maxLength; i++) {
      double? xCoordinate = coOrdinatesList![i].xCoordinate;
      double? yCoordinate = coOrdinatesList![i].yCoordinate;
      if (xCoordinate != null && yCoordinate != null) {
        locations.add(LatLng(latitude: yCoordinate, longitude: xCoordinate));
      }
    }

    return locations;
  }

  String getPrice() {
    //double area = double.tryParse((this.siteArea.toString())) ?? 0.0;

    if (rentPeriodList != null && rentPeriodList!.isNotEmpty) {
      if (rentPeriodList![0].dailyLeaseCost != null) {
        double price = double.tryParse(rentPeriodList![0].dailyLeaseCost.toString()) ?? 0.0;
        return price.toString();
      }
    }
    return "0.0";
  }

  String? getActivityName() {
    if (selectedLocationTypeList != null && selectedLocationTypeList!.isNotEmpty) {
      return selectedLocationTypeList![0].getName();
    }
    return null;
  }

  String? getActivityId() {
    if (selectedLocationTypeList != null && selectedLocationTypeList!.isNotEmpty) {
      return selectedLocationTypeList![0].id;
    }
    return null;
  }

  String getNumberOfDays() {
    return numberOfDays?.toString() ?? "";
  }

  String getDuration() {
    return totalContractTerm?.toString() ?? "";
  }

  String getFirstRentValue() {
    return annualRentalValue?.toString() ?? "";
  }

  String getFirstRentValueWithVat() {
    return annualRentalWithVat?.toString() ?? "";
  }

  String getTotalRentValue() {
    return totalRentalValue?.toString() ?? "";
  }

  String getTotalRentValueWithVat() {
    return totalRentalWithVat?.toString() ?? "";
  }

  String getPreparationPeriod() {
    return preparationPeriod?.toString() ?? "";
  }

  List<String> getTargetedTourismActivities() {
    return targetedTourismActivities?.map((e) => e.pyTempText ?? "").toList() ?? [];
  }

  List<String> getTechnicalRequirementsNeeded() {
    return technicalRequirementsNeeded?.map((e) => e.pyTempText ?? "").toList() ?? [];
  }

  String getStartPeriodDate() {
    if (rentPeriodList?.first.rentalStartDate != null) {
      return getFormattedDate(rentPeriodList!.first.rentalStartDate);
    }
    return "";
  }

  String getEndPeriodDate() {
    if (rentPeriodList?.first.rentalEndDate != null) {
      return getFormattedDate(rentPeriodList!.first.rentalEndDate);
    }
    return "";
  }

  String getFormattedDate(String? dateStr) {
    String formmatedDateAndTime = "";
    try {
      String bidEndDate = dateStr ?? "";
      DateTime dateAndTime = DateTime.parse(bidEndDate);

      String date = DateFormat.yMMMMd('ar_SA').format(dateAndTime).toString();

      formmatedDateAndTime = date;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }

    formmatedDateAndTime = CommonFunctions.replaceArabicNumberWithEnglish(formmatedDateAndTime);
    return formmatedDateAndTime;
  }

  /*
  String getCurrentDayPrice() {
    return "0.0";
    //  return day
    if (rentPeriodList1 != null && rentPeriodList1!.isNotEmpty) {
      DateTime day = DateTime.now();
      for (var rental in rentPeriodList1!) {
        final sd = DateTime.tryParse(rental.rentalStartDate!); // start date
        final ed = DateTime.tryParse(rental.rentalEndDate!); // end date
        if ((day.day == sd!.day &&
                day.month == sd.month &&
                day.year == sd.year) ||
            (day.day == ed!.day &&
                day.month == ed.month &&
                day.year == ed.year) ||
            (day.isAfter(sd) && day.isBefore(ed))) {
          double area = double.tryParse((this.siteArea.toString())) ?? 0.0;
          dynamic rentalLeastCost = rental.dailyLeaseCost ?? 0.0;

          return (area * rentalLeastCost).toString();
        }
      }
    }
    return "";
  }*/

  String getArea() {
    return '${"m2".tr()} ${siteArea?.toString() ?? "0.0"})';
  }

  List<AttachmentShownToInvestor> getAttachmentShownToInvestor() {
    List<AttachmentShownToInvestor> list = [];
    if (attachmentShownToInvestors != null) {
      list = attachmentShownToInvestors!.where((element) => element.attachmentVisibleToInvestor == true).toList();
    }
    return list;
  }

  bool getEntityOpportunity() {
    return isEntityOpportunity ?? false;
  }

  String getMuncipalityAndSubMuncipality() {
    return "${municipality ?? ""} - ${subMunicipality ?? ""}";
  }

  List<String> getCitiesOrRegions() {
    if (isEntityOpportunity == true) {
      if (cities != null && cities!.isNotEmpty) {
        return cities!.split(",");
      } else if (regions != null && regions!.isNotEmpty) {
        return regions!.split(",");
      }
    }
    return [];
  }

  bool isCities() {
    if (isEntityOpportunity == true) {
      if (cities != null && cities!.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  String getEntityORMinstryName() {
    return getEntityOpportunity() ? (entityName ?? "") : ("momra").tr();
  }

  String getAdminMuncipalityOrCity() {
    return getEntityOpportunity() ? (getCitiesOrRegions().firstOrNull ?? "") : (subMunicipality ?? "");
    //return cities?.split(",").first ?? ;
    //   return getEntityOpportunity() ? (city ?? "") : (municipality ?? "");
  }
}

class AttachmentNeededFromInvestor {
  AttachmentNeededFromInvestor({this.isRequired, this.pyCategoryName, this.attachmentName});

  String? isRequired;
  String? pyCategoryName;
  String? attachmentName;

  factory AttachmentNeededFromInvestor.fromJson(Map<String, dynamic> json) => AttachmentNeededFromInvestor(
    isRequired: json["IsRequired"],
    pyCategoryName: json["pyCategoryName"],
    attachmentName: json["AttachmentName"],
  );
}

class AttachmentShownToInvestor {
  AttachmentShownToInvestor({
    this.fileKey,
    this.attachmentVisibleToInvestor,
    this.pyCategoryName,
    this.pyFileName,
    this.pyLabel,
  });

  String? fileKey;
  bool? attachmentVisibleToInvestor;
  String? pyCategoryName;
  String? pyFileName;
  String? pyLabel;

  factory AttachmentShownToInvestor.fromJson(Map<String, dynamic> json) => AttachmentShownToInvestor(
    fileKey: json["FileKey"],
    attachmentVisibleToInvestor: json["AttachmentVisibleToInvestor"] ?? false,
    pyCategoryName: json["pyCategoryName"],
    pyFileName: json["pyFileName"],
    pyLabel: json["pyLabel"],
  );
}

class BlockedPeriodList {
  BlockedPeriodList({this.rentalStartDate, this.rentalEndDate, this.id});

  String? rentalStartDate;
  String? rentalEndDate;
  String? id;

  factory BlockedPeriodList.fromJson(Map<String, dynamic> json) =>
      BlockedPeriodList(rentalStartDate: json["RentalStartDate"], rentalEndDate: json["RentalEndDate"], id: json["ID"]);
}

class SelectedLocationTypeList {
  SelectedLocationTypeList({this.id, this.pyTempText, this.name});

  String? id;
  String? pyTempText;
  String? name;

  factory SelectedLocationTypeList.fromJson(Map<String, dynamic> json) =>
      SelectedLocationTypeList(id: json["ID"], pyTempText: json["pyTempText"], name: json["Name"]);

  String? getName() {
    if (CommonFunctions.isAppAR) {
      return pyTempText;
    } else {
      return name;
    }
  }
}

class StatusDetail {
  StatusDetail({this.code, this.message});

  int? code;
  String? message;

  factory StatusDetail.fromJson(Map<String, dynamic> json) =>
      StatusDetail(code: json["code"], message: json["message"]);
}

class RentalAndBlockedPeriod {
  final String? rentalStartDate;
  final String? rentalEndDate;
  final String? id;
  final dynamic dailyLeaseCost;

  RentalAndBlockedPeriod({required this.rentalStartDate, required this.rentalEndDate, this.id, this.dailyLeaseCost});

  factory RentalAndBlockedPeriod.fromJson(Map<String, dynamic> json) => RentalAndBlockedPeriod(
    rentalStartDate: json["RentalStartDate"],
    rentalEndDate: json["RentalEndDate"],
    id: json["ID"] ?? "",
    dailyLeaseCost: json["DailyLeaseCost"] ?? 0.0,
  );

  static List<RentalAndBlockedPeriod> getListOfPeriod(List<dynamic> list) =>
      list.isNotEmpty ? List.generate(list.length, (index) => RentalAndBlockedPeriod.fromJson(list[index])) : [];
}

class TargetedTourismActivity {
  TargetedTourismActivity({this.pyCategory, this.pxCreateOperator, this.pxAttachedBy, this.pyTempText});

  String? pyCategory;
  String? pxCreateOperator;
  String? pxAttachedBy;
  String? pyTempText;

  factory TargetedTourismActivity.fromJson(Map<String, dynamic> json) => TargetedTourismActivity(
    pyCategory: json["pyCategory"],
    pxCreateOperator: json["pxCreateOperator"],
    pxAttachedBy: json["pxAttachedBy"],
    pyTempText: json["pyTempText"],
  );

  Map<String, dynamic> toJson() => {
    "pyCategory": pyCategory,
    "pxCreateOperator": pxCreateOperator,
    "pxAttachedBy": pxAttachedBy,
    "pyTempText": pyTempText,
  };
}

class CoOrdinatesList {
  CoOrdinatesList({this.xCoordinate, this.pzInsKey, this.yCoordinate});

  double? xCoordinate;
  String? pzInsKey;
  double? yCoordinate;

  factory CoOrdinatesList.fromJson(Map<String, dynamic> json) => CoOrdinatesList(
    xCoordinate: json["XCoordinate"]?.toDouble(),
    pzInsKey: json["pzInsKey"],
    yCoordinate: json["YCoordinate"] != null ? json["YCoordinate"].toDouble() : json["YCoordinate"],
  );

  Map<String, dynamic> toJson() => {"XCoordinate": xCoordinate, "pzInsKey": pzInsKey, "YCoordinate": yCoordinate};
  LatLng? getLocation() {
    if (xCoordinate != null && yCoordinate != null) {
      return LatLng(latitude: yCoordinate!, longitude: xCoordinate!);
    }

    return null;
  }
}

class RentPeriodList {
  RentPeriodList({this.dailyLeaseCost, this.rentalStartDate, this.rentalEndDate});

  dynamic dailyLeaseCost;
  String? rentalStartDate;
  String? rentalEndDate;

  factory RentPeriodList.fromJson(Map<String, dynamic> json) => RentPeriodList(
    dailyLeaseCost: json["DailyLeaseCost"],
    rentalStartDate: json["RentalStartDate"],
    rentalEndDate: json["RentalEndDate"],
  );

  Map<String, dynamic> toJson() => {
    "DailyLeaseCost": dailyLeaseCost,
    "RentalStartDate": rentalStartDate,
    "RentalEndDate": rentalEndDate,
  };
}
