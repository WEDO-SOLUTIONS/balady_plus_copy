

class CrSubmitResponseModel {
  int? requestId;
  String? message;
  bool? redirectToPay;
  String? accountNumber;
  String? payUrl;

  CrSubmitResponseModel(
      {this.message,
        this.redirectToPay,
        this.accountNumber,
        this.payUrl,
        this.requestId});

  factory CrSubmitResponseModel.fromJson(Map<String, dynamic> json) =>
      CrSubmitResponseModel(
          requestId: json["requestId"],
          message: json["message"],
          redirectToPay: json["redirectToPay"],
          accountNumber: json["accountNumber"],
          payUrl: json["payUrl"]);
}
