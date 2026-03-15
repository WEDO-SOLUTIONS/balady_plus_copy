import 'package:formz/formz.dart' show FormzInput;

import 'package:balady_plus/app/core/utils/enums/validations.dart';

class PhoneNumberValidation extends FormzInput<String?, Validation> {
  const PhoneNumberValidation.pure({String? value}) : super.pure(value);
  const PhoneNumberValidation.dirty({String? value}) : super.dirty(value);

  @override
  Validation? validator(String? value) {
    final enteredValue = value;
    if (enteredValue != null && enteredValue.isEmpty) {
      return Validation.empty;
    } else if (enteredValue != null && enteredValue.length > 2 && !enteredValue.startsWith("05")) {
      return Validation.phoneNumberStartWith05;
    } else if (enteredValue != null && (enteredValue.length < 10 || enteredValue.length > 10)) {
      return Validation.phoneNumberLengthIs10;
    } else {
      return null;
    }
  }
}
