import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:mapness/features/sso_auth/domain/entity/sso_token_info.dart';

extension AuthTokenResponseFromEntity on AuthorizationTokenResponse {
  SsoTokenInfo get toDomain => SsoTokenInfo(
        token: accessToken,
        refreshToken: refreshToken,
        expirationTime: accessTokenExpirationDateTime?.millisecondsSinceEpoch.toString(),
        idToken: idToken,
      );
}

extension TokenResponseFromEntity on TokenResponse {
  SsoTokenInfo get toDomain => SsoTokenInfo(
        token: accessToken,
        refreshToken: refreshToken,
        expirationTime: accessTokenExpirationDateTime?.millisecondsSinceEpoch.toString(),
        idToken: idToken,
      );
}
