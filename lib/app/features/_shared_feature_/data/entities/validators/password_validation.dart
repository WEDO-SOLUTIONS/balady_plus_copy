import 'package:formz/formz.dart' show FormzInput;

import '../../../../../core/utils/utils_exports.dart' show Validation;

class PasswordValidation extends FormzInput<String, Validation> {
  const PasswordValidation.pure({required String password}) : super.pure(password);

  const PasswordValidation.dirty({required String password}) : super.dirty(password);

  @override
  Validation? validator(String value) {
    final enteredValue = value.trim();
    if (enteredValue.isEmpty) {
      return Validation.empty;
    } else if (enteredValue.length < 6) {
      return Validation.invalidPassword;
    } else {
      return null;
    }
  }
}
