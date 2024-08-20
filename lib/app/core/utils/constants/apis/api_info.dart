import '../../common_functions.dart';

class ApiUrl {
  static const apiV1 = 'v1/';

  //! GET
  static const ssoUserInfo = '/connect/userinfo';
  static const ssoUserCookie = '/account/GetAuthCookies';
  static const apigeeToken = '/oauth/v1/token';
  static const forceUpdate = '/v1/force-update-apps/version';
  static const uploadFile = '/v1/dms-mobile/upload';
  static const uploadFileV2 = '/v2/dms-mobile/upload';

  //! Services
  //! Public Services
  //! Prayer Times
  static const prayerTimes = '/v1/kacst/prayer-times';
  static const prayerTimesRange = '/v1/kacst/prayer-times-range';

  //! Municipal Services
  //! Municipal Advisor
  static const isicActivities =
      '/v1/balady-consultation-services/approved-isic-activities';
  static const isicSubActivities =
      '/v1/balady-consultation-services/activities-by-isicNumber';
  static const additionalActivities =
      '/v1/balady-consultation-services/additional-activities';
  static const additionalActivity =
      '/v1/balady-consultation-services/additional-activity';
  static const activityDetails =
      '/v1/balady-consultation-services/activity-detail-info';
  static const accommodationTypes =
      '/v1/balady-consultation-services/accommodation-types';
  static const consultationKey = '/v1/balady-consultation-services/apply';
  static const issuingPredefinedConditions =
      '/v1/balady-consultation-services/predefined-conditions?typeId=ISSUING';
  static const licensePermits =
      '/v1/balady-consultation-services/license-permits';
  static const supervisingAuthorities =
      '/v1/balady-consultation-services/supervising-authorities';
  static const civilDefensePredefinedConditions =
      '/v1/balady-consultation-services/predefined-conditions?typeId=CIVIL_DEFENSE';
  static String civilDefense = '/v1/balady-consultation-services/civil-defense';
  static const commercialOffices =
      '/v1/balady-consultation-services/commercial-offices';
  static const engineeringOffices =
      '/v1/balady-consultation-services/eng-offices';
  static const cleaningMechanisms = '/v1/balady-consultation-services/cleaning';
  static const saveConsultationProgress =
      '/v1/balady-consultation-services/site';
  static const saveActivities =
      '/v1/balady-consultation-services/additional-activity';
  static const licenseYears = '/v1/balady-consultation-services/license-years';
  static const boardTypes = '/v1/balady-consultation-services/board-types';
  static const calculateFees =
      '/v1/balady-consultation-services/calculate-fees';
  static const saveFinancialStudy =
      '/v1/balady-consultation-services/financial-study-info';
  static const shopOwnership =
      '/v1/balady-consultation-services/shop-ownership';
  static const consultationAttachments =
      '/v1/balady-consultation-services/consultation-attachments';
  static const interactiveInfo =
      '/v1/balady-consultation-services/interactive-info';
  static const conditionsUrls = '/v1/balady-consultation-services/conditions';
  static const fastflowConditions =
      '/v1/balady-consultation-services/fastflow-conditions';
  static const maxLicenseYears = '/v1/balady-consultation-services/max-years';
  static const requestFlow = '/v1/balady-consultation-services/request-flow';
  static const requestFlowRecommendations =
      '/v1/balady-consultation-services/flow-recommendations';
  static const updatePermit =
      '/v1/balady-consultation-services/updated-permit-cost';
  static const submitConsultation = '/v1/balady-consultation-services/submit';

  static const buildingCompliance = '/v1/crm/gis/building-compliance-details';
  static const complianceSendOTP = '/v1/utility-services/otp/send';
  static const complianceVerify = '/v1/utility-services/otp/verify';

  static const gisImageUrl = '/v1/gis-services/image-url';

  static const validActivitiesAreasUrl =
      '/v1/balady-commercial-services/business-rules/valid-activities-areas';

  //! Profile
  //! Delegators
  static const delegators =
      '/v1/delegation-services/delegated-commercial-records';

  //! Agetns
  static const agents = '/v1/balady-dashboard/active/agencies';

  //! Dashboard
  static const dashboardCards =
      '/v1/balady-dashboard/balady-life-style/main-cards';
  static dashboardCardProducts(int cardId) =>
      '/v1/balady-dashboard/balady-life-style/main-cards/$cardId/products';
  static const dashboardCardStatistics =
      '/v1/balady-dashboard/balady-life-style/statistics';
  //!Requests
  static const requests = '/v1/balady-dashboard/requests/my-requestes';
  static const requestStatuses = '/v1/balady-dashboard/requests/statuses';
  static const municipalities = '/v1/balady-dashboard/requests/municipalities';
  static subMunicipalities(String id) =>
      '/v1/balady-dashboard/requests/sub-municipalities/$id';
  static const requestTypes = '/v1/balady-dashboard/requests/main-types';
  static requestSubTypes(int id) =>
      '/v1/balady-dashboard/requests/sub-main-types/$id';
  //! Invoices
  static const invoices = '/v1/balady-dashboard/invoices/my-invoices';
  static const invoiceTypes = '/v1/balady-dashboard/invoices/main-types';
  static invoiceSubTypes(int id) =>
      '/v1/balady-dashboard/invoices/sub-main-types/$id';
  static const invoiceStatuses = '/v1/balady-dashboard/invoices/statuses';
  static const invoiceDetails =
      '/v1/balady-dashboard/invoices/my-invoices-by-id';

