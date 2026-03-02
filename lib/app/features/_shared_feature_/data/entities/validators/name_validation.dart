import 'package:formz/formz.dart' show FormzInput;

import 'package:balady_plus/app/core/utils/enums/validations.dart';

import '../../../../../core/utils/common_functions.dart';

class NameValidation extends FormzInput<String?, Validation> {
  const NameValidation.pure({String? value}) : super.pure(value);
  const NameValidation.dirty({String? value}) : super.dirty(value);

  @override
  Validation? validator(String? value) {
    final enteredValue = value;
    if (enteredValue != null && enteredValue.isEmpty) {
      return Validation.empty;
    } else if (enteredValue != null &&
        (!CommonFunctions.hasArabicOrEnglishCharacters(enteredValue.trim()) || enteredValue.trim().length < 2)) {
      return Validation.invalidName;
    } else {
      return null;
    }
  }
}
