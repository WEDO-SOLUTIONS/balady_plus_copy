import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:mapness/features/sso_auth/domain/entity/sso_token_info.dart';
import 'package:mapness/features/sso_auth/domain/mappers/auth_token_response.dart';
import 'package:mapness/shared/providers/dgis_envirement.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_provider.g.dart';

@riverpod
class Token extends _$Token {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  Future<void> authorization() async {
    final ssoConfig = ref.read(dgisEnvirementProvider).sso;

    AuthorizationTokenResponse? response =
        await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        ssoConfig.ssoClient,
        ssoConfig.ssoRedirectUrl,
        serviceConfiguration: AuthorizationServiceConfiguration(
          authorizationEndpoint: '${ssoConfig.ssoUrl}/authorize',
          tokenEndpoint: '${ssoConfig.ssoUrl}/token',
          endSessionEndpoint: '${ssoConfig.ssoUrl}/endsession',
        ),
        clientSecret: ssoConfig.ssoSecret,
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
    final ssoConfig = ref.read(dgisEnvirementProvider).sso;

    TokenResponse? response = await _appAuth.token(
      TokenRequest(
        ssoConfig.ssoClient,
        ssoConfig.ssoRedirectUrl,
        serviceConfiguration: AuthorizationServiceConfiguration(
          authorizationEndpoint: '${ssoConfig.ssoUrl}/authorize',
          tokenEndpoint: '${ssoConfig.ssoUrl}/token',
          endSessionEndpoint: '${ssoConfig.ssoUrl}/endsession',
        ),
        refreshToken: refreshToken,
        clientSecret: ssoConfig.ssoSecret,
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
