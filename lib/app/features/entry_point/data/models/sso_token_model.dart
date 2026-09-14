import '../../entry_point_exports.dart';

class SSOTokenModel extends SSOToken {
  const SSOTokenModel({super.expirationTime, super.refreshToken, super.token, super.idToken, super.appCookie});

  factory SSOTokenModel.fromMap(Map<String, dynamic> json) => SSOTokenModel(
    expirationTime: json["expirationTime"],
    refreshToken: json["refreshToken"],
    token: json["token"],
    idToken: json["idToken"],
    appCookie: json["appCookie"],
  );

  Map<String, dynamic> toJson() {
    return {
      "expirationTime": expirationTime,
      "refreshToken": refreshToken,
      "token": token,
      "idToken": idToken,
      "appCookie": appCookie,
    };
  }
}

extension SSOTokenModelFromEntity on SSOToken {
  SSOTokenModel get toModel => SSOTokenModel(
    expirationTime: expirationTime,
    refreshToken: refreshToken,
    token: token,
    idToken: idToken,
    appCookie: appCookie,
  );
}
