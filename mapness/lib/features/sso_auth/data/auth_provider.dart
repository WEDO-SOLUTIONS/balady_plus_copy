import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  Future<void> doAuth() async {
    await CommonFunctions.onLogin();
    ref.invalidateSelf();
  }

  Future<void> logOut() async {
    await sl<EntryPointCubit>().clearAuth();
    ref.invalidateSelf();
  }

  @override
  Future<SsoUserInfo?> build() async {
    if (CommonProperties.isLoggedIn) {
      await sl<EntryPointCubit>().refreshSSOProfile();
      await Future.delayed(const Duration(milliseconds: 250));
    }

    return CommonProperties.userInfo;
  }
}
