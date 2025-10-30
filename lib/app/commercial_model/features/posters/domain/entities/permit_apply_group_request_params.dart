class PermitApplyGroupRequestParams {
  final String? crNumber;
  final int? crType;
  final List<int>? licenses;

  PermitApplyGroupRequestParams({
    this.crNumber,
    this.crType,
    this.licenses,
  });

  factory PermitApplyGroupRequestParams.fromJson(Map<String, dynamic> json) =>
      PermitApplyGroupRequestParams(
        crNumber: json["crNumber"],
        crType: json["crType"],
        licenses: json["licenses"] == null
            ? []
            : List<int>.from(json["licenses"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "crNumber": crNumber,
        "crType": crType,
        "licenses":
            licenses == null ? [] : List<dynamic>.from(licenses!.map((x) => x)),
      };
}
