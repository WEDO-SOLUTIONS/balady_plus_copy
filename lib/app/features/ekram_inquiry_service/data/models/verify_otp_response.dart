class VerifyOTPResponseModel {
  String? printUrl;

  VerifyOTPResponseModel({this.printUrl});

  factory VerifyOTPResponseModel.fromJson(Map<String, dynamic> json) =>
      VerifyOTPResponseModel(printUrl: json["printUrl"]);
}
