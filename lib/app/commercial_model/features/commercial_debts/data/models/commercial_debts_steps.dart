

class CommercialDebtRenewStates {
  static const String noDebts = "no-debts";
  static const String warning = "warning";
  static const String blocked = "blocked";
}


enum TransactionType {REQUEST,LICENSE}


class RenewSteps {
  // Step 1
  static const String validateBeforeApplySteps =
      "commercial.renew.mobile.validate-before-apply";
  // Step 2
  // static const String applySteps = "commercial.renew.mobile.apply";
  // Step 3
  static const String saveRequestInfoSteps = "commercial.renew.mobile.save-request-info";
  // Step 3
  static const String saveAttachments = "commercial.renew.mobile.save-attachments";
  // Step 5
  static const String calculateFeesSteps = "commercial.renew.mobile.calculate-fees";
  // Step 6
  // static const String submitSteps = "commercial.renew.mobile.submit";
}

class CancelSteps {
  // Step Two
  static const String applySteps = "commercial.cancel.mobile.apply";
  // Step Three
  static const String saveRequestInfoSteps = "commercial.cancel.mobile.save-cancellation-info";
  // Step Four
  static const String calculateFeesSteps = "commercial.cancel.mobile.calculate-fees";
  // Step Five
  static const String submitSteps = "commercial.cancel.mobile.submit";
}

class IssueSteps {
  static const String applySteps = "commercial.issue.mobile.apply";
  static const String saveActivity = "commercial.issue.mobile.save-activity";
  static const String saveLocation = "commercial.issue.mobile.save-location";
  static const String saveShopInfo = "commercial.issue.mobile.save-shop-info";
  static const String saveAttachments = "commercial.issue.mobile.save-attachments";
  static const String calculateFees = "commercial.issue.mobile.calculate-fees";
  static const String submitSteps = "commercial.issue.mobile.submit";
}









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
