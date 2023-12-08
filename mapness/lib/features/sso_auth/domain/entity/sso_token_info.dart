class SsoTokenInfo {
  final String? token;
  final String? idToken;
  final String? refreshToken;
  final String? expirationTime;
  String? appCookie;

  SsoTokenInfo(
      {this.expirationTime,
      this.refreshToken,
      this.token,
      this.idToken,
      this.appCookie});

  DateTime? getExpirationTime() => DateTime.tryParse(expirationTime ?? "");

  Map<String, dynamic> toJson() {
    return {
      "expirationTime": expirationTime,
      "refreshToken": refreshToken,
      "token": token,
      "idToken": idToken,
      "appCookie": appCookie
    };
  }

  factory SsoTokenInfo.fromMap(Map<String, dynamic> json) => SsoTokenInfo(
      expirationTime: json["expirationTime"],
      refreshToken: json["refreshToken"],
      token: json["token"],
      idToken: json["idToken"],
      appCookie: json["appCookie"]);
}
