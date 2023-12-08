import 'package:formz/formz.dart' show FormzInput;

import '../../../../../../core/utils/utils_exports.dart' show Validation;

class PasswordValidation extends FormzInput<String?, Validation> {
  const PasswordValidation.pure({String? password}) : super.pure(password);

  const PasswordValidation.dirty({String? password}) : super.dirty(password);

  @override
  Validation? validator(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return Validation.empty;
    } else if (password.length < 6) {
      return Validation.invalidPassword;
    } else {
      return null;
    }
  }
}
