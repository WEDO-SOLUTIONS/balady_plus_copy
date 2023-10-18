import 'package:equatable/equatable.dart' show Equatable;

//! Add accessToken for default, it founded in any logic
//! but you will add more info
class AuthData extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final String username;
  final String issued;
  final String expires;

  const AuthData({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.username,
    required this.issued,
    required this.expires,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
        username,
        issued,
        expires,
      ];

  AuthData copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    String? username,
    String? issued,
    String? expires,
  }) {
    return AuthData(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      username: username ?? this.username,
      issued: issued ?? this.issued,
      expires: expires ?? this.expires,
    );
  }

  @override
  String toString() {
    return 'AuthData(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, username: $username, issued: $issued, expires: $expires)';
  }
}
