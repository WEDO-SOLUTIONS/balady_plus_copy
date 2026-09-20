class ApiUrl {
  static const apiV1 = 'v1/';

  //! GET
  static const ssoUserInfo = '/connect/userinfo';
  static const ssoUserCookie = '/account/GetAuthCookies';
  static const apigeeToken = '/oauth/v1/token';
  static const forceUpdate = '/v1/force-update-apps/version';
  static const uploadFile = '/v1/dms-mobile/upload';
  static const uploadFileV2 = '/v2/dms-mobile/upload';
  //! New mini apps logic
  // static const getNewMiniApps = '/v2/balady-mini-apps/services';

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

  //! Agetns
  static const agents = '/v1/balady-dashboard/active/agencies';

  //! Dashboard
  static const dashboardCards =
      '/v1/balady-dashboard/balady-life-style/main-cards';

  static String dashboardCardProducts(int cardId) =>
      '/v1/balady-dashboard/balady-life-style/main-cards/$cardId/products';
  static const dashboardCardStatistics =
      '/v1/balady-dashboard/balady-life-style/statistics';

  //!Requests
  static const requests = '/v1/balady-dashboard/requests/my-requestes';
  static const requestStatuses = '/v1/balady-dashboard/requests/statuses';
  static const municipalities = '/v1/balady-dashboard/requests/municipalities';

  static String subMunicipalities(String id) =>
      '/v1/balady-dashboard/requests/sub-municipalities/$id';
  static const requestTypes = '/v1/balady-dashboard/requests/main-types';

  static String requestSubTypes(int id) =>
      '/v1/balady-dashboard/requests/sub-main-types/$id';

  //! Invoices
  static const invoices = '/v1/balady-dashboard/invoices/my-invoices';
  static const invoiceTypes = '/v1/balady-dashboard/invoices/main-types';

  static String invoiceSubTypes(int id) =>
      '/v1/balady-dashboard/invoices/sub-main-types/$id';
  static const invoiceStatuses = '/v1/balady-dashboard/invoices/statuses';
  static const invoiceDetails =
      '/v1/balady-dashboard/invoices/my-invoices-by-id';

  //! Licenses
  static const licenses = '/v1/balady-dashboard/license/my-licenses';
  static const licenseTypes = '/v1/balady-dashboard/license/main-types';

  static String licenseSubTypes(int id) =>
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

  static const ServiceQuestionList = 'v1/portal-services/faq';

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

  static const String IncidentRetrieveData =
      '/prweb/PRRestService/FrontUserBalady/V1/RetrieveData';

  static const String IncidentCreate =
      '/prweb/PRRestService/FrontUserBalady/V1/CreateIncidentRequest';

  ///! Daem

//! CRM

  static const String IncidentEvaluate =
      "/prweb/PRRestService/FrontUserBalady/V1/SubmitPetitionerEvaluation";

  static const requestDetails =
      'v1/damaged-vehicle-mobile/incident-request-details';

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
      '/v1/compliance-certificate-mobile-services/$requestId/upload-attahchment/$fileTypeId';

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

//! Posters Service

/////////////////////////////////////////////////////////
  static String getServicesCards(int servicesId) =>
      '/v1/portal-services/cards/$servicesId';

  // Ekram
  static const ekramRules =
      '/v1/iam-services/user-configuration/أنظمة بلدي/نظام إكرام الموتى';
  static const deathCities =
      'v1/superapp-ekram-services/lookup/DEATH_CITY/transport-cities';
  static const burialCities =
      'v1/superapp-ekram-services/lookup/BURIAL_CITY/transport-cities';
  static const ekramOrgnizations =
      'v2/ekram-mobile-services/organizations-info';

  static const ekramNationalities = 'v1/superapp-ekram-services/nationalities';

  static const ekramCities = 'v2/ekram-mobile-services/cities-cemetries';

  static String ekramHospitals(int cityId) =>
      'v1/superapp-ekram-services/lookup/$cityId/hospitals';

  //static const ekramLookup = 'v1/ekram-mobile-services/lookups';

  static const ekramAnotherLookup = 'v2/ekram-mobile-services/lookups';

  static const deceasedTransportRequests =
      'v1/superapp-ekram-services/deceased-transport-requests';

  static const deceasedTransportRequestDetails =
      'v2/ekram-mobile-services/deceased-transport-details';

  static const ekramDeceasedTransportApply =
      'v2/ekram-mobile-services/deceased-transport/add-request';

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

  static String ekramCountries = "v1/superapp-ekram-services/countries";

  static String graveActiveRequestDetails(String id, int idType) =>
      'v2/ekram-mobile-services/request-details/$id/$idType';

  static String ekramPrintCertificate =
      "v2/ekram-mobile-services/burial-licenses/verify-before-prints";

  static String validatePrintCertificate(String guid, String code) =>
      "v2/ekram-mobile-services/print-licenses/$guid/$code";

  static String baquieApproval =
      "v2/ekram-mobile-services/deaths/baqie-approvals";

  static String verifyDeceased = "v1/superapp-ekram-services/apply";
  static String specialTransportReasons =
      "v1/superapp-ekram-services/special-transport-reason";
  static String graveTypes = "v1/superapp-ekram-services/grave-types";
  static String prayers = "v1/superapp-ekram-services/prayers";

  static String transportCompanies(int requestId) =>
      "v1/superapp-ekram-services/transport/$requestId/charities";

  static String saveDeathBurialInfo(int requestId) =>
      "v1/superapp-ekram-services/transport/$requestId/save-death-burial-info";
  static String cemetries(int requestId) =>
      "v1/superapp-ekram-services/transport/$requestId/transport-request-cemeteries";
  static String ekramMosques(int requestId) =>
      'v1/superapp-ekram-services/mosques-ghusl-places/$requestId/MOSQUE';
  static String ekramLaundries(int requestId) =>
      'v1/superapp-ekram-services/mosques-ghusl-places/$requestId/GHUSL_PLACE';

  static String joodEskanGenerateDonation =
      "v1/joodeskan-services/generate-donation-url";
  static String joodEskanRegions = "v1/joodeskan-services/regions";

  static const paymentURL = 'v1/payment-gateway/payment';

  static const chatBot = 'v1/chatbot-services/chat'; // not use this now
  static const chatBotStream = 'v1/chatbot-services/chat-stream';
  static const chatBotEnabled = 'v1/chatbot-services/service-enabled';

  static const weatherAlerts = 'v1/mater-services/notifications/locations';

  //Construction License Inquery
  static String getConstructionLicenseData(int licenseNumber, String date) =>
      '/v1/balady-construction-services/mobile/inquiry/building-licenses/$licenseNumber/$date';

  //Noification APIS

  static String updateNotificationSettings() => '/v1/iam-services/ext/devices';

  //Survey license inquery
  static String getSurveyLicenseData(int licenseNumber, String date) =>
      '/v1/balady-construction-services/mobile/inquiry/area-reports/$licenseNumber/$date';

  //Noification APIS

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
  static const notificationsUnreadMessages =
      'v1/notifications-hub-services/fe/unread-messages';
  static const notificationsMessagesList =
      'v1/notifications-hub-services/fe/messages-list';
  static const notificationsMarkRead =
      'v1/notifications-hub-services/fe/messages/mark-read';
  static const notificationsDeletedMessages =
      'v1/notifications-hub-services/fe/deleted-messages';
  static const notificationsProducts =
      'v1/notifications-hub-services/fe/products';
  static const notificationsServices =
      'v1/notifications-hub-services/fe/services';
  static const notificationsSettingsList =
      'v1/notifications-hub-services/fe/profiles';
  static const setProductsNotificationsSettings =
      'v1/notifications-hub-services/fe/profile/products';
  static const setProfileNotificationsSettings =
      'v1/notifications-hub-services/fe/profiles';

//! Appointments New APIs
  static String getAppointmentById(String id) =>
      '/v1/appointments-mobile-services/appointments/$id';

  static const saveAppointment = "v1/appointments-mobile-services/appointments";

  static String validateRealEstate(String id) =>
      'v1/appointments-mobile-services/validate-real-estate/$id';

  static String deleteAppointment(String udid) =>
      "v1/mobile-appointment/appointmentsapi/attachments/$udid";

  //! POST

  //! Delete

  //! Patch

  static const getJoodShowStatus = 'v1/joodeskan-services/service-enabled';

  static const quranUrlDownload = 'BaladyCDN/Mobile/quran/quran.zip';

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
////// This related to commercial but using out commercial model need Split
  //! Delegators
  static const delegators =
      '/v1/delegation-services/delegated-commercial-records';

  static const String submitRating =
      '/v1/balady-commercial-services/rating/submit';
  static const commercialOffices =
      '/v1/balady-consultation-services/commercial-offices';
  static const validActivitiesAreasUrl =
      '/v1/balady-commercial-services/business-rules/valid-activities-areas';
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

//CRM APIgee

  static const String crmRequestsList = '/v1/crm-services/mobile/incidents';
  // '/prweb/PRRestService/FrontUserBalady/V1/GetIncidentRequests';

  static const String IncidentRequestDetails =
      '/v1/crm-services/mobile/fetch-incidents';
  //'/prweb/PRRestService/FrontUserBalady/V1/FetchIncidentRequest';

  static const String FetchMuncipalServiceRequest =
      '/v1/crm-services/mobile/fetch-municipalities';
// '/prweb/PRRestService/FrontUserBalady/V1/FetchMuncipalServiceRequest';

  static const String FetchInquiryRequest =
      '/v1/crm-services/mobile/fetch-inquiry';
// '/prweb/PRRestService/FrontUserBalady/V1/FetchInquiryRequest';

  static const String DaemRetrieveData =
      '/v1/crm-services/mobile/retrieve-tsr-data';
  // '/prweb/PRRestService/FrontUserBalady/V1/RetrieveTSRData';

  static const String DaemCreateTikcet =
      '/v1/crm-services/mobile/create-daem-ticket';
  //  '/prweb/PRRestService/FrontUserBalady/V1/CreateDaemTicket';

  static const String MSRRetrieveMSRData =
      '/v1/crm-services/mobile/retrieve-msr-data';
  // '/prweb/PRRestService/FrontUserBalady/V1/RetrieveMSRData';

  static const String MSRCreate =
      '/v1/crm-services/mobile/create-muncipal-service';
  //'/prweb/PRRestService/FrontUserBalady/V1/CreateMuncipalServiceRequest';

  static const String INQMainAndSubClassifications =
      '/v1/crm-services/mobile/main-and-sub-for-special-classification';
  //  '/prweb/PRRestService/FrontUserBalady/V1/GetMainAndSubClassificationsForSpecialClassification';

  static const String INQAllSPLClassifications =
      '/v1/crm-services/mobile/special-classifications-by-type';
  //'/prweb/PRRestService/FrontUserBalady/V1/GetSpecialClassificationsByType';

  static const String INQCreate = '/v1/crm-services/mobile/create-inquiry';
  // '/prweb/PRRestService/FrontUserBalady/V1/CreateInquiryRequest';

  static const String IncidentDaemUploadFile =
      '/v1/crm-services/mobile/stream/upload';
  // '/prweb/PRRestService/FrontUserBalady/V1/UploadFile';

  static const String IncidentDownloadFile =
      '/v1/crm-services/mobile/download-file';
  //  '/prweb/PRRestService/FrontUserBalady/V1/DownloadFile';

  ///////////// not used apis
  // static const String INQMainClassifications =
  //     '/prweb/PRRestService/FrontUserBalady/V1/GetMainClassifications';
  // static const String INQSubClassifications =
  //     '/prweb/PRRestService/FrontUserBalady/V1/GetSubClassifications';
  //
  // static const String INQSPLClassifications =
  //     '/prweb/PRRestService/FrontUserBalady/V1/GetSpecialClassifications';

  static String checkCommercialLicense(String licenseId) =>
      'v1/balady-commercial-mobile-services/license/exists/$licenseId';

  static const sendMessagechatBotFeedback =
      '/v1/chatbot-services/assign-feedback';
  static const getChatgptOldSession = '/v1/chatbot-services/old-sessions';
  static const getChatgptSessionDetails = '/v1/chatbot-services/view-session';

  static const refreshChatSession = '/v1/chatbot-services/load-session';
  static const promptQuestions = '/v1/chatbot-services/prompt-questions';
  static const promptQuestionsFollowUp =
      '/v1/chatbot-services/prompt-questions/follow-up';

//splash
  static const String splash = '/v1/portal-services/splash/images';

  static String getObserverStatus(String identityNumber) =>
      'v1/cis-certified-observers-services/registered-certified-observer-data/$identityNumber';
  static String getMuncipalitList =
      'v1/cis-certified-observers-services/municipalities';
  static String checkMuncipalityAcceptance(String id) =>
      'v1/cis-certified-observers-services/municipalities/$id/verifications';

  ///new EKRAM
  static String getIdenticalDeseasedList(String id) =>
      '/v1/superapp-ekram-services/transport/$id/identical-deceased-list';
  static String initializeTripsRquest(int requestId) =>
      'v1/superapp-ekram-services/trips/$requestId/initialize';
  static String GetTripstations(int requestId) =>
      'v1/superapp-ekram-services/trips/$requestId/trip-stations';
  static String EditTrip(int requestId, int tripId) =>
      'v1/superapp-ekram-services/trips/$requestId/$tripId/edit-trip';

  static String getMuncipalityCites(String municipalityId) =>
      'v1/cis-certified-observers-services/cities/$municipalityId';
  static String urlDistrictsList =
      'v1/cis-certified-observers-services/districts';

  static String registerObserver =
      'v2/cis-certified-observers-services/external-inspector/registration';
  static String registerNewFreelancer = 'v1/freelancer-services/register';
  static String createNewFreelancerCertificate =
      'v1/freelancer-services/certificate';
  static String freelancerCertificateStatus =
      'v1/freelancer-services/certificate-status';
  static String updateFreelancerCertificate =
      'v1/freelancer-services/update-certificate';
  static String getFreelancerCertificate =
      'v1/freelancer-services/user-certificates';
  static String addNewPath(int requestId) =>
      'v1/superapp-ekram-services/trips/$requestId/add-trip';
  static String ekramGetTrips(int requestId) =>
      'v1/superapp-ekram-services/trips/$requestId/trips';

  static String deleteTrip(int requestId, int tripId) =>
      'v1/superapp-ekram-services/trips/$requestId/$tripId/delete-trip';
  static String ghuslEmployees(int requestId) =>
      'v1/superapp-ekram-services/transport/$requestId/ghusl-employees';
  static String getDeceasedAttachment(int requestId) =>
      'v1/superapp-ekram-services/attachments/$requestId/request-attachments';
  static String uploadAttachment(int id) =>
      'v1/superapp-ekram-services/attachments/$id/upload-file';
  static String editAdditionalData(int id) =>
      'v1/superapp-ekram-services/transport/$id/edit-additional-data';
  static String completeTrip(int id) =>
      'v1/superapp-ekram-services/trips/$id/finalize';
  static String updateLocation(int id) =>
      'v1/superapp-ekram-services/transport/add-transport-track/$id';
  static String currentTrackLocation(int id) =>
      'v1/superapp-ekram-services/transport/current-track-location/$id';

  static String deleteAttachment(int requestId, int attachmentId) =>
      'v1/superapp-ekram-services/attachments/$attachmentId/delete';
  static String deceasedRequestDetails(String requestId) =>
      "v1/superapp-ekram-services/request/$requestId/request-details";
  static String saveDeceasdInfo(int requestId) =>
      "v1/superapp-ekram-services/transport/$requestId/save-deceased-info";
  static String ekramTransportValidateSubmit(int requestId) =>
      "v1/superapp-ekram-services/transport/$requestId/validate-and-submit";
  static String madinahEmirateApprovalStatus(
          int cemetryId, int id, int idType) =>
      "v1/superapp-ekram-services/cemetery/deceased-burial-cemetery-approval/$cemetryId/$id/$idType";

  static const getVolunteerProfile = 'v1/volunteer-platform-services/profiles';
  static const getSpecializations =
      'v1/volunteer-platform-services/lookups/specialization';
  static const getQualifications =
      'v1/volunteer-platform-services/lookups/qualifications';
  static const getLaunguages =
      'v1/volunteer-platform-services/lookups/languages';
  static const getFields =
      'v1/volunteer-platform-services/lookups/volunteering/fields';
  static const getBloodTypes =
      'v1/volunteer-platform-services/lookups/blood-type';
  static const getDiseases = 'v1/volunteer-platform-services/lookups/diseases';
  static const getSkills = 'v1/volunteer-platform-services/lookups/skills';
  static const getLvls =
      'v1/volunteer-platform-services/lookups/volunteering/levels';
  static const getInterests =
      'v1/volunteer-platform-services/lookups/interests';
  static const getVolunteeringFields =
      'v1/volunteer-platform-services/lookups/volunteering/fields';
  static const getVolunteeringServices =
      'v1/volunteer-platform-services/lookups/volunteering/fields';
  static const uploadVolunteerCV =
      'v1/volunteer-platform-services/upload/cv-files';

  static String submitVolunteerProfile(String profileId) =>
      'v1/volunteer-platform-services/profiles/$profileId';

  static const getRegions = 'v1/volunteer-platform-services/lookups/region';
  static const getcities = 'v1/volunteer-platform-services/lookups/city';
  static const volunteerCardStatistics = '/v1/volunteer-platform-services/statistics';
}
