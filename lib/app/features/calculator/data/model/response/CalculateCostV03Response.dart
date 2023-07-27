import '../../../service_calculator_exports.dart' show CostsInfo;

class CalculateCostV03Response {
  List<CostsInfo>? costsInfo;
  int? paymentYearsCount;
  double? totalCost;
  int? statusCode;
  String? statusName;
  List<dynamic>? errorList;

  CalculateCostV03Response(
      {this.costsInfo,
      this.paymentYearsCount,
      this.totalCost,
      this.statusCode,
      this.statusName,
      this.errorList});

  factory CalculateCostV03Response.fromJson(Map<String, dynamic> json) =>
      _$CalculateCostV03ResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CalculateCostV03ResponseToJson(this);
}

CalculateCostV03Response _$CalculateCostV03ResponseFromJson(
    Map<String, dynamic> json) {
  if (json["resultItem"] != null) {
    return CalculateCostV03Response(
        costsInfo: List<CostsInfo>.from(
            json["resultItem"]["CostsInfo"].map((x) => CostsInfo.fromJson(x))),
        paymentYearsCount: json["resultItem"]["PaymentYearsCount"],
        totalCost: json["resultItem"]["TotalCost"],
        statusCode: json["statusCode"],
        statusName: json["statusName"],
        errorList: json["errorList"]);
  } else {
    return CalculateCostV03Response(
        statusCode: json["statusCode"],
        statusName: json["statusName"],
        errorList: json["errorList"]);
  }
}

Map<String, dynamic> _$CalculateCostV03ResponseToJson(
        CalculateCostV03Response instance) =>
    <String, dynamic>{};
