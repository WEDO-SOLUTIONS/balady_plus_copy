import 'package:formz/formz.dart' show FormzInput;

import '../../../../../core/utils/utils_exports.dart' show Regex, Validation;

class EmailValidation extends FormzInput<String, Validation> {
  const EmailValidation.pure({required String email}) : super.pure(email);
  const EmailValidation.dirty({required String email}) : super.dirty(email);

  @override
  Validation? validator(String value) {
    final enteredValue = value.trim();
    if (enteredValue.isEmpty) {
      return Validation.empty;
    } else if (!Regex.email.hasMatch(enteredValue)) {
      return Validation.invalidEmail;
    } else {
      return null;
    }
  }
}
