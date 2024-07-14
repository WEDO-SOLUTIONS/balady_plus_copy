import '../../../ekram_exports.dart';

class ApplyDeceasedResponseModel extends ApplyDeceasedResponse {
  ApplyDeceasedResponseModel({super.message, super.requestId});
  factory ApplyDeceasedResponseModel.fromMap(Map<String, dynamic> json) =>
      ApplyDeceasedResponseModel(
          message: json["message"], requestId: json["requestId"]);
}