  //! Licenses
  static const licenses = '/v1/balady-dashboard/license/my-licenses';
  static const licenseTypes = '/v1/balady-dashboard/license/main-types';
  static licenseSubTypes(int id) =>
      '/v1/balady-dashboard/license/sub-main-types/$id';
  static const licenseStatuses = '/v1/balady-dashboard/license/statuses';

//! Objections

  static const objectionsRequests = '/v1/balady-dashboard/objection-requests';
  static const applicationsLookUp =
      '/v1/objection-generic-services/applications';
  static String servicesByApplicationId(String id) =>
      '/v1/objection-generic-services/applications/$id/services';
  static const objectionsRequestStatus =
      '/v1/balady-dashboard/objection-requests/lookup-status';

  static const transactionsRequests =
      '/v1/balady-dashboard/objectable-requests';

  static const postObjection =
      '/v2/objection-services/submit-objection-requests';

  static const objectionRequestDetails =
      '/v1/objection-services/objection-details';

  static String transactionsRequestDetails(String id) =>
      '/v1/objection-generic-services/applications/$id/objectable-transactions';

  static String cancelObjectionRequest =
      '/v1/objection-services/objection-request';

  static String validateObjectionSubmit(
          String applicationId, String transactionId) =>
      '/v1/objection-generic-services/applications/$applicationId/transactions/$transactionId/validate';

  static String objectionPermitUrl(String transactionId) =>
      '/v1/balady-dashboard/permit-detail-url-transaction-number/$transactionId';

  static String objectionEnquiryDetails(String enquiryId) =>
      '/v1/objection-services/feedbacks/$enquiryId';

  static String createEnquiryDetails = '/v1/objection-services/feedbacks';

//! VD
  static const gis = '/v1/crm/bcg/gis-info';
  static const vdCategories = '/v1/crm/bcg/categories';
  static const vdSpecialClassifications = '/v1/crm/bcg/special-classifications';

  static const vdSpecialClassificationDetails =
      '/v1/crm/bcg/special-classification-details';

  static const vdUploadFile = '/v1/crm/upload/bcg/upload-file';

  static const getOTP = '/v1/crm/bcg/otp';

  static const createIncidentRegistered =
      '/v1/crm/bcg/registered-user/incident';
  static const createIncidentUnRegistered =
      '/v1/crm/bcg/unregistered-user/incident';

  static const vdCategoriesRegistered =
      '/v1/crm/bcg/registered-user/categories';

  static const vdCrExists = '/v1/crm/cr-exists/';

//! DC

//! Damaged Cars
  static const dcCarTypes = 'v1/damaged-vehicle-mobile/car-companies';

  static const dcCarModel = 'v1/damaged-vehicle-mobile/car-models';

  static const veichleRecoveryNotes =
      'v1/damaged-vehicle-mobile/vehicle-recovery-notes';

  static const vehicles = 'v1/damaged-vehicle-mobile/vehicles';
  static const vehicleRecovery = 'v1/damaged-vehicle-mobile/vehicle-recovery';
//Weather
  static const weatherForcastAPI = '/v1/weather-services/forecast';

// Pega Incdients

  static const String IncidentDownloadFile =
      '/prweb/PRRestService/FrontUserBalady/V1/DownloadFile';

  static const String IncidentRetrieveData =
      '/prweb/PRRestService/FrontUserBalady/V1/RetrieveData';

  static const String IncidentCreate =
      '/prweb/PRRestService/FrontUserBalady/V1/CreateIncidentRequest';

  static const String IncidentUploadFile =
      '/prweb/PRRestService/FrontUserBalady/V1/UploadFile';

  static const String MSRCreate =
      '/prweb/PRRestService/FrontUserBalady/V1/CreateMuncipalServiceRequest';

  static const String MSRRetrieveMSRData =
      '/prweb/PRRestService/FrontUserBalady/V1/RetrieveMSRData';

  static const String INQMainClassifications =
      '/prweb/PRRestService/FrontUserBalady/V1/GetMainClassifications';
  static const String INQSubClassifications =
      '/prweb/PRRestService/FrontUserBalady/V1/GetSubClassifications';

  static const String INQSPLClassifications =
      '/prweb/PRRestService/FrontUserBalady/V1/GetSpecialClassifications';

  static const String INQAllSPLClassifications =
      '/prweb/PRRestService/FrontUserBalady/V1/GetSpecialClassificationsByType';

  static const String INQMainAndSubClassifications =
      '/prweb/PRRestService/FrontUserBalady/V1/GetMainAndSubClassificationsForSpecialClassification';

  static const String INQCreate =
      '/prweb/PRRestService/FrontUserBalady/V1/CreateInquiryRequest';

  ///! Daem

  static const String DaemRetrieveData =
      '/prweb/PRRestService/FrontUserBalady/V1/RetrieveTSRData';
  static const String DaemCreateTikcet =
      '/prweb/PRRestService/FrontUserBalady/V1/CreateDaemTicket';
  static const String DaemUploadFile =
      '/prweb/PRRestService/FrontUserBalady/V1/UploadFile';

//! CRM

