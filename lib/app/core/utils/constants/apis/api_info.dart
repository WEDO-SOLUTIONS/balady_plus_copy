import '../../common_functions.dart';

class ApiUrl {
  static const apiV1 = 'v1/';

  //! GET
  static const ssoUserInfo = '/connect/userinfo';
  static const ssoUserCookie = '/account/GetAuthCookies';
  static const apigeeToken = '/oauth/v1/token';
  static const forceUpdate = '/v1/force-update-apps/version';
  static const uploadFile = '/v1/dms-mobile/upload';

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
  static const consultationKey = '/v2/balady-consultation-services/apply';
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

  //! Profile
  //! Delegators
  static const delegators =
      '/v1/delegation-services/delegated-commercial-records';
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
      '/v1/objection-services/submit-objection-requests';

  static const objectionRequestDetails =
      '/v1/objection-services/objection-details';

  static String transactionsRequestDetails(String id) =>
      '/v1/objection-generic-services/applications/$id/objectable-transactions';

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
  static const String recordInfo =
      'v1/balady-commercial-services/mci/record-Info/crNumber/DELEGATOR/1004';
  static const String subActivities =
      "/v1/balady-commercial-services/activities/by-isic/details/isicCode/1004";
  static const String subActivityDetails =
      "/v1/balady-commercial-services/activities/";
  static const String addIsicActivities =
      "/v1/balady-commercial-services/isic-activities/add-cr";
  static const String accommodationTypesCL =
      "/v1/balady-commercial-services/accommodation-types";

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

  //! POST

  //! Delete

  //! Patch
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
