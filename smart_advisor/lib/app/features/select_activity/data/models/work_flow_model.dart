class WorkFlowModel {
  final String? stepId;
  final String? stepName;
  final int? sequenceId;
  final int? index;

  WorkFlowModel({
    this.stepId,
    this.stepName,
    this.sequenceId,
    this.index,
  });

  WorkFlowModel copyWith({
    String? stepId,
    String? stepName,
    int? sequenceId,
    int? index,
  }) =>
      WorkFlowModel(
        stepId: stepId ?? this.stepId,
        stepName: stepName ?? this.stepName,
        sequenceId: sequenceId ?? this.sequenceId,
        index: index ?? this.index,
      );

  factory WorkFlowModel.fromJson(Map<String, dynamic> json) => WorkFlowModel(
        stepId: json["stepId"],
        stepName: json["stepName"],
        sequenceId: json["sequenceId"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "stepId": stepId,
        "stepName": stepName,
        "sequenceId": sequenceId,
        "index": index,
      };

  String getIcon() {
    switch (stepId) {
      case "commercial-municipality-approval":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-municipality-approval.png";

      case "commercial-office-approval":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-office-approval.png";

      case "commercial-civil-defense-approval":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-civil-defense-approval.png";

      case "commercial-general-security-approval":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-general-security-approval.png";

      case "commercial-governmental-approval":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-governmental-approval.png";

      case "commercial-redirect-to-pay":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-redirect-to-pay.png";

      case "commercial-momtathel-post-observation":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-momtathel-post-observation.png";

      case "commercial-balady-post-observation":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-balady-post-observation.png";

      case "commercial-office-post-observation":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-office-post-observation.png";

      case "commercial-operation-team-approval":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-operation-team-approval.png";

      case "commercial-apply-request":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-apply-request.png";

      case "commercial-balady-approval":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-balady-approval.png";

      case "commercial-observation-approval":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-observation-approval.png";

      case "commercial-issuing-license":
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-issuing-license.png";

      default:
        return "packages/smart_advisor/smart_advisor_assets/icons/png/commercial-general-security-approval.png";
    }
  }
}
