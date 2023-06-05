enum Validation {
  //? First solution,
  // but when you access message, you need to translate it
  empty(message: "emptyFieldValidation"),
  invalidEmail(message: "invalidEmailValidation"),
  invalidPassword(message: "invalidPasswordValidation"),
  passwordMismatch(message: "passwordMismatchValidation"),
  invalidEndDate(message: "invalidEndDateValidation"),
  phoneNumberStartWith05(message: "phoneNumberStartsValidation"),
  phoneNumberLengthIs10(message: "phoneNumberLengthValidation");

  const Validation({required this.message});
  final String message;
}
