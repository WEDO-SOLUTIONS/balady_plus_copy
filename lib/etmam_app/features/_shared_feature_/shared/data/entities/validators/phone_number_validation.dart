import 'package:formz/formz.dart' show FormzInput;

import '../../../../../../core/utils/utils_exports.dart' show Validation;

class PhoneNumberValidation extends FormzInput<String?, Validation> {
  const PhoneNumberValidation.pure({String? value}) : super.pure(value);
  const PhoneNumberValidation.dirty({String? value}) : super.dirty(value);

  @override
  Validation? validator(String? value) {
    final enteredValue = value ?? '';
    if (enteredValue.isEmpty) {
      return Validation.empty;
    } else if (enteredValue.length > 2 && !enteredValue.startsWith("05")) {
      return Validation.phoneNumberStartWith05;
    } else if (enteredValue.length < 10) {
      return Validation.phoneNumberLengthIs10;
    } else {
      return null;
    }
  }
}
