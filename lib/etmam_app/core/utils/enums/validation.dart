import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;

enum Validation {
  //? First solution,
  // but when you access message, you need to translate it
  empty(message: "emptyFieldWord"),
  invalidEmail(message: "invalidEmailFieldWord"),
  invalidPassword(message: "invalidPasswordFieldWord"),
  passwordMismatch(message: "passwordMismatchFieldWord"),
  passwordMismatchCurrent(message: "passwordMismatchCurrentFieldWord"),
  invalidEndDate(message: "invalidEndDateWord"),
  phoneNumberStartWith05(message: "phoneNumberStartWith05"),
  phoneNumberLengthIs10(message: "phoneNumberLengthIs10");

  const Validation({required this.message});
  final String message;

  //? Second solution
  String get toEmptyMessage => "emptyFieldWord".tr();
  String get toInvalidEmailMessage => "invalidEmailFieldWord".tr();
  String get toInvalidPasswordMessage => "invalidPasswordFieldWord".tr();
  String get toPasswordMismatchMessage => "passwordMismatchFieldWord".tr();
  String get toPasswordMismatchCurrentMessage =>
      "passwordMismatchCurrentFieldWord".tr();
  String get toInvalidEndDateMessage => "invalidEndDateWord".tr();
  String get toPhoneNumberStartWith05 => "phoneNumberStartWith05".tr();
  String get toPhoneNumberLengthIs10 => "phoneNumberLengthIs10".tr();

  //? Third solution
  String get toMessage {
    switch (this) {
      case Validation.empty:
        return "emptyFieldWord".tr();
      case Validation.invalidEmail:
        return "invalidEmailFieldWord".tr();
      case Validation.invalidPassword:
        return "invalidPasswordFieldWord".tr();
      case Validation.passwordMismatch:
        return "passwordMismatchFieldWord".tr();
      case Validation.passwordMismatchCurrent:
        return "passwordMismatchCurrentFieldWord".tr();
      case Validation.invalidEndDate:
        return "invalidEndDateWord".tr();
      case Validation.phoneNumberStartWith05:
        return "phoneNumberStartWith05".tr();
      case Validation.phoneNumberLengthIs10:
        return "phoneNumberLengthIs10".tr();
    }
  }
}
