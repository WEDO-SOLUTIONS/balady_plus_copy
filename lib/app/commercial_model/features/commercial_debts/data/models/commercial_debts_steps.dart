class CommercialDebtRenewStates {
  static const String noDebts = "no-debts";
  static const String warning = "warning";
  static const String blocked = "blocked";
}

enum TransactionType { REQUEST, LICENSE }

enum CommercialLicenseServiceId {
  issueCommercialLicense(1004),
  renewCommercialLicense(1005),
  ownershipTransferCommercialLicense(1006),
  cancelCommercialLicense(1008);
  const CommercialLicenseServiceId(this.id);
  final int id;
}

class RenewSteps {
  // Step 1
  // static const String validateBeforeApplySteps =
  //     "commercial.renew.mobile.validate-before-apply";

  // Step 2
  // static const String applySteps = "commercial.renew.mobile.apply";
  // Step 3
  static const String saveRequestInfoSteps =
      "commercial.renew.mobile.save-request-info";

  // Step 4
  static const String saveAttachments =
      "commercial.renew.mobile.save-attachments";

  // Step 5
  static const String calculateFeesSteps =
      "commercial.renew.mobile.calculate-fees";
// Step 6
// static const String submitSteps = "commercial.renew.mobile.submit";
}

class CancelSteps {
  // Step Two
  // static const String applySteps = "commercial.cancel.mobile.apply";
  // Step Three
  static const String saveRequestInfoSteps =
      "commercial.cancel.mobile.save-cancellation-info";

  // Step Four
  static const String calculateFeesSteps =
      "commercial.cancel.mobile.calculate-fees";

  // Step Five
  static const String submitSteps = "commercial.cancel.mobile.submit";
}

class OwnershipTransferSteps {
  // Old Owner
  static const String permits =
      "commercial.transfer-ownership.mobile.save-old-owner-permits";
  static const String validateNewOwner =
      "commercial.transfer-ownership.mobile.validate-new-owner";
  static const String sendRequestToNewOwner =
      "commercial.transfer-ownership.mobile.send-request-to-new-owner";

  // New Owner
  static const String acceptOrRejectRequestByNewOwner =
      "commercial.transfer-ownership.mobile.new-owner-accept-or-reject";
  static const String permitsNewOwner =
      "commercial.transfer-ownership.mobile.save-new-owner-permits";
  static const String saveShopInfo =
      "commercial.transfer-ownership.mobile.save-shop-info";
  static const String saveOwnershipInfo =
      "commercial.transfer-ownership.mobile.save-ownership-info";
  static const String submitSteps =
      "commercial.transfer-ownership.mobile.submit-request-by-new-owner";
}

class IssueSteps {
  static const String saveActivity =
      "commercial.issue.mobile.save-activity"; // when call this events have screen but the screen in after the step one
  static const String saveLocation =
      "commercial.issue.mobile.save-location"; // this is step 3
  static const String saveShopInfo =
      "commercial.issue.mobile.save-shop-info"; // step 4
  static const String saveAttachments =
      "commercial.issue.mobile.save-attachments"; // Step 5
  //  EstablishmentData
  //  WorkTimes
  //  AdditionalData
  //  Attachment
  static const String calculateFees =
      "commercial.issue.mobile.calculate-fees"; //   CalculatorReview
  static const String submitSteps = "commercial.issue.mobile.submit"; //  Review
}

/// have in  Issue Steps on mobile 11 but vildet on 7
var listIssueSteps = const [
  "", // add Fake Step
  IssueSteps.saveActivity,
  IssueSteps.saveLocation,
  IssueSteps.saveShopInfo,
  IssueSteps.saveAttachments,
  "", // add Fake Step
  "", // add Fake Step
  "", // add Fake Step
  "", // add Fake Step
  IssueSteps.calculateFees,
  IssueSteps.submitSteps,
];

List<String> listReneWEvents = [
  RenewSteps.saveRequestInfoSteps,
  RenewSteps.saveAttachments,
  RenewSteps.calculateFeesSteps,
];

List<String> listCancelSteps = [
  CancelSteps.saveRequestInfoSteps ,
  CancelSteps.calculateFeesSteps,
];
// New Dsgin for Step
// enum IssueStepsEnum {
//   saveActivity,
//   saveLocation,
//   saveShopInfo,
//   saveAttachments,
//   calculateFees,
//   submitSteps,
// }
//
// const Map<IssueStepsEnum,String> issueSteps  = {
//   IssueStepsEnum.saveActivity : "commercial.issue.mobile.save-activity",
//   IssueStepsEnum.saveLocation : "commercial.issue.mobile.save-location",
//   IssueStepsEnum.saveShopInfo : "commercial.issue.mobile.save-shop-info",
//   IssueStepsEnum.saveAttachments : "commercial.issue.mobile.save-attachments",
//   IssueStepsEnum.calculateFees : "commercial.issue.mobile.calculate-fees",
//   IssueStepsEnum.submitSteps : "commercial.issue.mobile.submit",
// };

// class CommercialDebtsSteps {
//   final String transactionType;
//   final String requestId;
//   final String steps;
//
//   CommercialDebtsSteps({
//     required this.transactionType,
//     required this.requestId,
//     required this.steps,
//   });
// }
