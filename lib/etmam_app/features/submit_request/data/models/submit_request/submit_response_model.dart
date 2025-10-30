import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_response.dart';

class SubmitResponseModel extends SubmitRespone {
  SubmitResponseModel({super.id, super.successMessage, super.number});

  factory SubmitResponseModel.fromMap(Map<String, dynamic> json) =>
      SubmitResponseModel(
          id: json["id"],
          successMessage: json["successMessage"],
          number: json["number"]);
}
