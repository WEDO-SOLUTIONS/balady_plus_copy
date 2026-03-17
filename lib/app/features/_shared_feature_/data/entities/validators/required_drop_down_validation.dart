import 'package:formz/formz.dart' show FormzInput;

import '../../../../../core/utils/utils_exports.dart' show Validation;
import '../../../shared_feature_exports.dart' show DropDownItem;

class RequiredDropDownValidation extends FormzInput<DropDownItem, Validation> {
  const RequiredDropDownValidation.pure({required DropDownItem value})
      : super.pure(value);
  const RequiredDropDownValidation.dirty({required DropDownItem value})
      : super.dirty(value);

  @override
  Validation? validator(DropDownItem value) {
    if (value.isEmpty) {
      return Validation.empty;
    } else {
      return null;
    }
  }
}
