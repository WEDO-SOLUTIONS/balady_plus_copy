import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:mapness/_features/common/providers/user_state.dart';
import 'package:mapness/features/sso_auth/data/sso_config.dart';
import 'package:mapness/features/sso_auth/domain/entity/sso_user_info_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  final FlutterAppAuth _appAuth = FlutterAppAuth();

  final AuthorizationServiceConfiguration _serviceConfiguration =
      const AuthorizationServiceConfiguration(
    authorizationEndpoint: '${SsoConfig.ssoUrl}/authorize',
    tokenEndpoint: '${SsoConfig.ssoUrl}/token',
    endSessionEndpoint: "${SsoConfig.ssoUrl}/endsession",
  );

  Future<void> doAuth() async {
    try {
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

      final dio = Dio();
      const ssoUserInfo = '${SsoConfig.ssoUrl}${SsoConfig.ssoUserInfo}';
      final responseData = await dio.get(ssoUserInfo,
          options: Options(headers: {
            "Authorization": "Bearer ${response?.accessToken ?? ''}"
          }));

      var data = responseData.data;

      final user = SsoUserInfoModel.fromJson(data);
      state = user;
      ref.read(userStateProvider.notifier).update(UserState.personal);
    } catch (_) {}
  }

  @override
  SsoUserInfoModel? build() {
    return null;
  }
}
