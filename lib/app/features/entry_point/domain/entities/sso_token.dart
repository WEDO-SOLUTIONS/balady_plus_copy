import 'package:equatable/equatable.dart';

class SSOToken extends Equatable {
  final String? token;
  final String? idToken;
  final String? refreshToken;
  final String? expirationTime;
  String? appCookie;
  SSOToken({this.expirationTime, this.refreshToken, this.token, this.idToken, this.appCookie});

  DateTime? getExpirationTime() => DateTime.tryParse(expirationTime ?? "");

  @override
  List<Object?> get props => [token, appCookie, refreshToken, idToken];
}
