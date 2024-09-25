class PermitSubmitResponseModel {
  final int? requestId;
  final String? billNumber;
  final String? payUrl;
  final bool? redirectToPay;
  final String? message;
  final String? billKey;

  PermitSubmitResponseModel(
      {this.requestId,
      this.billNumber,
      this.payUrl,
      this.redirectToPay,
      this.message,
      this.billKey});

  factory PermitSubmitResponseModel.fromJson(Map<String, dynamic> json) =>
      PermitSubmitResponseModel(
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
