// ignore_for_file: argument_type_not_assignable
// ignore_for_file: avoid_dynamic_calls
// ignore_for_file: not_assigned_potentially_non_nullable_local_variable

class SsoTokenInfo {
  SsoTokenInfo({
    this.expirationTime,
    this.refreshToken,
    this.token,
    this.idToken,
    this.appCookie,
  });

  factory SsoTokenInfo.fromMap(Map<String, dynamic> json) => SsoTokenInfo(
        expirationTime: json['expirationTime'],
        refreshToken: json['refreshToken'],
        token: json['token'],
        idToken: json['idToken'],
        appCookie: json['appCookie'],
      );
  final String? token;
  final String? idToken;
  final String? refreshToken;
  final String? expirationTime;
  String? appCookie;

  DateTime? getExpirationTime() => DateTime.tryParse(expirationTime ?? '');

  Map<String, dynamic> toJson() => {
        'expirationTime': expirationTime,
        'refreshToken': refreshToken,
        'token': token,
        'idToken': idToken,
        'appCookie': appCookie,
      };
}
