import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dgis_map/library.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class InvestmentDetailsResponse {
  InvestmentDetailsResponse({this.statusDetails, this.data});

  List<StatusDetail>? statusDetails;
  Data? data;

  factory InvestmentDetailsResponse.fromJson(Map<String, dynamic> json) => InvestmentDetailsResponse(
    statusDetails: json["statusDetails"] == null
        ? null
        : List<StatusDetail>.from(json["statusDetails"].map((x) => StatusDetail.fromJson(x))),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class RequiredAttachmentCategory {
  RequiredAttachmentCategory({this.id, this.name});

  String? id;
  String? name;

  factory RequiredAttachmentCategory.fromJson(Map<String, dynamic> json) =>
      RequiredAttachmentCategory(id: json["ID"], name: json["Name"]);

  Map<String, dynamic> toJson() => {"ID": id, "Name": name};
}

class Data {
  Data({this.responseCode, this.responseMessage, this.result});

  dynamic responseCode;
  String? responseMessage;
  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    responseCode: json["responseCode"],
    responseMessage: json["responseMessage"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );
}

class Result {
  Result({
    this.appendixList,
    this.announcementDate,
    this.mainActivityId,
    this.pyExpirationDate,
    this.mainActivity,
    this.envelopOpeningDate,
    this.municipalityId,
    this.favoriteInd,
    this.isFavourite,
    this.specialOpportunity,
    this.offerType,
    this.submittingEnvelopesLocation,
    this.openingEnvelopeTime,
    this.subMunicipality,
    this.bidEndDate,
    required this.id,
    this.offeringDate,
    this.offeringTime,
    this.message,
    this.opportunityList,
    // this.offeringPeriod,
    this.envelopeOpeningLocation,
    this.subMunicipalityId,
    this.contractDuration,
    this.contractDurationMonths,
    this.biddingEndingTime,
    this.municipality,
    this.opportunityDescription,
    this.termsSpecDocument,
    this.opportunityNumber,
    this.documentValue,
    this.contractTemplate,
    this.opportunityType,
    this.requiredAttachmentCategoryList,
    this.paymentType,
    this.preparationPeriodPercentage,
    this.sadadStatus,
    this.caseStatus,
    this.caseStatusEN,
    this.purchaseDocumentStatus,
    this.sadadNumber,
    this.cityCode,
    this.regionCode,
    this.entityName,
    this.entityID,
    this.cities,
    this.isEntityOpportunity,
    this.regions,
    this.applyAnnualRaise,
    this.yearsForAnnualRaise,
    this.annualRaisePercentage,
    this.isBillingApplicableForEntityOpportunity,
    this.bankWarrantyType,
    this.deductInitialyWarrantyFirstYear,
    this.isBiddingNotAllowed,
    this.initialWarrantyPercentage,
    this.rfpHasPrice,
    this.bidEndDateTime,
    this.queryEndDateTime,
    this.rFPEndDateTime,
    this.envelopOpeningDateTime,
    this.annualContractValue,
    this.opportunityAvailability,
    this.totalContractValue,
  });

  String? message;
  List<dynamic>? appendixList;
  String? announcementDate;
  String? mainActivityId;
  String? pyExpirationDate;
  String? mainActivity;
  String? envelopOpeningDate;
  String? municipalityId;
  String? favoriteInd;
  bool? isFavourite;
  bool? specialOpportunity;
  String? offerType;
  String? submittingEnvelopesLocation;
  String? openingEnvelopeTime;
  String? subMunicipality;
  String? bidEndDate;
  String id;
  String? offeringDate;
  String? offeringTime;
  List<OpportunityList>? opportunityList;
  //int? offeringPeriod;
  String? envelopeOpeningLocation;
  String? subMunicipalityId;
  String? contractDuration;
  String? contractDurationMonths;
  String? biddingEndingTime;
  String? municipality;
  String? opportunityDescription;
  List<ContractTemplate>? termsSpecDocument;
  String? opportunityNumber;
  double? documentValue;
  List<ContractTemplate>? contractTemplate;
  String? opportunityType;
  List<RequiredAttachmentCategoryList>? requiredAttachmentCategoryList;
  List<LatLng>? allLocations;
  String? paymentType;
  double? preparationPeriodPercentage;
  List<ContractTemplate>? contractTemplateAndTerms;
  String? sadadStatus;
  String? purchaseDocumentStatus;
  String? caseStatusEN;
  String? caseStatus;
  String? sadadNumber;
  String? cityCode;
  String? regionCode;
  String? entityName;
  String? entityID;
  String? cities;
  bool? isEntityOpportunity;
  String? regions;
  String? applyAnnualRaise;
  int? yearsForAnnualRaise;
  double? annualRaisePercentage;
  String? isBillingApplicableForEntityOpportunity;
  String? bankWarrantyType;
  String? deductInitialyWarrantyFirstYear;
  String? isBiddingNotAllowed;
  double? initialWarrantyPercentage;
  String? rfpHasPrice;
  String? envelopOpeningDateTime;
  String? bidEndDateTime;
  String? queryEndDateTime;
  String? rFPEndDateTime;
  String? annualContractValue;
  String? opportunityAvailability;
  double? totalContractValue;

  factory Result.fromJson(Map<String, dynamic> json) {
    Result r = Result(
      appendixList: json["AppendixList"] == null ? null : List<dynamic>.from(json["AppendixList"].map((x) => x)),
      announcementDate: json["AnnouncementDate"],
      message: json["message"],
      mainActivityId: json["MainActivityID"],
      pyExpirationDate: json["pyExpirationDate"],
      mainActivity: json["MainActivity"],
      envelopOpeningDate: json["EnvelopOpeningDate"],
      municipalityId: json["MunicipalityID"],
      favoriteInd: json["FavoriteInd"],
      isFavourite: json["IsFavourite"],
      specialOpportunity: json["SpecialOpportunity"],
      offerType: json["OfferType"],
      submittingEnvelopesLocation: json["SubmittingEnvelopesLocation"],
      openingEnvelopeTime: json["OpeningEnvelopeTime"],
      subMunicipality: json["SubMunicipality"],
      bidEndDate: json["BidEndDate"],
      id: json["ID"],
      offeringDate: json["OfferingDate"],
      offeringTime: json["OfferingTime"],
      opportunityList: json["OpportunityList"] == null
          ? null
          : List<OpportunityList>.from(json["OpportunityList"].map((x) => OpportunityList.fromJson(x))),
      //  offeringPeriod: json["OfferingPeriod"],
      envelopeOpeningLocation: json["EnvelopeOpeningLocation"],
      subMunicipalityId: json["SubMunicipalityID"],
      contractDuration: json["ContractDuration"],
      contractDurationMonths: json["ContractDurationMonths"],
      biddingEndingTime: json["BiddingEndingTime"],
      municipality: json["Municipality"],
      opportunityDescription: json["OpportunityDescription"],
      termsSpecDocument: json["TermsSpecDocument"] == null
          ? null
          : List<ContractTemplate>.from(json["TermsSpecDocument"].map((x) => ContractTemplate.fromJson(x))),
      opportunityNumber: json["OpportunityNumber"],
      documentValue: json["DocumentValue"]?.toDouble(),
      contractTemplate: json["ContractTemplate"] == null
          ? null
          : List<ContractTemplate>.from(json["ContractTemplate"].map((x) => ContractTemplate.fromJson(x))),
      opportunityType: json["OpportunityType"],
      requiredAttachmentCategoryList: json["RequiredAttachmentCategoryList"] == null
          ? null
          : List<RequiredAttachmentCategoryList>.from(
              json["RequiredAttachmentCategoryList"].map((x) => RequiredAttachmentCategoryList.fromJson(x)),
            ),
      paymentType: json["PaymentType"],
      preparationPeriodPercentage: json["PreparationPeriodPercentage"]?.toDouble(),
      sadadStatus: json["SadadStatus"],
      purchaseDocumentStatus: json["PurchaseDocumentStatus"],
      caseStatusEN: json["CaseStatusEN"],
      caseStatus: json["CaseStatus"],
      sadadNumber: json["SadadNumber"],
      cityCode: json["CityCode"],
      regionCode: json["RegionCode"],
      entityName: json["EntityName"],
      entityID: json["EntityID"],
      cities: json["Cities"],
      isEntityOpportunity: json["IsEntityOpportunity"],
      regions: json["Regions"],
      applyAnnualRaise: json["ApplyAnnualRaise"],
      yearsForAnnualRaise: json["YearsForAnnualRaise"],
      annualRaisePercentage: json["AnnualRaisePercentage"]?.toDouble(),
      isBillingApplicableForEntityOpportunity: json["IsBillingApplicableForEntityOpportunity"],
      bankWarrantyType: json["BankWarrantyType"],
      deductInitialyWarrantyFirstYear: json["DeductInitialyWarrantyFirstYear"],
      isBiddingNotAllowed: json["IsBiddingNotAllowed"],
      initialWarrantyPercentage: json["InitialWarrantyPercentage"]?.toDouble(),
      rfpHasPrice: json["RFPHasPrice"],
      bidEndDateTime: json["BidEndDateTime"],
      queryEndDateTime: json["QueryEndDateTime"],
      rFPEndDateTime: json["RFPEndDateTime"],
      envelopOpeningDateTime: json["EnvelopOpeningDateTime"],
      annualContractValue: json["AnnualContractValue"],
      opportunityAvailability: json["OpportunityAvailability"],
      totalContractValue: json["TotalContractValue"]?.toDouble(),
    );
    r.allLocations = getAllLocations(r.opportunityList ?? []);

    r.contractTemplateAndTerms = getContractTemplate(r.contractTemplate, r.termsSpecDocument);

    return r;
  }

  bool isFree() {
    return rfpHasPrice != null && rfpHasPrice?.toLowerCase() == "no";
  }

  bool get isOpportunityAvailabile => opportunityAvailability == "Available";

  double getWarrentyPercentage() {
    try {
      if (initialWarrantyPercentage != null) {
        return initialWarrantyPercentage! / 100;
      }
      return 25 / 100;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      return 25 / 100;
    }
  }

  bool canPurchaseBooklet() {
    if (isEntityOpportunity == true) {
      if (isBillingApplicableForEntityOpportunity?.toLowerCase() == "yes") {
        return true;
      }
      return false;
    }
    return true;
  }

  bool canSubmitBid() {
    if (isEntityOpportunity == true) {
      if (isBiddingNotAllowed?.toLowerCase() == "true") {
        return false;
      }
      return true;
    }
    return true;
  }

  String? getDeductInitialyWarrantyFirstYear() {
    if (deductInitialyWarrantyFirstYear?.toLowerCase() == "yes") {
      return ("DeductInitialyWarrantyFirstYear_Yes").tr();
    } else if (deductInitialyWarrantyFirstYear?.toLowerCase() == "no") {
      return ("DeductInitialyWarrantyFirstYear_NO").tr();
    }
    return null;
  }

  bool saddadIssued() {
    return sadadStatus == "Issued";
  }

  bool saddadPaied() {
    return purchaseDocumentStatus == "Resolved-Completed";
  }

  bool saddadExpired() {
    return purchaseDocumentStatus == "Resolved-Expired";
  }

  String getFormattedBidEndDateAndTime() {
    return getFormattedDateAndTimeV2(bidEndDateTime ?? "");
  }

  String getFormattedEnvelopeOpenDateAndTime() {
    return getFormattedDateAndTimeV2(envelopOpeningDateTime ?? "");
  }

  String getFormattedQueryDateAndTime() {
    return getFormattedDateAndTimeV2(queryEndDateTime ?? "");
  }

  String getFormattedLastBuyRFPAndTime() {
    return getFormattedDateAndTimeV2(rFPEndDateTime ?? "");
  }

  String getFormattedLastBidDateAndTime() {
    return getFormattedDateAndTimeV2(bidEndDateTime ?? "");
  }

  DateTime? getEnvelopOpeningDate() {
    if (envelopOpeningDate != null) {
      return DateTime.tryParse(envelopOpeningDate!);
    }
    return null;
  }

  String getBidEndDate() {
    String date = "";
    try {
      if (bidEndDate != null) {
        date = DateFormat.yMMMd(CommonFunctions.isAppAR ? 'ar_SA' : 'en_US').format(DateTime.parse(bidEndDate!));
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    if (CommonFunctions.isAppAR) {
      date = CommonFunctions.replaceArabicNumberWithEnglish(date);
    }

    return date;
  }

  String getArea() {
    // return sprintf(trans("m2"), [getTotalSiteArea()]); //MM
    return getTotalSiteArea() ?? "";
  }

  String getPaymentType() {
    try {
      if (paymentType == "متغير") {
        double? annualRaisePercentage = this.annualRaisePercentage;
        int? yearsForAnnualRaise = this.yearsForAnnualRaise;

        if (applyAnnualRaise == "Yes") {
          return "${paymentType ?? ""}, ${("var_payment_agreement").tr().replaceAll("-", annualRaisePercentage.toString()).replaceAll("ـ", yearsForAnnualRaise.toString())}";
        }
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }

    return paymentType ?? "";
  }

  String? getTotalSiteArea() {
    double total = 0.0;
    if (opportunityList != null) {
      for (var element in opportunityList!) {
        if (element.siteArea != null) {
          double siteArea = double.tryParse(element.siteArea.toString()) ?? 0.0;

          total += siteArea;
        }
      }
    }
    return total.toString();
  }

  static List<LatLng> getAllLocations(List<OpportunityList> opportunityList) {
    List<LatLng> locations = [];

    for (OpportunityList location in opportunityList) {
      int maxLength = 0;
      if (location.coOrdinatesList != null) {
        maxLength = location.coOrdinatesList!.length > 100 ? 100 : location.coOrdinatesList!.length;
      }
      for (int i = 0; i < maxLength; i++) {
        double? xCoordinate = location.coOrdinatesList![i].xCoordinate;
        double? yCoordinate = location.coOrdinatesList![i].yCoordinate;
        if (xCoordinate != null && yCoordinate != null) {
          locations.add(LatLng(latitude: yCoordinate, longitude: xCoordinate));
        }
      }
    }
    return locations;
  }

  /* double getContractDuration() {
    return double.tryParse(contractDuration ?? "0") ?? 0.0;
  }*/

  double getContractYearsDuration() {
    return double.tryParse(contractDuration ?? "0") ?? 0.0;
  }

  double getContractMonthsDuration() {
    return double.tryParse(contractDurationMonths ?? "0") ?? 0.0;
  }

  String getContractDurationYearsAndMonth() {
    String contract = "";
    if (contractDuration != null && contractDuration!.isNotEmpty && contractDuration != "0") {
      contract += "$contractDuration ${("years").tr()}";
    }
    if (contractDurationMonths != null && contractDurationMonths!.isNotEmpty && contractDurationMonths != "0") {
      if (contract.isNotEmpty) contract += " ";
      contract += "$contractDurationMonths ${("months").tr()}";
    }

    return contract;
  }

  static List<ContractTemplate> getContractTemplate(
    List<ContractTemplate>? contractTemplate,
    List<ContractTemplate>? termsSpecDocument,
  ) {
    List<ContractTemplate> contractTemplateAndTerms = [];

    List<ContractTemplate> list1 = contractTemplate != null
        ? contractTemplate
              .where((element) => element.pxLinkedRefTo != null && element.pxLinkedRefTo!.isNotEmpty)
              .toList()
        : [];
    for (int i = 0; i < list1.length; i++) {
      ContractTemplate item = list1[i];
      if (i == 0) {
        item.pyMemo = ("contract_template").tr();
      } else {
        item.pyMemo = "${("contract_template").tr()}(${i.toString()})";
      }
      contractTemplateAndTerms.add(item);
    }

    List<ContractTemplate> list2 = termsSpecDocument != null
        ? termsSpecDocument
              .where((element) => element.pxLinkedRefTo != null && element.pxLinkedRefTo!.isNotEmpty)
              .toList()
        : [];

    for (int i = 0; i < list2.length; i++) {
      ContractTemplate item = list2[i];
      if (i == 0) {
        item.pyMemo = ("terms_template").tr();
      } else {
        item.pyMemo = "${("terms_template").tr()}(${i.toString()})";
      }
      contractTemplateAndTerms.add(item);
    }

    return contractTemplateAndTerms;
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

  String getEntityImage() {
    return getEntityOpportunity()
        ? getEntityImagePath(entityID)
        : (""
              "momra.png"); //MM
  }

  String? getOfferType() {
    if (offerType == "FinancialOffer") {
      return ("FinancialOffer").tr();
    } else if (offerType == "FinancialAndTechnical") {
      return ("FinancialAndTechnical").tr();
    }
    return null;
  }

  String? getBankWarrantyType() {
    if (bankWarrantyType == "Initial") {
      return ("Initial").tr();
    } else if (bankWarrantyType == "Initial and final") {
      return ("Initialandfinal").tr();
    }
    return null;
  }

  double? getAnnualContractValue() {
    return double.tryParse(annualContractValue ?? "");
  }
}

class ContractTemplate {
  ContractTemplate({this.pyCategory, this.pxLinkedRefTo, this.pxLinkedRefFrom, this.pyMemo});

  String? pyCategory;
  String? pxLinkedRefTo;
  String? pxLinkedRefFrom;
  String? pyMemo;

  factory ContractTemplate.fromJson(Map<String, dynamic> json) => ContractTemplate(
    pyCategory: json["pyCategory"],
    pxLinkedRefTo: json["pxLinkedRefTo"],
    pxLinkedRefFrom: json["pxLinkedRefFrom"],
    pyMemo: json["pyMemo"],
  );
}

class StatusDetail {
  StatusDetail({this.code, this.message});

  int? code;
  String? message;

  factory StatusDetail.fromJson(Map<String, dynamic> json) =>
      StatusDetail(code: json["code"], message: json["message"]);

  Map<String, dynamic> toJson() => {"code": code, "message": message};
}

class RequiredAttachmentCategoryList {
  RequiredAttachmentCategoryList({this.id, this.name, this.isMandatory});

  String? id;
  String? name;
  bool? isMandatory;

  factory RequiredAttachmentCategoryList.fromJson(Map<String, dynamic> json) =>
      RequiredAttachmentCategoryList(id: json["ID"], name: json["Name"], isMandatory: json["IsMandatory"]);
}

class OpportunityList {
  OpportunityList({
    this.sourceCaseKey,
    this.sourceCaseId,
    this.siteAddress,
    this.siteArea,
    this.street,
    this.siteNumber,
    this.coOrdinatesList,
    this.district,
    this.landNumber,
    this.orgSketchNumber,
  });

  String? sourceCaseKey;
  String? sourceCaseId;
  String? siteAddress;
  dynamic siteArea;
  String? street;
  String? siteNumber;
  List<CoOrdinatesList>? coOrdinatesList;
  String? district;
  String? landNumber;
  String? orgSketchNumber;

  factory OpportunityList.fromJson(Map<String, dynamic> json) => OpportunityList(
    sourceCaseKey: json["SourceCaseKey"],
    sourceCaseId: json["SourceCaseID"],
    siteAddress: json["SiteAddress"],
    siteArea: json["SiteArea"] ?? "0",
    street: json["Street"],
    siteNumber: json["SiteNumber"],
    coOrdinatesList: json["CoOrdinatesList"] == null
        ? null
        : List<CoOrdinatesList>.from(json["CoOrdinatesList"].map((x) => CoOrdinatesList.fromJson(x))),
    district: json["District"],
    landNumber: json["LandNumber"],
    orgSketchNumber: json["OrgSketchNumber"],
  );

  Map<String, dynamic> toJson() => {
    "SourceCaseKey": sourceCaseKey,
    "SourceCaseID": sourceCaseId,
    "SiteAddress": siteAddress,
    "SiteArea": siteArea,
    "Street": street,
    "SiteNumber": siteNumber,
    "CoOrdinatesList": coOrdinatesList == null ? null : List<dynamic>.from(coOrdinatesList!.map((x) => x.toJson())),
    "District": district,
    "LandNumber": landNumber,
    "OrgSketchNumber": orgSketchNumber,
  };

  String getArea() {
    if (siteArea != null) {
      return siteArea.toString();
    }
    return "";
  }
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

String getEntityImagePath(String? entityID) {
  return "https://furas.momra.gov.sa/images/entities/$entityID.png";
}

String getFormattedDateAndTimeV2(String dateStr) {
  String formmatedDateAndTime = "";

  try {
    DateTime? dateAndTime;

    if (dateStr.isNotEmpty) {
      String dateWithT = "${dateStr.substring(0, 15)}z";
      dateAndTime = DateTime.parse(dateWithT).toLocal();
    }

    String date = DateFormat.yMMMMd(CommonFunctions.isAppAR ? 'ar_SA' : 'en_US').format(dateAndTime!).toString();

    String time = DateFormat("h:mm a", CommonFunctions.isAppAR ? 'ar_SA' : 'en_US').format(dateAndTime).toString();
    if (CommonFunctions.isAppAR) {
      time = time.replaceAll("ص", ("am_full").tr()).replaceAll("م", ("pm_full").tr());
    }
    formmatedDateAndTime = "$date  |  $time";
  } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  if (CommonFunctions.isAppAR) {
    formmatedDateAndTime = CommonFunctions.replaceArabicNumberWithEnglish(formmatedDateAndTime);
  }
  return formmatedDateAndTime;
}
