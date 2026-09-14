import 'package:equatable/equatable.dart';

class SSOToken extends Equatable {
  final String? token;
  final String? idToken;
  final String? refreshToken;
  final String? expirationTime;
  final String? appCookie;
  const SSOToken({this.expirationTime, this.refreshToken, this.token, this.idToken, this.appCookie});

  SSOToken copyWith({
    String? token,
    String? idToken,
    String? refreshToken,
    String? expirationTime,
    String? appCookie,
  }) => SSOToken(
    token: token ?? this.token,
    idToken: idToken ?? this.idToken,
    refreshToken: refreshToken ?? this.refreshToken,
    expirationTime: expirationTime ?? this.expirationTime,
    appCookie: appCookie ?? this.appCookie,
  );

  DateTime? getExpirationTime() => DateTime.tryParse(expirationTime ?? "");

  @override
  List<Object?> get props => [token, appCookie, refreshToken, idToken];
}
