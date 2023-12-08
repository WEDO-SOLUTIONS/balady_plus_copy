import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapness/_features/common/providers/user_state.dart';
import 'package:mapness/features/sso_auth/data/sso_config.dart';
import 'package:mapness/features/sso_auth/data/token_provider.dart';
import 'package:mapness/features/sso_auth/domain/entity/sso_token_info.dart';
import 'package:mapness/features/sso_auth/domain/entity/sso_user_info_model.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  static const _profileStoreBox = 'profile_info';

  Box<dynamic>? _profileBox;

  Future<SsoUserInfoModel?> getSsoProfile(SsoTokenInfo response) async {
    final dio = Dio();
    const ssoUserInfo = '${SsoConfig.ssoUrl}${SsoConfig.ssoUserInfo}';
    final responseData = await dio.get(ssoUserInfo,
        options: Options(
            headers: {'Authorization': 'Bearer ${response.token ?? ''}'}));

    var data = responseData.data;

    ref.read(userStateProvider.notifier).update(UserState.personal);

    _profileBox ??= await ref.read(hiveProvider(_profileStoreBox).future);

    _profileBox?.put('isAuthorized', true);
    _profileBox?.put('profile', jsonEncode(data));
    _profileBox?.put('token', jsonEncode(response.toJson()));

    return SsoUserInfoModel.fromJson(data);
  }

  Future<SsoUserInfoModel?> getProfile() async {
    _profileBox ??= await ref.read(hiveProvider(_profileStoreBox).future);

    final profile = _profileBox?.get('profile', defaultValue: '{}');

    if (profile != null) {
      ref.read(userStateProvider.notifier).update(UserState.personal);
      return SsoUserInfoModel.fromJson(jsonDecode(profile));
    }

    return null;
  }

  Future<void> doAuth() async {
    try {
      await ref.read(tokenProvider.notifier).authorization();
      final token = await ref.read(tokenProvider.future);
      if (token != null) {
        await getSsoProfile(token);
      }
    } catch (_) {}
  }

  Future<void> logOut() async {
    _profileBox ??= await ref.read(hiveProvider(_profileStoreBox).future);
    await _profileBox?.clear();
    ref.read(tokenProvider.notifier).logOut();

    state = const AsyncData(null);
  }

  @override
  Future<SsoUserInfoModel?> build() async {
    try {
      _profileBox ??= await ref.watch(hiveProvider(_profileStoreBox).future);

      if (_profileBox?.get('isAuthorized', defaultValue: false) == true) {
        return await getProfile();
      }

      final tokenData = ref.watch(tokenProvider);

      if (tokenData.value?.getExpirationTime()?.isBefore(DateTime.now()) ==
          true) {
        await ref.read(tokenProvider.notifier).refreshToken(
              tokenData.requireValue?.refreshToken ?? '',
            );
      }
      if (!tokenData.hasValue && tokenData.value == null) return null;

      return await getSsoProfile(tokenData.requireValue!);
    } catch (_) {}
    return null;
  }
}
