class VerifyOTPResponseModel {
  String? certificateCode;

  VerifyOTPResponseModel({this.certificateCode});

  factory VerifyOTPResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyOTPResponseModel(certificateCode: json["certificateCode"]);
}
