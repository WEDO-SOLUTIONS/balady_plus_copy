import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:mapness/entry_point.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  Future<void> doAuth() async {
    mixpanel?.timeEvent("Auth: doAuth");
    await CommonFunctions.onLogin();
    ref.invalidateSelf();
    mixpanel?.track("Auth: doAuth");
  }

  Future<void> logOut() async {
    mixpanel?.timeEvent("Auth: logOut");
    await sl<EntryPointCubit>().clearAuth();
    ref.invalidateSelf();
    mixpanel?.track("Auth: logOut");
    mixpanel?.reset();
  }

  Future<void> tokenExpireLogout() async {
    mixpanel?.timeEvent("Auth: tokenExpireLogout");
    await sl<EntryPointCubit>().autoLogout();
    ref.invalidateSelf();
    mixpanel?.track("Auth: logtokenExpireLogoutOut");
  }

  @override
  Future<SsoUserInfo?> build() async {
    if (CommonProperties.isLoggedIn) {
      await sl<EntryPointCubit>().refreshSSOProfile();
      await Future.delayed(const Duration(milliseconds: 250));
    }

    final authSubscription = sl<EntryPointCubit>().stream.listen((event) {
      state = AsyncValue.data(event.userInfo);
    });
    ref.onDispose(() {
      authSubscription.cancel();
    });

    mixpanel?.identify("${CommonProperties.userInfo?.idNo}");
    return CommonProperties.userInfo;
  }
}