  static const String crmRequestsList =
      '/prweb/PRRestService/FrontUserBalady/V1/GetIncidentRequests';
  static const String IncidentRequestDetails =
      '/prweb/PRRestService/FrontUserBalady/V1/FetchIncidentRequest';

  static const String MSRRequestDetails =
      '/prweb/PRRestService/FrontUserBalady/V1/FetchMuncipalServiceRequest';

  static const String IncidentEvaluate =
      "/prweb/PRRestService/FrontUserBalady/V1/SubmitPetitionerEvaluation";

  static const String FetchInquiryRequest =
      '/prweb/PRRestService/FrontUserBalady/V1/FetchInquiryRequest';

  static const requestDetails =
      'v1/damaged-vehicle-mobile/incident-request-details';
  // CR
  static String recordInfo({required String crNumber, required String role}) =>
      'v1/balady-commercial-services/mci/record-Info/$crNumber/$role/1004';
  static const String subActivities =
      "/v1/balady-commercial-services/salama/activities/isicCode/1004";
  static const String subActivityDetails =
      "/v1/balady-commercial-services/activities/";
  static const String addIsicActivities =
      "/v1/balady-commercial-services/isic-activities/add-cr";
  static const String accommodationTypesCL =
      "/v1/balady-commercial-services/accommodation-types";

  static const String saveComSubmitterAndOwner =
      "v1/balady-commercial-services/new-request/submitter-owner-details";

  static String saveActivityDetails(int requestId) =>
      "v1/balady-commercial-services/new-request/$requestId/activity-details";

  static String saveLocationDetails(int requestId) =>
      "v1/balady-commercial-services/new-request/$requestId/location-details";

  static String investmentContracts(int requestId) =>
      "v1/balady-commercial-services/gsb/$requestId/investment-contracts";

  static String cleanContracts(int requestId) =>
      "v1/balady-commercial-services/gsb/$requestId/clean-contracts";

  static String ejarInfo = "v1/balady-commercial-services/ejar/tenancycontract";

  static String deedInfoOwnwerShip(
          {required int requestId, required String type}) =>
      "v1/balady-commercial-services/moj/$requestId/deed-info/$type";

  static String deedInfo() => "v1/balady-commercial-services/gsb/deed-info";

  static String crIssueAttachments(int requestId) =>
      "v1/balady-commercial-services/request/$requestId/attachments";

  static String crAttachment(int requestId, String fileTypeId) =>
      '/v1/balady-commercial-services/request/$requestId/attachments/$fileTypeId';

  static String crCalculateFess(int requestId) =>
      '/v1/balady-commercial-services/new-request/$requestId/calculate-fees';

  static String addBeneficiaryNotes(int requestId) =>
      'v1/balady-commercial-services/new-request/$requestId/add-beneficiary-notes';

  static String crSubmit(int requestId) =>
      'v1/balady-commercial-services/new-request/${requestId}/submits';

  static String saveShopDetails(int requestId) =>
      'v1/balady-commercial-services/new-request/$requestId/shop-details';

  static String ComercialLicenseTransferShopInfo(int requestId) =>
      'v1/superapp-commercial-ownership-services/transfer/shop-ownership-info/$requestId';

  static String validateApprovals(int requestId) =>
      'v1/balady-commercial-services/validate-approvals/request/$requestId';

  static String deedOptions(int requestId) =>
      'v1/balady-commercial-services/deed-owner-ship-options/$requestId';

  static String cleanOptions(int requestId) =>
      'v1/balady-commercial-services/clean-options/request/$requestId';

  static String getCredences(int requestId) =>
      'v1/balady-commercial-services/credence/request/$requestId';

  static String uploadCredences(int requestId, String fileTypeId) =>
      '/v1/balady-commercial-services/upload-credence/request/$requestId/$fileTypeId';

  static String validateSalamaAttachmentsInfo(int requestId) =>
      'v1/balady-commercial-services/validate-salama-attachments-info/$requestId';

  static String fawrySalamaBills(int requestId) =>
      'v1/balady-commercial-services/new-request/$requestId/fawry-salama-bills';

  static String fawrySalamaReports(int requestId) =>
      'v1/balady-commercial-services/new-request/$requestId/fawry-salama-reports';

  static String applyCommercialRequest(int requestId) =>
      'v1/balady-commercial-services/commercial-flow/applies/$requestId';

  static String getQrCodeDetails(int requestId) =>
      'v1/balady-commercial-services/qr-code-details/$requestId';

  static String saveQrEnterpriseData(int requestId) =>
      'v1/balady-commercial-services/enterprise-data/$requestId';

  static String saveQrWorkTimesData(int requestId) =>
      'v1/balady-commercial-services/work-times/$requestId';

  static String saveAddetionalQrData(int requestId) =>
      'v1/balady-commercial-services/additional/qr-code-details/$requestId';

  static String qrAttachments(int requestId) =>
      "v1/balady-commercial-services/qr-attachemnts/$requestId";

  static String qrUploadAttachments(int requestId, String fileTypeId) =>
      '/v1/balady-commercial-services/upload-qr-attachemnts/$requestId/$fileTypeId';

