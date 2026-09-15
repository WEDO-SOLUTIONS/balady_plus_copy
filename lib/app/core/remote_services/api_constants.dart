// ignore_for_file: constant_identifier_names

class ApiConstants {
  // Qr Code
  static const String QrURL = '/v1/qr-code';
  static const String QrDetailsUrl = '$QrURL/qr-license-detail/';
  static const String QrLicenseRatingItemsUrl = '$QrURL/license-rating-items';
  static const String QrLicenseUserLatesetRatingItemsUrl = '$QrURL/lates-user-rating/';
  static const String QrPostRating = '$QrURL/add-license-rating/';

  // Pega Incdients
  static const String IncidentsUrl = '/prweb/PRRestService/FrontUserBalady/V1';
  static const String GuestIncidentsUrl = '/prweb/PRRestService/CRMBasicAuth/V1';

  static const String IncidentList = '$IncidentsUrl/GetIncidentRequests';
  static const String incidentRequestDetails = '$IncidentsUrl/FetchIncidentRequest';
  static const String incidentDownloadFile = '$IncidentsUrl/DownloadFile';

  static const String incidentRetrieveData = '/RetrieveData';

  static const String IncidentGetParksList = '/RetrieveParksData';

  static const String IncidentPrimaryZone = '/RetrieveZoneData';
  static const String IncidentUploadFile = '/UploadFile';
  static const String incidentCreate = '/CreateIncidentRequest';
  static const String mSRCreate = '/CreateMuncipalServiceRequest';
  static const String MSRRequestDetails = '$IncidentsUrl/FetchMuncipalServiceRequest';

  static const String mSRRetrieveMSRData = '$IncidentsUrl/RetrieveMSRData';

  static const String INQMainClassifications = '$IncidentsUrl/GetMainClassifications';
  static const String INQSubClassifications = '$IncidentsUrl/GetSubClassifications';

  static const String INQSPLClassifications = '$IncidentsUrl/GetSpecialClassifications';

  static const String iNQAllSPLClassifications = '$IncidentsUrl/GetSpecialClassificationsByType';

  static const String iNQMainAndSubClassifications =
      '$IncidentsUrl/GetMainAndSubClassificationsForSpecialClassification';

  static const String iNQCreate = '/CreateInquiryRequest';

  static const String incidentEvaluate = "$IncidentsUrl/SubmitPetitionerEvaluation";

  static const String fetchInquiryRequest = '$IncidentsUrl/FetchInquiryRequest';

  // Daem

  static const String daemRetrieveData = '$IncidentsUrl/RetrieveTSRData';
  static const String daemCreateTikcet = '$IncidentsUrl/CreateDaemTicket';
  static const String DaemUploadFile = '$IncidentsUrl/UploadFile';

  // Visits

  static const String VisitRetrieveData = '/v1/rased/retrieve-data';
  static const String VisitCreate = '/v1/rased/create-visit';
  static const String VisitUpload = '/v1/rased/upload-file';
  static const String VisitUpdate = '/v1/rased/update-visit';
  static const String reportedVisits = '/v1/rased/reported-visits';
  static const String reportedVisitDetails = '/v1/rased/retrieve-visit-request';
  static const String visitdownloadFile = '/v1/rased/download-file';
  static const String visitUserAuthorization = '/v1/rased/user-validation';

  // GIS

  static const String GisGetLocation = '/v1/gis-tawakkalna-services/address';

  // Health Certificate
  static const String HelathCertificatesURL = '/v1/mobile-health-certificates';
  static const String ValidateHelathCertificatesRequest = '$HelathCertificatesURL/validate-before-apply-new-request';
  static const String ApplyHelathCertificatesRequest = '$HelathCertificatesURL/apply-new-request';

  static const String ValidateRenewHelathCertificatesRequest =
      '$HelathCertificatesURL/validate-before-apply-renew-request';
  static const String ApplyRenewHelathCertificatesRequest = '$HelathCertificatesURL/apply-renew-request';

  static const String CancelHelathCertificatesRequest = '$HelathCertificatesURL/apply-cancel-request';

  static const String SubmitNewRequest = '$HelathCertificatesURL/submit-new-request/';

  static const String SubmitRenewRequest = '$HelathCertificatesURL/submit-renew-request/';

