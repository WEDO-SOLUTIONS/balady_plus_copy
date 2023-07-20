import 'package:formz/formz.dart' show FormzInput;

import 'package:balady_plus/app/core/utils/enums/validations.dart';

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
