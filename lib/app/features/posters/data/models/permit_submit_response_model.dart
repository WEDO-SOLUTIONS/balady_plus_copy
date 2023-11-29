class PostersSubmitResponseModel {
  final int? requestId;
  final String? billNumber;
  final String? payUrl;
  final bool? redirectToPay;
  final String? message;
  bool isGrouped;

  PostersSubmitResponseModel(
      {this.requestId,
      this.billNumber,
      this.payUrl,
      this.redirectToPay,
      this.message,
      this.isGrouped = false});

  factory PostersSubmitResponseModel.fromJson(Map<String, dynamic> json) =>
      PostersSubmitResponseModel(
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