  static String qrSubmit(int requestId) =>
      'v1/balady-commercial-services/qr-submits/$requestId';

  static String qrLookUp(String params) =>
      'v1/balady-commercial-services/qr-lookups/$params';

  static String addetionalActivites(String params) =>
      'v1/balady-commercial-services/additional-activities/$params';

  static String addetionalDetailsActivity(
          String subActivity, String addetioanlActivityId) =>
      'v1/balady-commercial-services/new-request/additional/activities/$subActivity/$addetioanlActivityId';

  static String mallsList(String params) =>
      'v1/balady-commercial-services/malls?districtId=$params';

  static String validateSalamaReport(int requestId, String number) =>
      'v1/balady-commercial-services/request/$requestId/validate-salama-report/$number';

  static String validateSalamaBill(int requestId, String number) =>
      'v1/balady-commercial-services/request/$requestId/validate-salama-bill/$number';

  static String validateSalamaPermit(int requestId) =>
      '/v1/balady-commercial-services/validate-salama-permits/$requestId';

  static String salamaWarningMessage =
      '/v1/balady-commercial-services/salama-workflow-warnings';

  static String salamaWarningWorkFlowMessage =
      '/v1/balady-commercial-services/activities-salama-workflows';

  static String boardContracts(int requestId) =>
      '/v1/balady-commercial-services/board-contracts/$requestId';

  static String crCitizenInfo =
      '/v1/balady-commercial-services/moi/citizeninfo';

  static String requestDetailsCommercial(int requestId) =>
      "/v1/balady-commercial-services/request/$requestId";

  static String requestConclusionCommercial(int requestId) =>
      "/v1/balady-commercial-services/request-conclusion/$requestId";
//! Renew Commercial Service
  static String validateBeforeApply(int requestId) =>
      'v1/balady-commercial-services/mobile/renew-request/validate-before-apply/$requestId';

  static String renewApply(int requestId) =>
      'v1/balady-commercial-services/mobile/renew-request/apply/$requestId';

  static String renewYears(int requestId) =>
      'v1/balady-commercial-services/mobile/renew-request/$requestId/renew-years';

  static String calculateRequestInfo(int requestId) =>
      'v1/balady-commercial-services/mobile/renew-request/$requestId/calculate-request-info';

  static String saveRenewRequestInfo(int requestId) =>
      'v1/balady-commercial-services/mobile/renew-request/$requestId/request-info';

  static String renewAttachments(int requestId) =>
      'v1/balady-commercial-services/mobile/renew-request/$requestId/attachments';

  static String saveAttachments(int requestId) =>
      'v1/balady-commercial-services/mobile/renew-request/$requestId/save-attachments';

  static String uploadAttachments(int requestId, String fileTypeId) =>
      '/v1/balady-commercial-services/mobile/renew-request/request/$requestId/attachments/$fileTypeId';

  static String renewSubmit(int requestId) =>
      '/v1/balady-commercial-services/mobile/renew-request/$requestId/submit';

  static String renewRequestDetails(int requestId) =>
      '/v1/balady-commercial-services/mobile/renew-request/$requestId/request-details';

//! Violations
  static const String violationsStatus =
      "/v1/balady-dashboard/violations/statuses";
  static const String invoiceStatus =
      "/v1/balady-dashboard/violations/invoice-statuses";
  static const String violations =
      "/v1/balady-dashboard/violations/my-violations";
  static const String violationDetails =
      "/v1/balady-dashboard/violations/by-id";

// ! Investment Fura
  static const String DOWNLOAD_FILE_URL = '/v1/ims/download-file';

  // ! Create Compliance
  static const String applyBeneficiaryCompliance =
      '/v2/compliance-certificate-mobile-services/apply-beneficiary';
  static const String getComplianceRequestById =
      '/v1/compliance-certificate-mobile-services/certificate/';

  static const String saveLocationCompliance =
      '/v1/compliance-certificate-mobile-services/save-location-info/';

  static const String saveContractCompliance =
      '/v1/compliance-certificate-mobile-services/save-contract-info/';

  static const String saveComplianceCertificateItems =
      '/v1/compliance-certificate-mobile-services/save-compliance-certificate-items/';

  static String saveComplianceCertificateItem(int requestId) =>
      "/v1/compliance-certificate-mobile-services/requests/$requestId/compliance-clauses";

  static String validateComplianceCertificate(int requestId) =>
      "/v1/compliance-certificate-mobile-services/requests/$requestId/compliance-clauses/validate";

  static String cancelComplianceCertificate(int requestId) =>
      "/v1/compliance-certificate-mobile-services/requests/$requestId";

  static String uploadComplianceAttachment(int requestId) =>
      "/v1/compliance-certificate-mobile-services/requests/$requestId/files/upload";
  static const String submitComplianceRequest =
      '/v1/compliance-certificate-mobile-services/submit-request/';
  static const String deleteComplianceRequest =
      '/v1/compliance-certificate-mobile-services/request/';
  static const String complicanecOwnershioDocType =
      '/v1/compliance-certificate-mobile-services/ownership-doc-type';

  static String complianceMyLicenses(
          {required String id, required String type}) =>
      '/v1/compliance-certificate-mobile-services/my-licenses/$id/$type';

