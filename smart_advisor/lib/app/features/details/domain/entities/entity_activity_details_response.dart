class EntityActivityDetailsResponse {
  String? about;
  Sector? sector;
  List<Sector>? workerTypes;
  String? isicCode;
  String? isicName;
  int? totalActiveLicense;
  String? baladyWorkFlow;
  List<Approval>? approvals;
  List<Guide>? guide;

  int? licensePeriodMin;
  int? licensePeriodMax;
  bool? isHotel;
  bool? isAtm;
  bool? isTobacco;
  int? minYears;
  int? maxYears;
  String? securityCamRegulations;

  EntityActivityDetailsResponse(
      {this.about,
      this.sector,
      this.workerTypes,
      this.isicCode,
      this.isicName,
      this.totalActiveLicense,
      this.baladyWorkFlow,
      this.approvals,
      this.guide,
      this.licensePeriodMin,
      this.licensePeriodMax,
      this.isHotel,
      this.isAtm,
      this.isTobacco,
      this.minYears,
      this.maxYears,
      this.securityCamRegulations});

  EntityActivityDetailsResponse copyWith(
          {String? about,
          Sector? sector,
          List<Sector>? workerTypes,
          String? isicCode,
          String? isicName,
          int? totalActiveLicense,
          String? baladyWorkFlow,
          List<Approval>? approvals,
          List<Guide>? guide,
          int? licensePeriodMin,
          int? licensePeriodMax,
          bool? isHotel,
          bool? isAtm,
          bool? isTobacco,
          int? minYears,
          int? maxYears,
          String? securityCamRegulations}) =>
      EntityActivityDetailsResponse(
          about: about ?? this.about,
          sector: sector ?? this.sector,
          workerTypes: workerTypes ?? this.workerTypes,
          isicCode: isicCode ?? this.isicCode,
          isicName: isicName ?? this.isicName,
          totalActiveLicense: totalActiveLicense ?? this.totalActiveLicense,
          baladyWorkFlow: baladyWorkFlow ?? this.baladyWorkFlow,
          approvals: approvals ?? this.approvals,
          guide: guide ?? this.guide,
          licensePeriodMin: licensePeriodMin ?? this.licensePeriodMin,
          licensePeriodMax: licensePeriodMax ?? this.licensePeriodMax,
          isHotel: isHotel ?? this.isHotel,
          isAtm: isAtm ?? this.isAtm,
          isTobacco: isTobacco ?? this.isTobacco,
          minYears: minYears ?? this.minYears,
          maxYears: maxYears ?? this.maxYears,
          securityCamRegulations:
              securityCamRegulations ?? this.securityCamRegulations);
}

class Sector {
  int? id;
  String? name;

  Sector({
    this.id,
    this.name,
  });

  Sector copyWith({
    int? id,
    String? name,
  }) =>
      Sector(
        id: id ?? this.id,
        name: name ?? this.name,
      );
}

class Guide {
  String? nid;
  String? title;
  String? fieldDescriptionService;
  String? fieldFees;
  String? fieldFeesCalculator;
  String? fieldPaymentMethods;
  String? fieldTime;
  String? fieldPeriod;
  String? fieldServiceRank;
  String? fieldServiceId;
  String? fieldServiceTags;
  String? fieldSubTags;
  String? fieldTimeFrom;
  String? fieldTimeTo;
  String? fieldUserGuide;
  String? fieldViolationsAndFines;
  String? fieldImageService;
  String? fieldSla;
  String? fieldRequirementsDetails;
  String? fieldCost;
  String? fieldRequirements;
  String? fieldServiceUrl;
  DateTime? fieldServiceReleaseDate;
  String? fieldServiceExternalUrl;
  String? fieldServiceInnerImage;
  String? fieldHowToApply;
  String? fieldServiceChanels;
  String? fieldServiceLanguage;
  String? fieldFineDetails;
  String? fieldServiceRequirements;
  String? fieldTargetCategories;
  List<FieldTargetCategoriesExport>? fieldTargetCategoriesExport;
  List<Sector>? fieldServiceChanelsExport;
  String? fieldMobileIcon;
  String? fieldPeriodExport;

  Guide({
    this.nid,
    this.title,
    this.fieldDescriptionService,
    this.fieldFees,
    this.fieldFeesCalculator,
    this.fieldPaymentMethods,
    this.fieldTime,
    this.fieldPeriod,
    this.fieldServiceRank,
    this.fieldServiceId,
    this.fieldServiceTags,
    this.fieldSubTags,
    this.fieldTimeFrom,
    this.fieldTimeTo,
    this.fieldUserGuide,
    this.fieldViolationsAndFines,
    this.fieldImageService,
    this.fieldSla,
    this.fieldRequirementsDetails,
    this.fieldCost,
    this.fieldRequirements,
    this.fieldServiceUrl,
    this.fieldServiceReleaseDate,
    this.fieldServiceExternalUrl,
    this.fieldServiceInnerImage,
    this.fieldHowToApply,
    this.fieldServiceChanels,
    this.fieldServiceLanguage,
    this.fieldFineDetails,
    this.fieldServiceRequirements,
    this.fieldTargetCategories,
    this.fieldTargetCategoriesExport,
    this.fieldServiceChanelsExport,
    this.fieldMobileIcon,
    this.fieldPeriodExport,
  });

