import 'package:formz/formz.dart' show FormzInput;

import '../../../../../core/utils/utils_exports.dart' show Validation;

class ConfirmPasswordValidation extends FormzInput<String, Validation> {
  final String originalPassword;
  const ConfirmPasswordValidation.pure({required this.originalPassword}) : super.pure(originalPassword);

  const ConfirmPasswordValidation.dirty({
    /// This is what we will use to compare it with entered-password
    required this.originalPassword,

    /// This is entered password
    required String confirmPassword,
  }) : super.dirty(confirmPassword);

  @override
  Validation? validator(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return Validation.empty;
    } else if (password != originalPassword) {
      return Validation.passwordMismatch;
    } else {
      return null;
    }
  }
}
