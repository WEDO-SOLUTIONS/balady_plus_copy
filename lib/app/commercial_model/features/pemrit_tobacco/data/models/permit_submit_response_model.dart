class PermitTobaccoSubmitResponseModel {
  final int? requestId;
  final String? billNumber;
  final String? payUrl;
  final bool? redirectToPay;
  final String? message;
  final String? billKey;

  PermitTobaccoSubmitResponseModel(
      {this.requestId,
      this.billNumber,
      this.payUrl,
      this.redirectToPay,
      this.message,
      this.billKey});

  factory PermitTobaccoSubmitResponseModel.fromJson(
          Map<String, dynamic> json) =>
      PermitTobaccoSubmitResponseModel(
          requestId: json["requestId"],
          billNumber: json["billNumber"],
          payUrl: json["payUrl"],
          redirectToPay: json["redirectToPay"],
          message: json["message"],
          billKey: json["billKey"]);

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "billNumber": billNumber,
        "payUrl": payUrl,
        "redirectToPay": redirectToPay,
        "message": message,
      };
}
