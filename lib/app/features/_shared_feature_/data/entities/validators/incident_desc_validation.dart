import 'package:formz/formz.dart' show FormzInput;

import 'package:balady_plus/app/core/utils/enums/validations.dart';

import '../../../../../core/utils/common_functions.dart';

class IncidentDescValidation extends FormzInput<String?, Validation> {
  const IncidentDescValidation.pure({String? value}) : super.pure(value);
  const IncidentDescValidation.dirty({String? value}) : super.dirty(value);

  @override
  Validation? validator(String? value) {
    final enteredValue = value;
    if (enteredValue != null && enteredValue.isEmpty) {
      return Validation.empty;
    } else if (enteredValue != null && !CommonFunctions.doesContainsLettrs(enteredValue.toString())) {
      return Validation.invalidIncidentDesc;
    } else {
      return null;
    }
  }
}
