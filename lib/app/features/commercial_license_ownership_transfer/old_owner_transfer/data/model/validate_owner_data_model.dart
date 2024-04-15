import '../../domain/entity/validate_owner_entity.dart';

class ValidateOwnerDataModel extends ValidateOwnerEntity {
  ValidateOwnerDataModel({
    super.responseCode,
    super.responseMessage,
    super.responseId,
    super.result,
  });

  ValidateOwnerDataModel.fromJson(dynamic json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    if (json['result'] != null) {
      result = json['result'];
    }
  }
}
