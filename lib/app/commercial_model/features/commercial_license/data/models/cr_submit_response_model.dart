import '../../commercial_license_exports.dart' show CrSubmitResponse;

class CrSubmitResponseModel extends CrSubmitResponse {
  CrSubmitResponseModel(
      {super.message,
      super.redirectToPay,
      super.accountNumber,
      super.payUrl,
      super.requestId});

  factory CrSubmitResponseModel.fromJson(Map<String, dynamic> json) =>
      CrSubmitResponseModel(
          requestId: json["requestId"],
          message: json["message"],
          redirectToPay: json["redirectToPay"],
          accountNumber: json["accountNumber"],
          payUrl: json["payUrl"]);
}
