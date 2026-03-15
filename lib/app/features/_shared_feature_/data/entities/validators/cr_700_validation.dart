import 'package:formz/formz.dart' show FormzInput;

import 'package:balady_plus/app/core/utils/enums/validations.dart';

class Cr700Validation extends FormzInput<String?, Validation> {
  const Cr700Validation.pure({String? value}) : super.pure(value);
  const Cr700Validation.dirty({String? value}) : super.dirty(value);

  @override
  Validation? validator(String? value) {
    final enteredValue = value;
    if (enteredValue != null && enteredValue.isEmpty) {
      return Validation.empty;
    } else if (enteredValue != null && !enteredValue.startsWith("7")) {
      return Validation.cr700StartsWith7;
    } else if (enteredValue != null && (enteredValue.length < 10 || enteredValue.length > 10)) {
      return Validation.cr700LengthValidation;
    } else {
      return null;
    }
  }
}
