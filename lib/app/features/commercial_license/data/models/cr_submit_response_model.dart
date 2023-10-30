import '../../commercial_license_exports.dart' show CrSubmitResponse;

class CrSubmitResponseModel extends CrSubmitResponse {
  CrSubmitResponseModel({super.message});

  factory CrSubmitResponseModel.fromJson(Map<String, dynamic> json) =>
      CrSubmitResponseModel(message: json["message"]);
}