  static const String complianceMainUsage =
      '/v1/compliance-certificate-mobile-services/lookup/main-usage';

  static String complianceSubUsage(int mainId) =>
      '/v1/compliance-certificate-mobile-services/lookup/sub-buliding/$mainId';

  static const String complianceEngOffices =
      '/v1/compliance-certificate-mobile-services/eng-offices';

  static String complinaceEngOfficesDetails(String id) =>
      '/v1/compliance-certificate-mobile-services/eng-offices/$id';

  static const String complianceGIS =
      '/v1/gis-services/compliance-certificates/point-data';
  static String complianceAttachment(String requestId, String fileTypeId) =>
      '/v1/compliance-certificate-mobile-services/${requestId}/upload-attahchment/${fileTypeId}';

  static String downLoadBuildingLicense(String id) =>
      '/v1/compliance-certificate-mobile-services/download-request-files/$id';

  static const String etmamProfileEntity =
      '/v1/etmamplus-platform-services/search-profiles';

  static const String complianceReciptTypes =
      '/v1/compliance-certificate-mobile-services/receipt-types';

  static const String complianceDeedInfo =
      '/v1/compliance-certificate-mobile-services/deed-info';

  static const String complianceLandContract =
      '/v1/compliance-certificate-mobile-services/land-subsidy-contracts';

  static const String complainceAppointments =
      'v1/compliance-certificate-mobile-services/visit-appointments';


// ! Events

  static const eventsSearch = '/v1/balady-events-services/events/search';
  static const eventsDetails = '/v1/balady-events-services/events';
  static const eventsCategory = '/v1/balady-events-services/category/';

  static const calendarSearch = '/v1/saudi-calendar-services/entries/search';
  static const calendarDetails = '/v1/saudi-calendar-services/entries';

// ! Events
  static const regulationClauses =
      '/v1/momtathel-mobile-services/regulation-clauses';

  static const establishmentSizes =
      '/v1/momtathel-mobile-services/establishment/sizes';

  static const violationsClassifications =
      '/v1/momtathel-mobile-services/classifications';

  static const violatorLookups =
      '/v1/momtathel-mobile-services/violator/lookups';

  static const regulationClauseDetails =
      '/v1/momtathel-mobile-services/regulation-clause/details';

// -------  Commercial License Details ---------
  static String getCommercialLicenseDetails(int licenseId) =>
      '/v1/balady-commercial-services/licenses/$licenseId';
  static String commercialLicensePermits(int licenseId) =>
      '/v1/balady-commercial-services/licenses/permits/$licenseId';
  static String getLicenseAttachments(int licenseId) =>
      '/v1/balady-commercial-services/license-attachments/$licenseId';

// -------  Commercial License Cancel ---------
  static String getCommercialLicenseAllowedActions(int licenseId) =>
      '/v1/balady-commercial-services/licenses/$licenseId/allowed-actions';
/////////////////////////////////////////////////////////
  static const String commercialLicenseCancellationReasons =
      '/v1/balady-commercial-services/mobile/cancel-reasons';
  // static  String commercialLicenseApplyCancel(int licenseId) => '/v1/balady-commercial-services/mobile/cancel-request/apply/$licenseId';
  static String commercialLicenseApplyCancel(int licenseId) =>
      '/v1/balady-commercial-services/mobile/cancel-request/apply/$licenseId';
  static String commercialLicenseCancelAttachments(int licenseId) =>
      '/v1/balady-commercial-services/mobile/cancel-request/$licenseId/attachments';
  static String commercialLicenseCancelUploadAttachments(
          int requestId, int attachTypeId) =>
      '/v1/balady-commercial-services/mobile/cancel-request/request/$requestId/attachments/$attachTypeId';
  static String commercialLicenseCancelSaveCancellationReason(int requestId) =>
      '/v1/balady-commercial-services/mobile/save-cancellation-reason/$requestId';
  static String commercialLicenseCancelCalculateFees(int requestId) =>
      '/v1/balady-commercial-services/mobile-cancel-request/$requestId/calculateFees';
  static String commercialLicenseCancelSubmit(int requestId) =>
      '/v1/balady-commercial-services/mobile/cancel-request/$requestId/submit';
/////////////////////////////////////////////////////////
  static String getAllowedActionsForRequests(int requestId) =>
      '/v1/balady-commercial-services/mobile/request/allowed-actions/$requestId';
  static String getRequestCommercialLicenseDetails(int requestId) =>
      '/v1/balady-commercial-services/mobile/request/details/$requestId';
/////////////////////////////////////////////////////////
  static String commercialLicenseIsDirectToPay(int requestId) =>
      '/v1/balady-commercial-services/mobile-cancel-request/request/$requestId/is-direct-to-pay';
  static const String commercialLicenseCancelSubmitRating =
      '/v1/balady-commercial-services/rating/submit';
  static String commercialLicenseCancelGetDetailsRequest(int requestId) =>
      '/v1/balady-commercial-services/mobile-cancel-request/request-details/$requestId';
/////////////////////////////////////////////////////////
  static const String getUserFacilities =
      '/v1/tobacco-services/user-facilities';
  static const String getTobaccoDisclosure = '/v1/tobacco-services/disclosures';
  static const String getTobaccoDisclosureUploadFile =
      '/v1/tobacco-services/stream/upload';
  static const String getTobaccoDisclosureUpload =
      '/v1/tobacco-services/disclosures/upload';

//! Posters Service

