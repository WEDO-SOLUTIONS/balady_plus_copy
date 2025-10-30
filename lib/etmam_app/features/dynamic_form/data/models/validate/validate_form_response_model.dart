import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_response.dart';

class ValidateFormResponseModel extends ValidateFormResponse {
  ValidateFormResponseModel({super.id, super.responseMessage, super.errors});

  factory ValidateFormResponseModel.fromJson(Map<String, dynamic> json) =>
      ValidateFormResponseModel(
        errors: json["errors"] != null
            ? List<ValidationsErrorsModel>.from(
                json["errors"].map((x) => ValidationsErrorsModel.fromJson(x)))
            : null,
        //  id: json["data"]?["id"],
        // responseMessage: json["data"]?["responseMessage"],
      );
}

class ValidationsErrorsModel extends ValidationsErrors {
  ValidationsErrorsModel({super.errors, super.id, super.value});

  factory ValidationsErrorsModel.fromJson(Map<String, dynamic> json) =>
      ValidationsErrorsModel(
        errors: List<ValidationErrorModel>.from(
            json["errors"].map((x) => ValidationErrorModel.fromJson(x))),
        id: json["id"],
        value: json["value"],
      );
}

class ValidationErrorModel extends ValidationError {
  ValidationErrorModel({
    super.code,
    super.message,
  });

  factory ValidationErrorModel.fromJson(Map<String, dynamic> json) =>
      ValidationErrorModel(
        code: json["code"],
        message: json["message"],
      );
}
