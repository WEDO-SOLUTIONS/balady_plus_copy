import 'package:formz/formz.dart' show FormzInput;

import '../../../../../../core/utils/utils_exports.dart' show Validation;

class RequiredFieldValidation extends FormzInput<String?, Validation> {
  const RequiredFieldValidation.pure({String? value}) : super.pure(value);
  const RequiredFieldValidation.dirty({String? value}) : super.dirty(value);

  @override
  Validation? validator(String? value) {
    final enteredValue = value ?? '';
    if (enteredValue.isEmpty) {
      return Validation.empty;
    } else {
      return null;
    }
  }
}
