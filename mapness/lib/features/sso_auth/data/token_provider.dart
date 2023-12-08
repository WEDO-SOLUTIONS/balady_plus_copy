import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:mapness/features/sso_auth/data/sso_config.dart';
import 'package:mapness/features/sso_auth/domain/entity/sso_token_info.dart';
import 'package:mapness/features/sso_auth/domain/mappers/auth_token_response.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';

part 'token_provider.g.dart';

@riverpod
class Token extends _$Token {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  final AuthorizationServiceConfiguration _serviceConfiguration =
      const AuthorizationServiceConfiguration(
    authorizationEndpoint: '${SsoConfig.ssoUrl}/authorize',
    tokenEndpoint: '${SsoConfig.ssoUrl}/token',
    endSessionEndpoint: "${SsoConfig.ssoUrl}/endsession",
  );

  Future<void> authorization() async {
    AuthorizationTokenResponse? response =
        await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        SsoConfig.ssoClient,
        SsoConfig.ssoRedirectUrl,
        serviceConfiguration: _serviceConfiguration,
        clientSecret: SsoConfig.ssoSecret,
        scopes: [
          'openid',
          'profile',
          'offline_access',
          'EmployeeAdminstration.Api',
        ],
      ),
    );

    state = AsyncData(response?.toDomain);
  }

  Future<void> refreshToken(String refreshToken) async {
    TokenResponse? response = await _appAuth.token(
      TokenRequest(
        SsoConfig.ssoClient,
        SsoConfig.ssoRedirectUrl,
        serviceConfiguration: _serviceConfiguration,
        refreshToken: refreshToken,
        clientSecret: SsoConfig.ssoSecret,
        scopes: [
          'openid',
          'profile',
          'offline_access',
        ],
      ),
    );

    state = AsyncData(response?.toDomain);
  }

  void logOut() {
    state = const AsyncData(null);
  }

  Future<SsoTokenInfo?> get tokenInfo async {
    final profileBox = await ref.read(hiveProvider('profile_info').future);
    final tokenJson = profileBox.get('token');
    if (tokenJson == null) return null;
    return SsoTokenInfo.fromMap(jsonDecode(tokenJson));
  }

  @override
  Future<SsoTokenInfo?> build() async {
    return Future.value(tokenInfo);
  }
}
