import 'package:equatable/equatable.dart' show Equatable;

//! Add accessToken for default, it founded in any logic
//! but you will add more info
class AuthData extends Equatable {
  final String accessToken;

  const AuthData({required this.accessToken});

  @override
  List<Object?> get props => [accessToken];

  AuthData copyWith({
    String? accessToken,
  }) {
    return AuthData(
      accessToken: accessToken ?? this.accessToken,
    );
  }

  @override
  String toString() => 'AuthData(accessToken: $accessToken)';
}
