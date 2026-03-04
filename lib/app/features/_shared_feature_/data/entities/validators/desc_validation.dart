import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:formz/formz.dart' show FormzInput;

import '../../../../../core/utils/enums/validations.dart';

class DescValidation extends FormzInput<String?, Validation> {
  const DescValidation.pure({String? value}) : super.pure(value);
  const DescValidation.dirty({String? value}) : super.dirty(value);

  @override
  Validation? validator(String? value) {
    final enteredValue = value;
    if (enteredValue != null && enteredValue.isEmpty) {
      return Validation.empty;
    } else if (enteredValue != null && !CommonFunctions.doesContainsLettrs(enteredValue.toString())) {
      return Validation.invalidDesc;
    } else {
      return null;
    }
  }
}
