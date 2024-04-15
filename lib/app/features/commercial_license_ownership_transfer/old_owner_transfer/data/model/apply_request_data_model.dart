import '../../domain/entity/apply_request_entity.dart';

class ApplyRequestDataModel extends ApplyRequestEntity {
  ApplyRequestDataModel({
    super.responseCode,
    super.responseMessage,
    super.responseId,
    super.result,
  });

  ApplyRequestDataModel.fromJson(dynamic json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    if (json['result'] != null) {
      result = json['result'];
    }
  }
}
