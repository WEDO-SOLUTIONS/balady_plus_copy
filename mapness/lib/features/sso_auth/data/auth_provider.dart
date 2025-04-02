import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart' show sl;
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/profile/profile_image_provider.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  Future<void> doAuth() async {
    Metrics.logEvent('Auth/doAuth');
    mixpanel?.timeEvent('Auth: doAuth');
    await CommonFunctions.onLogin();
    ref.invalidateSelf();
    await mixpanel?.track('Auth: doAuth');
  }

  Future<void> logOut() async {
    Metrics.logEvent('Auth/logOut');
    mixpanel?.timeEvent('Auth: logOut');
    await ref.read(profileImageProvider.notifier).clear();
    await sl<EntryPointCubit>().clearAuth();
    ref.invalidateSelf();
    await mixpanel?.track('Auth: logOut');
    await mixpanel?.reset();
    await FlutterUxcam.setUserIdentity(null);
  }

  Future<void> tokenExpireLogout() async {
    Metrics.logEvent('Auth/tokenExpireLogout');
    mixpanel?.timeEvent('Auth: tokenExpireLogout');
    await sl<EntryPointCubit>().autoLogout();
    ref.invalidateSelf();
    await mixpanel?.track('Auth: logtokenExpireLogoutOut');
  }

  @override
  Future<SsoUserInfo?> build() async {
    if (CommonProperties.isLoggedIn) {
      await sl<EntryPointCubit>().refreshSSOProfile();
      //Refresh user avatar
      ref.invalidate(profileImageProvider);
      await Future.delayed(const Duration(milliseconds: 250));
    }

    final authSubscription = sl<EntryPointCubit>().stream.listen((event) {
      // TODO: !!! temporary authorization state for testing, remove before release !!!
      state = AsyncValue.data(SsoUserInfo(name: 'for test') /*event.userInfo*/);
      ref
        ..invalidate(favouriteCacheProvider)
        ..invalidate(profileImageProvider)
        ..invalidate(authMethodsProvider);
    });
    ref.onDispose(authSubscription.cancel);

    final userId = CommonProperties.userInfo?.idNo;
    await mixpanel?.identify('$userId');

    await FlutterUxcam.setUserIdentity(userId);
    // TODO: !!! temporary authorization state for testing, remove before release !!!
    return SsoUserInfo(name: 'for test'); /*CommonProperties.userInfo*/;
  }

  Future<void> forceUpdate() async {
    await sl<EntryPointCubit>().refreshSSOProfile();
    final data = sl<EntryPointCubit>().state.userInfo;
    // TODO: !!! temporary authorization state for testing, remove before release !!!
    state = AsyncValue.data(SsoUserInfo(name: 'for test') /*data*/);
  }
}