  static String getLicensesForPermits(
          {required String crNumber, required String groupId}) =>
      "/v1/commercial-promotions-services/licenses/$crNumber/$groupId";

  static String getGroupsItems =
      "v1/commercial-promotions-services/group-services";

  static String savePoster(String requestId) =>
      "v1/commercial-promotions-services/posters/$requestId";

/////////////////////////////////////////////////////////
  static String getServicesCards(int servicesId) =>
      '/v1/portal-services/cards/$servicesId';

  static String getPermitAttachmentTypes(
          {required int requestId, required int typeId}) =>
      "v1/commercial-promotions-services/attachments-types/$requestId/$typeId";

  static String getPermitPosterTypes =
      "v1/commercial-promotions-services/poster-types";

  static String applyPermitGroupLicense =
      "v1/commercial-promotions-services/group-apply";

  static String permitUploadAttachment(int requestId, int fileTypeId) =>
      '/v1/commercial-promotions-services/stream/upload-attachments/$requestId/$fileTypeId';
  static String postersSubmit(int requestId) =>
      "v1/commercial-promotions-services/submits/$requestId";

  static String addIndivisualRequests(int requestId) =>
      "v1/commercial-promotions-services/group-requests/$requestId";

  static String postersRequestDetails(int requestId) =>
      "v1/commercial-promotions-services/requests-details/$requestId";

  static String deleteLicenseFromPermit(int requestId, int licenseId) =>
      "v1/commercial-promotions-services/requests-group/$requestId/$licenseId";

  static String deletePermitRequest(int requestId) =>
      "v1/commercial-promotions-services/requests/$requestId";

  static String postersAlerts =
      "v1/commercial-promotions-services/alerts/ALERTS";

  static String applyLicense(int? licenseId) =>
      "v1/commercial-promotions-services/apply/$licenseId";

  static String posterRequestAlllowedAction(int? requestId) =>
      "v1/commercial-promotions-services/allowed-actions/$requestId";

  //! 24 Hour Permit
  static String permit24AlllowedAction(int? requestId) =>
      "v1/supperapp-commercial-twentyfour-services/twenty-four-allowed-actions/$requestId";

  static String permits24Alerts(String type) =>
      "v1/supperapp-commercial-twentyfour-services/alerts/$type";
  static String permit24ValidateBeforeApply(int? requestId) =>
      "v1/supperapp-commercial-twentyfour-services/valid-before-apply/$requestId";

  static String permit24Submit(int requestId) =>
      "v1/supperapp-commercial-twentyfour-services/submits/$requestId";

  static String permit24RequestDetails(int requestId) =>
      "v1/supperapp-commercial-twentyfour-services/permit-details/$requestId";

  static String permit24Calclaute(int requestId) =>
      "v1/supperapp-commercial-twentyfour-services/licences-costs/$requestId";
  static String deletePermit24Request(int requestId) =>
      "v1/supperapp-commercial-twentyfour-services/requests/$requestId";

//! Tobacco Permit

  static String permitTobaccoAlllowedAction(int? requestId) =>
      "v1/supperapp-commercial-tobbaco-permission-services/tobbaco-allowed-actions/$requestId";

  static String permitsTobaccoAlerts =
      "v1/supperapp-commercial-tobbaco-permission-services/alerts/ALERTS";
  static String permitTobaccoValidateBeforeApply(int? licenseId) =>
      "v1/supperapp-commercial-tobbaco-permission-services/valid-before-apply/$licenseId";

  static String permitTobaccoSubmit(int licenseId) =>
      "v1/supperapp-commercial-tobbaco-permission-services/submits/$licenseId";

  static String permitTobaccoRequestDetails(int requestId) =>
      "v1/supperapp-commercial-tobbaco-permission-services/permit-details/$requestId";

  static String permitTobaccoCalclaute(int licenseId) =>
      "v1/supperapp-commercial-tobbaco-permission-services/licences-costs/$licenseId";
  static String deletePermitTobaccoRequest(int requestId) =>
      "v1/supperapp-commercial-tobbaco-permission-services/requests/$requestId";

  static String PermitTobaccoValidateHotelLicense(int license, int hotel) =>
      "v1/supperapp-commercial-tobbaco-permission-services/validate-hotel-license/$license/$hotel";

// Ekram
  static const ekramRules =
      '/v1/iam-services/user-configuration/أنظمة بلدي/نظام إكرام الموتى';
  static const deathCities = 'v2/ekram-mobile-services/cities/1';
  static const burialCities = 'v2/ekram-mobile-services/cities/2';
  static const ekramOrgnizations =
      'v2/ekram-mobile-services/organizations-info';

  static const ekramNationalities = 'v2/ekram-mobile-services/nationalities';

  static const ekramCities = 'v2/ekram-mobile-services/cities-cemetries';

  static const ekramHospitals = 'v2/ekram-mobile-services/citiy-hospitals';

  static const ekramMosques =
      'v2/ekram-mobile-services/mosques-ghusl-places/{}/MOSQUE';

