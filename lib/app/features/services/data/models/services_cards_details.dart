class ServicesCardsDetails {
  String nid;
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
  String? fieldServiceReleaseDate;
  String? fieldServiceExternalUrl;
  String? fieldServiceInnerImage;
  String? fieldHowToApply;
  String? fieldServiceChanels;
  String? fieldServiceLanguage;
  String? fieldFineDetails;
  String? fieldServiceRequirements;
  String? fieldTargetCategories;
  List<ServiceChanelExport>? fieldServiceChanelsExport;

  ServicesCardsDetails({
    required this.nid,
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
    this.fieldServiceChanelsExport,
  });

  factory ServicesCardsDetails.fromJson(Map<String, dynamic> json) =>
      ServicesCardsDetails(
        nid: json['nid'],
        title: json['title'],
        fieldDescriptionService: json['field_description_service'],
        fieldFees: json['field_fees'],
        fieldFeesCalculator: json['field_fees_calculator'],
        fieldPaymentMethods: json['field_payment_methods'],
        fieldTime: json['field_time'],
        fieldPeriod: json['field_period'],
        fieldServiceRank: json['field_service_rank'],
        fieldServiceId: json['field_service_id'],
        fieldServiceTags: json['field_service_tags'],
        fieldSubTags: json['field_sub_tags'],
        fieldTimeFrom: json['field_time_from'],
        fieldTimeTo: json['field_time_to'],
        fieldUserGuide: json['field_user_guide'],
        fieldViolationsAndFines: json['field_violations_and_fines'],
        fieldImageService: json['field_image_service'],
        fieldSla: json['field_sla'],
        fieldRequirementsDetails: json['field_requirements_details'],
        fieldCost: json['field_cost'],
        fieldRequirements: json['field_requirements'],
        fieldServiceUrl: json['field_service_url'],
        fieldServiceReleaseDate: json['field_service_release_date'],
        fieldServiceExternalUrl: json['field_service_external_url'],
        fieldServiceInnerImage: json['field_service_inner_image'],
        fieldHowToApply: json['field_how_to_apply'],
        fieldServiceChanels: json['field_service_chanels'],
        fieldServiceLanguage: json['field_service_language'],
        fieldFineDetails: json['field_fine_details'],
        fieldServiceRequirements: json['field_service_requirements'],
        fieldTargetCategories: json['field_target_categories'],
        fieldServiceChanelsExport: json['field_service_chanels_export'] != null
            ? List<ServiceChanelExport>.from(
                    json['field_service_chanels_export'].map(
                        (element) => ServiceChanelExport.fromJson(element)))
                .toList()
            : null,
      );
}

class ServiceChanelExport {
  int id;
  String name;

  ServiceChanelExport({required this.id, required this.name});

  factory ServiceChanelExport.fromJson(Map<String, dynamic> json) =>
      ServiceChanelExport(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );
}
