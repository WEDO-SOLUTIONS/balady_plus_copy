part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  final String? phone;
  final String? username;
  final String? password;
  final bool hidePassword;

  final BlocStatus status;
  final AuthData? authData;
  final String? errorMessage;

  const SignInState({
    this.phone,
    this.username,
    this.password,
    this.hidePassword = true,
    //
    this.status = BlocStatus.initial,
    this.authData,
    this.errorMessage,
  });

  PhoneNumberValidation get phoneValidator =>
      PhoneNumberValidation.dirty(value: phone ?? '');
  RequiredFieldValidation get usernameValidator =>
      RequiredFieldValidation.dirty(value: username ?? '');
  RequiredFieldValidation get passwordValidator =>
      RequiredFieldValidation.dirty(value: password ?? '');

  String? get phoneErrorText =>
      phone != null ? phoneValidator.error?.message.tr() : null;
  String? get usernameErrorText =>
      username != null ? usernameValidator.error?.message.tr() : null;
  String? get passwordErrorText =>
      password != null ? passwordValidator.error?.message.tr() : null;

  String get error => errorMessage ?? "";

  bool get isFormValid => Formz.validate([
        phoneValidator,
        usernameValidator,
        passwordValidator,
      ]);

  @override
  List<Object?> get props => [
        phone,
        username,
        password,
        hidePassword,
        status,
        authData,
        errorMessage,
      ];

  SignInState copyWith({
    String? phone,
    String? username,
    String? password,
    bool? hidePassword,
    BlocStatus? requestStatus,
    AuthData? authData,
    String? errorMessage,
  }) {
    return SignInState(
      phone: phone ?? this.phone,
      username: username ?? this.username,
      password: password ?? this.password,
      hidePassword: hidePassword ?? this.hidePassword,
      status: requestStatus ?? status,
      authData: authData ?? this.authData,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return 'SignInState(phone: $phone, username: $username, password: $password, hidePassword: $hidePassword, requestStatus: $status, authData: $authData, errorMessage: $errorMessage)';
  }
}
