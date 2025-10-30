import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/submit/submit_form_response.dart';

class SubmitFormResponseModel extends SubmitFormResponse {
  SubmitFormResponseModel({super.id, super.responseMessage});

  factory SubmitFormResponseModel.fromMap(Map<String, dynamic> json) =>
      SubmitFormResponseModel(
        id: json["id"],
        responseMessage: json["responseMessage"],
      );
}