  Guide copyWith({
    String? nid,
    String? title,
    String? fieldDescriptionService,
    String? fieldFees,
    String? fieldFeesCalculator,
    String? fieldPaymentMethods,
    String? fieldTime,
    String? fieldPeriod,
    String? fieldServiceRank,
    String? fieldServiceId,
    String? fieldServiceTags,
    String? fieldSubTags,
    String? fieldTimeFrom,
    String? fieldTimeTo,
    String? fieldUserGuide,
    String? fieldViolationsAndFines,
    String? fieldImageService,
    String? fieldSla,
    String? fieldRequirementsDetails,
    String? fieldCost,
    String? fieldRequirements,
    String? fieldServiceUrl,
    DateTime? fieldServiceReleaseDate,
    String? fieldServiceExternalUrl,
    String? fieldServiceInnerImage,
    String? fieldHowToApply,
    String? fieldServiceChanels,
    String? fieldServiceLanguage,
    String? fieldFineDetails,
    String? fieldServiceRequirements,
    String? fieldTargetCategories,
    List<FieldTargetCategoriesExport>? fieldTargetCategoriesExport,
    List<Sector>? fieldServiceChanelsExport,
    String? fieldMobileIcon,
    String? fieldPeriodExport,
  }) =>
      Guide(
        nid: nid ?? this.nid,
        title: title ?? this.title,
        fieldDescriptionService:
            fieldDescriptionService ?? this.fieldDescriptionService,
        fieldFees: fieldFees ?? this.fieldFees,
        fieldFeesCalculator: fieldFeesCalculator ?? this.fieldFeesCalculator,
        fieldPaymentMethods: fieldPaymentMethods ?? this.fieldPaymentMethods,
        fieldTime: fieldTime ?? this.fieldTime,
        fieldPeriod: fieldPeriod ?? this.fieldPeriod,
        fieldServiceRank: fieldServiceRank ?? this.fieldServiceRank,
        fieldServiceId: fieldServiceId ?? this.fieldServiceId,
        fieldServiceTags: fieldServiceTags ?? this.fieldServiceTags,
        fieldSubTags: fieldSubTags ?? this.fieldSubTags,
        fieldTimeFrom: fieldTimeFrom ?? this.fieldTimeFrom,
        fieldTimeTo: fieldTimeTo ?? this.fieldTimeTo,
        fieldUserGuide: fieldUserGuide ?? this.fieldUserGuide,
        fieldViolationsAndFines:
            fieldViolationsAndFines ?? this.fieldViolationsAndFines,
        fieldImageService: fieldImageService ?? this.fieldImageService,
        fieldSla: fieldSla ?? this.fieldSla,
        fieldRequirementsDetails:
            fieldRequirementsDetails ?? this.fieldRequirementsDetails,
        fieldCost: fieldCost ?? this.fieldCost,
        fieldRequirements: fieldRequirements ?? this.fieldRequirements,
        fieldServiceUrl: fieldServiceUrl ?? this.fieldServiceUrl,
        fieldServiceReleaseDate:
            fieldServiceReleaseDate ?? this.fieldServiceReleaseDate,
        fieldServiceExternalUrl:
            fieldServiceExternalUrl ?? this.fieldServiceExternalUrl,
        fieldServiceInnerImage:
            fieldServiceInnerImage ?? this.fieldServiceInnerImage,
        fieldHowToApply: fieldHowToApply ?? this.fieldHowToApply,
        fieldServiceChanels: fieldServiceChanels ?? this.fieldServiceChanels,
        fieldServiceLanguage: fieldServiceLanguage ?? this.fieldServiceLanguage,
        fieldFineDetails: fieldFineDetails ?? this.fieldFineDetails,
        fieldServiceRequirements:
            fieldServiceRequirements ?? this.fieldServiceRequirements,
        fieldTargetCategories:
            fieldTargetCategories ?? this.fieldTargetCategories,
        fieldTargetCategoriesExport:
            fieldTargetCategoriesExport ?? this.fieldTargetCategoriesExport,
        fieldServiceChanelsExport:
            fieldServiceChanelsExport ?? this.fieldServiceChanelsExport,
        fieldMobileIcon: fieldMobileIcon ?? this.fieldMobileIcon,
        fieldPeriodExport: fieldPeriodExport ?? this.fieldPeriodExport,
      );
}

class FieldTargetCategoriesExport {
  int? id;
  String? uid;
  String? title;
  String? created;

  FieldTargetCategoriesExport({
    this.id,
    this.uid,
    this.title,
    this.created,
  });

  FieldTargetCategoriesExport copyWith({
    int? id,
    String? uid,
    String? title,
    String? created,
  }) =>
      FieldTargetCategoriesExport(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        title: title ?? this.title,
        created: created ?? this.created,
      );
}

class Approval {
  final int? id;
  final ApprovalType? approvalType;
  final dynamic supervisingAuthorityName;

  Approval({
    this.id,
    this.approvalType,
    this.supervisingAuthorityName,
  });

  Approval copyWith({
    int? id,
    ApprovalType? approvalType,
    dynamic supervisingAuthorityName,
  }) =>
      Approval(
        id: id ?? this.id,
        approvalType: approvalType ?? this.approvalType,
        supervisingAuthorityName:
            supervisingAuthorityName ?? this.supervisingAuthorityName,
      );

  factory Approval.fromJson(Map<String, dynamic> json) => Approval(
        id: json["id"],
        approvalType: json["approvalType"] == null
            ? null
            : ApprovalType.fromJson(json["approvalType"]),
        supervisingAuthorityName: json["supervisingAuthorityName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "approvalType": approvalType?.toJson(),
        "supervisingAuthorityName": supervisingAuthorityName,
      };
}

class ApprovalType {
  final int? id;
  final String? name;

  ApprovalType({
    this.id,
    this.name,
  });

  ApprovalType copyWith({
    int? id,
    String? name,
  }) =>
      ApprovalType(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory ApprovalType.fromJson(Map<String, dynamic> json) => ApprovalType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
