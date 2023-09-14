import 'package:collection/collection.dart';

class ValidateFormResponse {
  String? id;
  String? responseMessage;
  List<ValidationsErrors>? errors;
  bool? isSuccess;
  ValidateFormResponse(
      {this.id, this.responseMessage, this.errors, this.isSuccess});
}

class ValidationsErrors {
  ValidationsErrors({
    this.errors,
    this.id,
    this.value,
  });

  List<ValidationError>? errors;
  String? id;
  int? value;

  List<String>? get errorsStr =>
      errors?.map((e) => e.message).toList().whereNotNull().toList();
}

class ValidationError {
  ValidationError({
    this.code,
    this.message,
  });

  String? code;
  String? message;
}
