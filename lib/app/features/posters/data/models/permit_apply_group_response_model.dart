class PermitApplyGroupResponse {
  final int? requestId;
  final String? requestKey;
  final List<dynamic>? appliedLicenses;

  PermitApplyGroupResponse({
    this.requestId,
    this.requestKey,
    this.appliedLicenses,
  });

  factory PermitApplyGroupResponse.fromJson(Map<String, dynamic> json) =>
      PermitApplyGroupResponse(
        requestId: json["requestId"],
        requestKey: json["requestKey"],
        appliedLicenses: json["appliedLicenses"] == null
            ? []
            : List<dynamic>.from(json["appliedLicenses"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "requestKey": requestKey,
        "appliedLicenses": appliedLicenses == null
            ? []
            : List<dynamic>.from(appliedLicenses!.map((x) => x)),
      };
}
