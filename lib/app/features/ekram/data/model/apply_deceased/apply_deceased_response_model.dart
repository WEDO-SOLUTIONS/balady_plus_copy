import '../../../ekram_exports.dart';

class ApplyDeceasedResponseModel extends ApplyDeceasedResponse {
  ApplyDeceasedResponseModel({super.message});
  factory ApplyDeceasedResponseModel.fromMap(Map<String, dynamic> json) =>
      ApplyDeceasedResponseModel(message: json["message"]);
}
