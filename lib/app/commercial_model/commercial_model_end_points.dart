class CommercialModelEndPoints {
  static const delegators =
      '/v1/delegation-services/delegated-commercial-records';

  static const validActivitiesAreasUrl =
      '/v1/balady-commercial-services/business-rules/valid-activities-areas';

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
      'v1/balady-commercial-services/new-request/$requestId/submits';

  static String saveShopDetails(int requestId) =>
      'v1/balady-commercial-services/new-request/$requestId/shop-details';

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

/////////////////////  Renew Commercial Service ///////////////////////////
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

/////////////////////  Commercial License Details ///////////////////////////
  static String getCommercialLicenseDetails(int licenseId) =>
      '/v1/balady-commercial-services/licenses/$licenseId';

  static String commercialLicensePermits(int licenseId) =>
      '/v1/balady-commercial-services/licenses/permits/$licenseId';

  static String getLicenseAttachments(int licenseId) =>
      '/v1/balady-commercial-services/license-attachments/$licenseId';

  static String getCommercialLicenseAllowedActions(int licenseId) =>
      '/v1/balady-commercial-services/licenses/$licenseId/allowed-actions';

/////////////////////  Commercial License Cancel ///////////////////////////
  static const String commercialLicenseCancellationReasons =
      '/v1/balady-commercial-services/mobile/cancel-reasons';

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

  /////////////////////// promotions //////////////////////////////////
  static String getLicensesForPermits(
          {required String crNumber, required String groupId}) =>
      "/v1/commercial-promotions-services/licenses/$crNumber/$groupId";

  static String getGroupsItems =
      "v1/commercial-promotions-services/group-services";

  static String savePoster(String requestId) =>
      "v1/commercial-promotions-services/posters/$requestId";

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

  /////////////////////// 24 Hour Permi //////////////////////////////////
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

  /////////////////////// commercial license query /////////////////////////////
  static String getCommercialLicenseData(
          int licenseNumber, unifiedFacilityNumber) =>
      '/v1/balady-commercial-services/licenses/$licenseNumber/by-unn/$unifiedFacilityNumber';

  /////////////////////// Ownership /////////////////////////////
  static String comercialLicenseTransferShopInfo(int requestId) =>
      'v1/superapp-commercial-ownership-services/transfer/shop-ownership-info/$requestId';

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

  static String commercialLicenseOwnershipServicesUploadAttachments(
          int requestId, int attachTypeId) =>
      'v1/superapp-commercial-ownership-services/transfer/upload-attachment/$attachTypeId/attachments/$requestId';

  //////////////////////////  Tobacco /////////////////////////////
  static const String getUserFacilities =
      '/v1/tobacco-services/user-facilities';
  static const String getTobaccoDisclosure = '/v1/tobacco-services/disclosures';
  static const String getTobaccoDisclosureUploadFile =
      '/v1/tobacco-services/stream/upload';
  static const String getTobaccoDisclosureUpload =
      '/v1/tobacco-services/disclosures/upload';

  //////////////////////////  Tobacco Permit /////////////////////////////
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

////////////////////////// Debts /////////////////////////////
  static checkDebts({required String transactionType, required int transactionId}) => 'v1/debt-collection-services/mobile/debts/$transactionType/$transactionId';

  static getListDebtsPaging({required String referenceId, required int transactionId, required String transactionType}) => 'v1/debt-collection-services/mobile/debts/paging/$transactionType/$transactionId/$referenceId';


///////////////// initail approvel request

  static String commercialInitialApprovalApply =
      "v1/balady-commercial-initial-approval-services/issuing/apply";

  static const String InitialApprovalAccommodationTypes =
      "/v1/balady-commercial-initial-approval-services/accommodation-types";

  static  String InitialApprovalSubActivities (int requestID,int isicCode) =>
      "/v1/balady-commercial-initial-approval-services/salama-activities-by-isic-number-with-facility/$isicCode/$requestID";

  static  String InitialApprovalMainActivities (int requestID) =>
      "/v1/balady-commercial-initial-approval-services/activities/isics/$requestID";
  static  String InitialApprovalsubActivityDetails(String isicCode) =>
      "/v1/balady-commercial-initial-approval-services/activities/$isicCode";

  static  String InitialApprovalAddIsicActivities (int requestID)=>
      "/v1/balady-commercial-initial-approval-services/cr-isic-activities/$requestID";

  static String InitialApprovalAddetionalDetailsActivity(
      String subActivity, int addetioanlActivityId) =>
      'v1/balady-commercial-services/new-request/additional/activities/$subActivity/$addetioanlActivityId';
  static String InitialApprovalRequestDetails( int requestId) =>
      '/v1/balady-commercial-initial-approval-services/request/details/$requestId';

  static String InitialApprovalCalculateFessInteractively(int requestId) =>
      '/v1/balady-commercial-initial-approval-services/calculate-fees-interactively/$requestId';

  static String InitialApprovalSubmit(int requestId) =>
      '/v1/balady-commercial-initial-approval-services/issuing/submit/$requestId';


  static String InitialApprovalSaveActivityAndSites(int requestId) =>
      "/v1/balady-commercial-initial-approval-services/site-and-activities/$requestId";

  static String applyLicenseExport(int requestId) =>
      "/v1/balady-commercial-initial-approval-services/commercial/apply/$requestId";
  static String intialApprovalConclusion(int requestId) =>
      "/v1/balady-commercial-initial-approval-services/lookups/$requestId?typeId=ISSUING";

  static String cancelIntialApproval(int requestId) => "/v1/balady-commercial-initial-approval-services/requests/$requestId";

  static String getSPLNotifcation = "/v1/balady-commercial-mobile-services/spl/site-info";

  static String replyWithNote(String requestId) => "/v1/balady-commercial-initial-approval-services/reply-note/$requestId";






}
