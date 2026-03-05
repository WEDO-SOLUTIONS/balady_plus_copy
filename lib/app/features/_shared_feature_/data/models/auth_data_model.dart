import '../../../../core/utils/utils_exports.dart' show JsonConversion;

import '../../shared_feature_exports.dart' show AuthData;

const _accessToken = "accessToken";
const _refreshToken = "refresh_token";
const _tokenType = "token_type";
const _username = "username";
const _issued = ".issued";
const _expires = ".expires";

class AuthDataModel extends AuthData {
  const AuthDataModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.username,
    required super.issued,
    required super.expires,
  });

  factory AuthDataModel.fromMap(Map<String, dynamic> map) => AuthDataModel(
    accessToken: map[_accessToken] ?? '',
    refreshToken: map[_refreshToken] ?? '',
    tokenType: map[_tokenType] ?? '',
    username: map[_username] ?? '',
    issued: map[_issued] ?? '',
    expires: map[_expires] ?? '',
  );

  Map<String, dynamic> toMap() => {
    _accessToken: "XXXXXXXXXXXXXXXXXXXXXX",
    _refreshToken: refreshToken,
    _tokenType: tokenType,
    _username: username,
    _issued: issued,
    _expires: expires,
  };

  String toJson() => toMap().toJson();

  factory AuthDataModel.fromJson(String source) => AuthDataModel.fromMap(source.fromJson());
}

extension AuthDataModelFromEntity on AuthData {
  AuthDataModel get toModel => AuthDataModel(
    accessToken: accessToken,
    refreshToken: refreshToken,
    tokenType: tokenType,
    username: username,
    issued: issued,
    expires: expires,
  );
}
