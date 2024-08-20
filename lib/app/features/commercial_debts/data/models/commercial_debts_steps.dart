

class CommercialDebtRenewStates {
  static const String noDebts = "no-debts";
  static const String warning = "warning";
  static const String blocked = "blocked";
}


enum TransactionType {request}



class RenewSteps {
  // Step One
  static const String validateBeforeApplySteps =
      "commercial.renew.mobile.validate-before-apply";
  // Step Two
  static const String applySteps = "commercial.renew.mobile.apply";
  // Step Three
  static const String saveRequestInfoSteps = "commercial.renew.mobile.save-request-info";
  // Step Four
  static const String calculateFeesSteps = "commercial.renew.mobile.calculate-fees";
  // Step Five
  static const String submitSteps = "commercial.renew.mobile.submit";
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
