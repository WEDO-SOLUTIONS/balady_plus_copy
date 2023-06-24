class CalculateDiggingResponse {
  double? totalCost;
  double? diggingPeriod;
  String? periodUnit;
  String? distanceUnit;
  double? distance;
  double? unitCost;
  int? statusCode;
  String? statusName;
  String? errorDetails;
  List<dynamic>? errorList;

  CalculateDiggingResponse(
      {this.totalCost,
      this.diggingPeriod,
      this.periodUnit,
      this.distanceUnit,
      this.distance,
      this.unitCost,
      this.statusCode,
      this.statusName,
      this.errorDetails,
      this.errorList});

  factory CalculateDiggingResponse.fromJson(Map<String, dynamic> json) =>
      _$CalculateDiggingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CalculateDiggingResponseToJson(this);
}

CalculateDiggingResponse _$CalculateDiggingResponseFromJson(
    Map<String, dynamic> json) {
  if (json["resultItem"] != null) {
    return CalculateDiggingResponse(
        totalCost: json["resultItem"]["totalCost"],
        diggingPeriod: json["resultItem"]["diggingPeriod"],
        periodUnit: json["resultItem"]["periodUnit"],
        distanceUnit: json["resultItem"]["distanceUnit"],
        distance: json["resultItem"]["distance"],
        unitCost: json["resultItem"]["unitCost"],
        statusCode: json["statusCode"],
        statusName: json["statusName"],
        errorDetails: json["errorDetails"],
        errorList: json["errorList"]);
  } else {
    return CalculateDiggingResponse(
        statusCode: json["statusCode"],
        statusName: json["statusName"],
        errorDetails: json["errorDetails"],
        errorList: json["errorList"]);
  }
}

Map<String, dynamic> _$CalculateDiggingResponseToJson(
        CalculateDiggingResponse instance) =>
    <String, dynamic>{};
