import '/app/features/details/domain/entities/entity_activity_details_response.dart';

class EntityActivityDetailsResponseModel extends EntityActivityDetailsResponse {
  EntityActivityDetailsResponseModel(
      {super.about,
      super.sector,
      super.workerTypes,
      super.isicCode,
      super.isicName,
      super.totalActiveLicense,
      super.baladyWorkFlow,
      super.approvals,
      super.guide,
      super.licensePeriodMin,
      super.licensePeriodMax,
      super.isHotel,
      super.isAtm,
      super.isTobacco,
      super.minYears,
      super.maxYears,
      super.securityCamRegulations});

  factory EntityActivityDetailsResponseModel.fromJson(
      Map<String, dynamic> json) {
    return EntityActivityDetailsResponseModel(
        about: json["about"],
        sector: json["sector"] != null
            ? SectorModel.fromJson(json["sector"])
            : null,
        workerTypes: json["workerTypes"] != null
            ? List<SectorModel>.from(
                json["workerTypes"].map((x) => SectorModel.fromJson(x)))
            : null,
        isicCode: json["isicCode"],
        isicName: json["isicName"],
        totalActiveLicense: json["totalActiveLicense"],
        baladyWorkFlow: json["baladyWorkFlow"],
        approvals: json["approvals"] != null
            ? List<Approval>.from(
                json["approvals"].map((x) => Approval.fromJson(x)))
            : null,
        guide: json["guide"] != null
            ? List<GuideModel>.from(
                json["guide"].map((x) => GuideModel.fromJson(x)))
            : null,
        licensePeriodMin: json["licensePeriodMin"],
        licensePeriodMax: json["licensePeriodMax"],
        isHotel: json["isHotel"],
        isAtm: json["isAtm"],
        isTobacco: json["isTobacco"],
        minYears: json["minYears"],
        maxYears: json["maxYears"],
        securityCamRegulations: json["securityCamRegulations"]);
  }
}

class SectorModel extends Sector {
  SectorModel({
    super.id,
    super.name,
  });

  factory SectorModel.fromJson(Map<String, dynamic> json) => SectorModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class GuideModel extends Guide {
  GuideModel({
    super.nid,
    super.title,
    super.fieldDescriptionService,
    super.fieldFees,
    super.fieldFeesCalculator,
    super.fieldPaymentMethods,
    super.fieldTime,
    super.fieldPeriod,
    super.fieldServiceRank,
    super.fieldServiceId,
    super.fieldServiceTags,
    super.fieldSubTags,
    super.fieldTimeFrom,
    super.fieldTimeTo,
    super.fieldUserGuide,
    super.fieldViolationsAndFines,
    super.fieldImageService,
    super.fieldSla,
    super.fieldRequirementsDetails,
    super.fieldCost,
    super.fieldRequirements,
    super.fieldServiceUrl,
    super.fieldServiceReleaseDate,
    super.fieldServiceExternalUrl,
    super.fieldServiceInnerImage,
    super.fieldHowToApply,
    super.fieldServiceChanels,
    super.fieldServiceLanguage,
    super.fieldFineDetails,
    super.fieldServiceRequirements,
    super.fieldTargetCategories,
    super.fieldTargetCategoriesExport,
    super.fieldServiceChanelsExport,
    super.fieldMobileIcon,
    super.fieldPeriodExport,
  });

  factory GuideModel.fromJson(Map<String, dynamic> json) => GuideModel(
        nid: json["nid"],
        title: json["title"],
        fieldDescriptionService: json["field_description_service"],
        fieldFees: json["field_fees"],
        fieldFeesCalculator: json["field_fees_calculator"],
        fieldPaymentMethods: json["field_payment_methods"],
        fieldTime: json["field_time"],
        fieldPeriod: json["field_period"],
        fieldServiceRank: json["field_service_rank"],
        fieldServiceId: json["field_service_id"],
        fieldServiceTags: json["field_service_tags"],
        fieldSubTags: json["field_sub_tags"],
        fieldTimeFrom: json["field_time_from"],
        fieldTimeTo: json["field_time_to"],
        fieldUserGuide: json["field_user_guide"],
        fieldViolationsAndFines: json["field_violations_and_fines"],
        fieldImageService: json["field_image_service"],
        fieldSla: json["field_sla"],
        fieldRequirementsDetails: json["field_requirements_details"],
        fieldCost: json["field_cost"],
        fieldRequirements: json["field_requirements"],
        fieldServiceUrl: json["field_service_url"],
        fieldServiceReleaseDate: json["field_service_release_date"] != null
            ? DateTime.parse(json["field_service_release_date"])
            : null,
        fieldServiceExternalUrl: json["field_service_external_url"],
        fieldServiceInnerImage: json["field_service_inner_image"],
        fieldHowToApply: json["field_how_to_apply"],
        fieldServiceChanels: json["field_service_chanels"],
        fieldServiceLanguage: json["field_service_language"],
        fieldFineDetails: json["field_fine_details"],
        fieldServiceRequirements: json["field_service_requirements"],
        fieldTargetCategories: json["field_target_categories"],
        fieldTargetCategoriesExport: json["field_target_categories_export"] !=
                null
            ? List<FieldTargetCategoriesExportModel>.from(
                json["field_target_categories_export"]
                    .map((x) => FieldTargetCategoriesExportModel.fromJson(x)))
            : null,
        fieldServiceChanelsExport: json["field_service_chanels_export"] != null
            ? List<SectorModel>.from(json["field_service_chanels_export"]
                .map((x) => SectorModel.fromJson(x)))
            : null,
        fieldMobileIcon: json["field_mobile_icon"],
        fieldPeriodExport: json["field_period_export"],
      );
}

class FieldTargetCategoriesExportModel extends FieldTargetCategoriesExport {
  int? id;
  String? uid;
  String? title;
  String? created;

  FieldTargetCategoriesExportModel({
    super.id,
    super.uid,
    super.title,
    super.created,
  });

  FieldTargetCategoriesExportModel copyWith({
    int? id,
    String? uid,
    String? title,
    String? created,
  }) =>
      FieldTargetCategoriesExportModel(
        id: id ?? super.id,
        uid: uid ?? super.uid,
        title: title ?? super.title,
        created: created ?? super.created,
      );

  factory FieldTargetCategoriesExportModel.fromJson(
          Map<String, dynamic> json) =>
      FieldTargetCategoriesExportModel(
        id: json["id"],
        uid: json["uid"],
        title: json["title"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "title": title,
        "created": created,
      };
}
