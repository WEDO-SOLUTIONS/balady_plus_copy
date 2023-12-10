class PermitSubmitResponseModel {
  final int? requestId;
  final String? billNumber;
  final String? payUrl;
  final bool? redirectToPay;
  final String? message;

  PermitSubmitResponseModel({
    this.requestId,
    this.billNumber,
    this.payUrl,
    this.redirectToPay,
    this.message,
  });

  factory PermitSubmitResponseModel.fromJson(Map<String, dynamic> json) =>
      PermitSubmitResponseModel(
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