  static const String MyHealthRequests = '$HelathCertificatesURL/my-requests/';

  static const String MyHealthLicenses = '$HelathCertificatesURL/my-licenses/HIMSELF/';

  static const String healthRequestDetails = '$HelathCertificatesURL/request-detail-by-id/';

  static const String deleteRequest = '$HelathCertificatesURL/delete-request/';

  static const String downLoadAttachments = '/v1/attachment/';
  static const String downLoadLicense = '$HelathCertificatesURL/print-url/';

  static const String downLoadCanceledLicense = '$HelathCertificatesURL/print-cancel-certificate/';

  static const String downLoadHealthCertificateImageProfile = '$HelathCertificatesURL/client-photo/';

  static const String healthCertificatesCities = '$HelathCertificatesURL/baladia/{}/cities';

  static const String healthCertificatesCenters = '$HelathCertificatesURL/health-centers/';

  static String updatedPersonalPhoto(int requestId) => '/v2/mobile-health-certificates/personal/$requestId/photo';

  static String sendOTPCertificate(String requestId) => '/v2/mobile-health-certificates/certificate/$requestId/send';

  static String verifyOTPCertificate(String requestId) =>
      '/v2/mobile-health-certificates/certificate/$requestId/verify';

  static String updateCertificatePhoto = '/v2/mobile-health-certificates/update-photo';

  static String healthTerms = '/v2/mobile-health-certificates/terms';
  static String locationInfo = '/v2/mobile-health-certificates/location-info';

  // Cr Info Service
  static const String CrInfoService = '$HelathCertificatesURL/cr-info/';

  // License Info Service

  static String licenseInfoService(String type, String licenseNo) =>
      '/v2/mobile-health-certificates/certificate-info/$type/$licenseNo';

  // Service Rating Info URL
  static const String RatingInfo = '$HelathCertificatesURL/ratings/';

  // Appointment
  static const String AppointmentURL = '/v1/mobile-appointment';
  static const String NewAppointmentURL = '/v1/appointments-mobile-services';

  static const String AppointmentMunicipalities = '$NewAppointmentURL/municipalities';
  static String appointmentSubMunicipalities(String id) => '$NewAppointmentURL/municipalities/$id/sub-municipalities';
  static const String AppointmentDepartments = '$AppointmentURL/department-list/';

  static String appointmentMainClasssifications(String id) => '$NewAppointmentURL/services/main-classes/$id';
  static String appointmentSubClasssifications(String subMunicipalityId, String mainClassId) =>
      '$NewAppointmentURL/services/sub-classes/$subMunicipalityId/$mainClassId';

  static const String MyAppointments = '$NewAppointmentURL/my-appointments';
  static const String AppointmentDetails = '$AppointmentURL/appointment-by-id/';
  static const String PrintAppointmentDetails = '$AppointmentURL/print-appointment/';
  static const String CancelAppointment = '$AppointmentURL/cancel-appointment/';
  static String confirmAppointment(String uuid) => '$NewAppointmentURL/appointments/confirm/$uuid';

  //   static  String ConfirmAppointmentNewAppointment(String uuid) =>
  // '$NewAppointmentURL/appointments/confirm/$uuid';

  static const String AppointmentAvailableDates = '$AppointmentURL/available-dates/';
  static const String AppointmentAvailableTimes = '$AppointmentURL/available-times/';
  static const String AppointmentLookUpList = '$AppointmentURL/lookup-list/';
  static String appointmentServiceConfig(String subMunicipalityId, String subClassId) =>
      '$NewAppointmentURL/services/config/$subMunicipalityId/$subClassId';
  static const String AppointmentSave = '$AppointmentURL/save-appointment';
  static String appointmentUpdate(int id) => '/v1/appointments-mobile-services/appoinments/$id';

  static String appointmentUploadFile(int typeId) => '$AppointmentURL/appointment-upload-attachment/$typeId';

  static const String coSubmit = '/v1/social-inspectors/crm/push-info';
  static const String forceUpdate = '/v1/force-update-apps/version';

  static const String slaughter_inquiry = '/v1/gis/slaughter';

  static const String wallet = '/v1/digital-wallet/license-info';
  static const String printWalletLicense = '/v1/digital-wallet/download-license/';
}
