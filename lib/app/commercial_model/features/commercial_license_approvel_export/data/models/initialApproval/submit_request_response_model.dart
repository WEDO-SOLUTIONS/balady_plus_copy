

class SubmitRequestResponseModel {
  int? requestId;
  String? message;
  bool? redirectToPay;
  String? accountNumber;
  String? payUrl;

  SubmitRequestResponseModel(
      {this.message,
        this.redirectToPay,
        this.accountNumber,
        this.payUrl,
        this.requestId});

  factory SubmitRequestResponseModel.fromJson(Map<String, dynamic> json) =>
      SubmitRequestResponseModel(
          requestId: json["requestId"],
          message: json["message"],
          redirectToPay: json["redirectToPay"],
          accountNumber: json["accountNumber"],
          payUrl: json["payUrl"]);
}
