import 'package:formz/formz.dart' show FormzInput;

import '../../../../../../core/utils/utils_exports.dart' show Validation;

class OptionalFieldValidation extends FormzInput<String?, Validation> {
  const OptionalFieldValidation.pure({String? value}) : super.pure(value);
  const OptionalFieldValidation.dirty({String? value}) : super.dirty(value);

  @override
  Validation? validator(String? value) {
    final enteredValue = value;
    if (enteredValue == null) {
      return null;
    } else if (enteredValue.isEmpty) {
      return Validation.empty;
    } else {
      return null;
    }
  }
}