  static const ekramLaundries =
      'v2/ekram-mobile-services/mosques-ghusl-places/{}/GHUSL_PLACE';

  //static const ekramLookup = 'v1/ekram-mobile-services/lookups';

  static const ekramAnotherLookup = 'v2/ekram-mobile-services/lookups';

  static const deceasedTransportRequests =
      'v2/ekram-mobile-services/deceased-transport-requests';

  static const deceasedTransportRequestDetails =
      'v2/ekram-mobile-services/deceased-transport-details';

  static const ekramDeceasedTransportApply =
      'v2/ekram-mobile-services/deceased-transport/add-request';

  static const ekramGetTrips = 'v2/ekram-mobile-services/trips';

  static const applyTrip = 'v2/ekram-mobile-services/apply-trip-steps';

  static const deleteTrip = 'v2/ekram-mobile-services/delete-trips';

  static const completeTrip =
      'v2/ekram-mobile-services/complete-deceased-transports';

  static const uploadLetter =
      'v2/ekram-mobile-services/deceased-transport/update-attachments';

  static const updateLocation = 'v2/ekram-mobile-services/add-trip-locations';

  static const tripLocations = 'v2/ekram-mobile-services/trip-locations';

  static const ekramRequestStatus = 'v2/ekram-mobile-services/transport-status';

  static const ekramLocations = 'v2/ekram-mobile-services/transport-locations';

  static const ekramAttachments =
      'v1/ekram-mobile-services/download-attachments';

  static const residentInfo = 'v1/ekram-mobile-services/check-deceased-info';

  static const ekramActiveCities = 'v2/ekram-mobile-services/cities-cemetries';

  static const ekramCemetries = 'v2/ekram-mobile-services/lookups/cemetries';

  static const bookCemetryRequests =
      'v2/ekram-mobile-services/beneficiary/requests';
  static const bookCemetry = 'v2/ekram-mobile-services/submit-grave-requests';

  static const bookCemetryDetails =
      'v2/ekram-mobile-services/beneficiary/{}/details';

  static const ekramFindCemetries = 'v2/ekram-mobile-services/find-cemeteries';
  static const ekramFindGraves =
      'v2/ekram-mobile-services/find-grave-locations';
  static const ekramNewCities = 'v2/ekram-mobile-services/city-lists';
  static String ekramDistricts(int cityId) =>
      'v2/ekram-mobile-services/districts-of-city/$cityId';

  static String ekramCharity(int cityId) =>
      'v2/ekram-mobile-services/charity-org/list-of-org/$cityId';

  static String ekramIdentityTypes = 'v2/ekram-mobile-services/identity-types';

  static String ekramCountries = "v2/ekram-mobile-services/countries";

  static String graveActiveRequestDetails(String id, int idType) =>
      'v2/ekram-mobile-services/request-details/$id/$idType';

  static String ekramPrintCertificate =
      "v2/ekram-mobile-services/burial-licenses/verify-before-prints";

  static String validatePrintCertificate(String guid, String code) =>
      "v2/ekram-mobile-services/print-licenses/$guid/$code";

  static String baquieApproval =
      "v2/ekram-mobile-services/deaths/baqie-approvals";

  static String joodEskanGenerateDonation =
      "v1/joodeskan-services/generate-donation-url";
  static String joodEskanRegions = "v1/joodeskan-services/regions";

  static const paymentURL = 'v1/payment-gateway/payment';

  static const chatBot = 'v1/chatbot-services/chat'; // not use this now
  static const chatBotStream = 'v1/chatbot-services/chat-stream';
  static const chatBotEnabled = 'v1/chatbot-services/service-enabled';


  static const String submitRating =
      '/v1/balady-commercial-services/rating/submit';

  static const weatherAlerts = 'v1/mater-services/notifications/locations';

//commercial license query
  static String getCommercialLicenseData(
          int licenseNumber, unifiedFacilityNumber) =>
      '/v1/balady-commercial-services/licenses/$licenseNumber/by-unn/$unifiedFacilityNumber';

  //Construction License Inquery
  static String getConstructionLicenseData(int licenseNumber, String date) =>
      '/v1/balady-construction-services/mobile/inquiry/building-licenses/$licenseNumber/$date';

  //Noification APIS

  static String updateNotificationSettings() => '/v1/iam-services/ext/devices';

  //Survey license inquery
  static String getSurveyLicenseData(int licenseNumber, String date) =>
      '/v1/balady-construction-services/mobile/inquiry/area-reports/$licenseNumber/$date';
  //Noification APIS

//! commercial ownership services

  static String getOwnershipCommercialRequestDetails(int requestId) =>
      '/v1/superapp-commercial-ownership-services/request/$requestId';

  static String acceptCommercialRequestTransfer(int requestId) =>
      '/v1/superapp-commercial-ownership-services/transfer/accept/by-new-owner/$requestId';

  static String rejectCommercialRequestTransfer(int requestId) =>
      '/v1/superapp-commercial-ownership-services/transfer/reject/by-new-owner/$requestId';

