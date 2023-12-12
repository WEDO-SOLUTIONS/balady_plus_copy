class PermitTobaccoSubmitResponseModel {
  final int? requestId;
  final String? billNumber;
  final String? payUrl;
  final bool? redirectToPay;
  final String? message;

  PermitTobaccoSubmitResponseModel({
    this.requestId,
    this.billNumber,
    this.payUrl,
    this.redirectToPay,
    this.message,
  });

  factory PermitTobaccoSubmitResponseModel.fromJson(
          Map<String, dynamic> json) =>
      PermitTobaccoSubmitResponseModel(
        requestId: json["requestId"],
        billNumber: json["billNumber"],
        payUrl: json["payUrl"],
        redirectToPay: json["redirectToPay"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "billNumber": billNumber,
        "payUrl": payUrl,
        "redirectToPay": redirectToPay,
        "message": message,
      };
}
