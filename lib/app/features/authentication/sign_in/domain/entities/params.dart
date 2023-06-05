import '../../sign_in_exports.dart' show SignInParamsModel;

class SignInParams extends SignInParamsModel {
  const SignInParams({
    super.phoneNumber = '',
    super.username = '',
    super.password = '',
  });

  SignInParams copyWith({
    String? phoneNumber,
    String? username,
    String? password,
  }) {
    return SignInParams(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  String toString() =>
      'SignInParams(phoneNumber: $phoneNumber, username: $username, password: $password)';
}
