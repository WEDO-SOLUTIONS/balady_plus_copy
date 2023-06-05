import 'package:formz/formz.dart' show FormzInput;

import '../../../../../core/utils/utils_exports.dart' show Validation;

class RequiredFieldValidation extends FormzInput<String, Validation> {
  const RequiredFieldValidation.pure({required String value})
      : super.pure(value);
  const RequiredFieldValidation.dirty({required String value})
      : super.dirty(value);

  @override
  Validation? validator(String value) {
    if (value.trim().isEmpty) {
      return Validation.empty;
    } else {
      return null;
    }
  }
}
