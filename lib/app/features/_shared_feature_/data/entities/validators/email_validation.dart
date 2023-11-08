import 'package:formz/formz.dart' show FormzInput;

import '../../../../../core/utils/utils_exports.dart' show Regex, Validation;

class EmailValidation extends FormzInput<String?, Validation> {
  const EmailValidation.pure({String? email}) : super.pure(email);
  const EmailValidation.dirty({String? email}) : super.dirty(email);

  @override
  Validation? validator(String? value) {
    final enteredValue = value?.trim();
    if (enteredValue != null && enteredValue.isEmpty) {
      return Validation.empty;
    } else if (enteredValue != null && !Regex.email.hasMatch(enteredValue)) {
      return Validation.invalidEmail;
    } else {
      return null;
    }
  }
}
