import '../../domain/entity/validate_license_entity.dart';

class ValidateLicenseDataModel extends ValidateLicenseEntity {
  ValidateLicenseDataModel({
    super.responseCode,
    super.responseMessage,
    super.responseId,
    super.result,
  });

  ValidateLicenseDataModel.fromJson(dynamic json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    result = json['result'];
  }
}
