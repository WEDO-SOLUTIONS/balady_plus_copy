class SendOTPResponseModel {
  String? certificateCode;

  SendOTPResponseModel({this.certificateCode});

  factory SendOTPResponseModel.fromJson(Map<String, dynamic> json) =>
      SendOTPResponseModel(certificateCode: json["certificateCode"]);
}