  static String getRequestPermits(int requestId) =>
      '/v1/superapp-commercial-ownership-services/transfer/selected/permits/$requestId';
  static String saveSelectedRequestPermits(int requestId) =>
      '/v1/superapp-commercial-ownership-services/transfer/selected-permits/by-new-owner/$requestId';
  static String transferShopInfo(int requestId) =>
      '/v1/superapp-commercial-ownership-services/transfer/shop-info/$requestId';

  static String submitApprovel(int requestId) =>
      '/v1/superapp-commercial-ownership-services/transfer/submit/by-new-owner/$requestId';


  static String transferRequestAttachments(int requestId) =>
      '/v1/superapp-commercial-ownership-services/transfer/attachments/$requestId';
  static String transferUploadAttachments(int requestId) =>
      '}/v1/superapp-commercial-ownership-services/transfer/upload-attachment/2/attachments/$requestId';

  static String getLicensePermits(String licenseNumber) =>
      '/v1/superapp-commercial-ownership-services/license/permits/$licenseNumber';

  static String validateNewOwner(String licenseNumber, String crNumber) =>
      '/v1/superapp-commercial-ownership-services/transfer/validate-new-owner/$licenseNumber?crNumber=$crNumber';

  static String validateLicenseTrnasfer(String licenseNumber) =>
      "/v1/superapp-commercial-ownership-services/transfer/validate-license/$licenseNumber";

  static String sendToNewOwner(String licenseNumber) =>
      "/v1/superapp-commercial-ownership-services/transfer/send-to-new-owner/$licenseNumber";

  //! Balady Calednar

  static const baladyCalendarFilter =
      'v1/balady-calendar-services/main-filterations';

  static const baladyCalendarEventsCountInYears =
      'v1/balady-calendar-services/events/count-in-year';

  static const baladyCalendarEventsCountInMonths =
      'v1/balady-calendar-services/events/count-in-months-by-year';

  static const baladyCalendarEvents =
      'v1/balady-calendar-services/events/by-year';






  //! Notifications
  static const notificationsUnreadMessages = 'v1/notifications-hub-services/fe/unread-messages';
  static const notificationsMessagesList = 'v1/notifications-hub-services/fe/messages-list';
  static const notificationsMarkRead = 'v1/notifications-hub-services/fe/messages/mark-read';
  static const notificationsDeletedMessages = 'v1/notifications-hub-services/fe/deleted-messages';
  static const notificationsProducts = 'v1/notifications-hub-services/fe/products';
  static const notificationsServices = 'v1/notifications-hub-services/fe/services';
  static const notificationsSettingsList = 'v1/notifications-hub-services/fe/profiles';
  static const setProductsNotificationsSettings = 'v1/notifications-hub-services/fe/profile/products';
  static const setProfileNotificationsSettings = 'v1/notifications-hub-services/fe/profiles';
//! Appointments New APIs
  static getAppointmentById(String id) =>
      'v1/appointments-mobile-services/appointments/$id';

  static const saveAppointment = "v1/appointments-mobile-services/appointments";
  static validateRealEstate(String id) =>
      'v1/appointments-mobile-services/validate-real-estate/$id';

  static  deleteAppointment (String udid)=> "v1/mobile-appointment/appointmentsapi/attachments/$udid";



  //! POST

  //! Delete

  //! Patch

  static const getJoodShowStatus = 'v1/joodeskan-services/service-enabled';



  static String commercialLicenseOwnershipServicesUploadAttachments(
      int requestId, int attachTypeId) =>
      'v1/superapp-commercial-ownership-services/transfer/upload-attachment/$attachTypeId/attachments/$requestId';


  static  getDebts ({required String transactionType, required int transactionId}) => 'v1/debt-collection-services/mobile/debts/$transactionType/$transactionId';





  static const quranUrlDownload = 'BaladyCDN/Mobile/quran/quran.zip';


}

/// It has any header which used inside any API
// class ApiHeader {
//   static const requiresToken = "requiresToken";
//   static const language = "Accept-Language";
//   static const verifyingKEY = "verifyingKEY";
// }

/// It has any params which used inside any API
/*class ApiParam {
  static const phoneNumber = 'phoneNumber';
  static const username = 'userName';
  static const password = 'password';
  static const email = 'Email';
  static const refreshToken = 'refreshToken';
  static const mimeType = '{extension}';

  // General
  static const cityId = "cityId";
  static const pageSize = "pageSize";
  static const pageIndex = "pageIndex";
  static const pageNo = "pageNo";
  static const page_No = "page-no";
  static const page_Size = "page-size";
  static const profileId = "profileId";
  static const maxCount = "maxCount";
  static const name = "name";
  static const typeId = "typeId";
  static const langId = "langId";
  static const sort = "sort";
  static const desc = "desc";
  static const asc = "asc";

// Search API
  static const text = "text";

  // My Orders
  static const closed = "closed";
  static const hasPendingCancelRequest = "has-pending-cancel-request";

// Force Update
  static const appID = "appID";
  static const type = "type";

// Main-Service API

// Notifications
  static const id = "id";
  static const notificationToken = "notificationToken";
  static const os = "os";

  // game
  static const gameCategory = 'category';
  static const gameProvider = 'provider';
  static const gameSort = 'sort';
  static const gamePageSize = 'page_size';
  static const gamePageNumber = 'page_number';
  static const gameCoupon = 'coupon';
  static const gameTaskName = 'task_name';
}
*/
