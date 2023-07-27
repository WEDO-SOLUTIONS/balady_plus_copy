class CalculateCostResponse {
  double? totalCost;
  double? activtyCost;
  String? unit;
  String? unit_ar;
  double? visitFee;
  double? signageBoardCost;
  double? advertisingBoardCost;
  double? cleaningCost;
  double? oldCleaningCost;
  int? statusCode;
  String? statusName;
  String? errorDetails;
  List<dynamic>? errorList;

  CalculateCostResponse(
      {this.totalCost,
      this.activtyCost,
      this.unit,
      this.unit_ar,
      this.visitFee,
      this.signageBoardCost,
      this.advertisingBoardCost,
      this.cleaningCost,
      this.oldCleaningCost,
      this.statusCode,
      this.statusName,
      this.errorList,
      this.errorDetails});

  factory CalculateCostResponse.fromJson(Map<String, dynamic> json) =>
      _$CalculateCostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CalculateCostResponseToJson(this);
}

CalculateCostResponse _$CalculateCostResponseFromJson(
    Map<String, dynamic> json) {
  if (json["resultItem"] != null) {
    return CalculateCostResponse(
        totalCost: json["resultItem"]["totalCost"],
        activtyCost: json["resultItem"]["activtyCost"],
        unit: json["resultItem"]["unit"],
        unit_ar: json["resultItem"]["unit_ar"],
        visitFee: json["resultItem"]["visitFee"],
        signageBoardCost: json["resultItem"]["boardCost"]["SignageBoardCost"],
        advertisingBoardCost: json["resultItem"]["boardCost"]
            ["advertisingBoardCost"],
        cleaningCost: json["resultItem"]["CleaningCost"],
        oldCleaningCost: json["resultItem"]["OldCleaningCost"],
        statusName: json["statusName"],
        statusCode: json["statusCode"],
        errorDetails: json["errorDetails"],
        errorList: json["errorList"]);
  } else {
    return CalculateCostResponse(
        statusName: json["statusName"],
        statusCode: json["statusCode"],
        errorDetails: json["errorDetails"],
        errorList: json["errorList"]);
  }
}

Map<String, dynamic> _$CalculateCostResponseToJson(
        CalculateCostResponse instance) =>
    <String, dynamic>{};
