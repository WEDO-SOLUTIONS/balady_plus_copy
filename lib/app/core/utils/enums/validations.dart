enum Validation {
  //? First solution,
  // but when you access message, you need to translate it
  empty(message: "emptyFieldValidation"),
  invalidEmail(message: "invalidEmailValidation"),
  invalidPassword(message: "invalidPasswordValidation"),
  passwordMismatch(message: "passwordMismatchValidation"),
  invalidEndDate(message: "invalidEndDateValidation"),
  phoneNumberStartWith05(message: "phoneNumberStartsValidation"),
  phoneNumberLengthIs10(message: "phoneNumberLengthValidation"),
  invalidIncidentDesc(message: "incident_desc_limit_error"),
  invalidName(message: "error_input_only_chars") //MMTr
  ;

  const Validation({required this.message});
  final String message;
}
