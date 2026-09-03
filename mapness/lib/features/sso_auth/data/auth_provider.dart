import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart' show sl;
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/profile/profile_image_provider.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  Future<void> doAuth() async {
    mixpanel?.timeEvent('Auth: doAuth');
    await CommonFunctions.onLogin();
    ref.invalidateSelf();
    await mixpanel?.track('Auth: doAuth');

    // Notify the map about authorization change
    await notifyAuthorizationChange(isAuthorized: true);
  }

  Future<void> logOut() async {
    mixpanel?.timeEvent('Auth: logOut');
    await ref.read(profileImageProvider.notifier).clear();

    /// Urbi Tame Need Fix It
    try {
      await ref.read(favouriteCacheProvider.notifier).clear();
      // Avoid auth<->favourites circular dependency during logout.
      ref.invalidate(favouriteCacheProvider);
    } catch (e) {
      logger.log(e.toString());
    }
    await sl<EntryPointCubit>().clearAuth();
    await reconcileSearchHistoryIdentity(ref, identity: visitorSearchHistoryIdentity);
    ref.invalidateSelf();
    await mixpanel?.track('Auth: logOut');
    await mixpanel?.reset();
    BaladyAnalytics.instance.resetIdentity();

    // Notify the map about authorization change
    await notifyAuthorizationChange(isAuthorized: false);
  }

  Future<void> tokenExpireLogout() async {
    mixpanel?.timeEvent('Auth: tokenExpireLogout');
    await ref.read(profileImageProvider.notifier).clear();
    await sl<EntryPointCubit>().autoLogout();
    await reconcileSearchHistoryIdentity(ref, identity: visitorSearchHistoryIdentity);
    ref.invalidateSelf();
    await mixpanel?.track('Auth: logtokenExpireLogoutOut');

    // Notify the map about authorization change
    await notifyAuthorizationChange(isAuthorized: false);
  }

  @override
  Future<SsoUserInfo?> build() async {
    if (CommonProperties.isLoggedIn) {
      await sl<EntryPointCubit>().refreshSSOProfile();
      //Refresh user avatar
      ref.invalidate(profileImageProvider);
      await Future.delayed(const Duration(milliseconds: 250));
    }

    bool disposed = false;
    ref.onDispose(() => disposed = true);

    final authSubscription = sl<EntryPointCubit>().stream.listen((event) {
      // TODO: When authorized send it to [authorizedNotifier]
      final previousUserInfo = state.value;
      final newUserInfo = event.userInfo;

      // Check if authorization state changed
      final wasAuthorized = previousUserInfo != null;
      final isAuthorized = newUserInfo != null;

      if (wasAuthorized != isAuthorized) {
        // Authorization state changed, notify the map
        notifyAuthorizationChange(isAuthorized: isAuthorized);
      }

      state = AsyncValue.data(newUserInfo);

      // defer the cascade invalidations to the next event-loop
      // tick. EntryPointCubit's stream replays its current state on every
      // new subscription; that replay arrives while [favouriteCacheProvider]
      // is still awaiting our `.future` inside its build, and invalidating
      // it synchronously re-enters its own build stack →
      // [CircularDependencyError]. Deferring lets the in-flight build
      // settle before downstream rebuilds are triggered.
      Future(() {
        if (disposed) return;
        try {
          ref
            ..invalidate(favouriteCacheProvider)
            ..invalidate(profileImageProvider)
            ..invalidate(authMethodsProvider);
        } catch (_) {
          // Ref disposed between scheduling and execution — nothing to do.
        }
        reconcileSearchHistoryIdentity(ref, identity: _searchHistoryIdentity(newUserInfo)).ignore();
      });
    });
    ref.onDispose(authSubscription.cancel);

    final userId = CommonProperties.userInfo?.idNo;
    // Identify only a real session. Passing null here meant logout to the
    // analytics facade — every cold start of a logged-out app called reset(),
    // minting a fresh anonymous distinct_id (a "new user" per launch). Reset
    // belongs to the explicit logOut() path only. Mixpanel had the twin bug:
    // '$userId' stringified null into the literal user "null".
    if (userId != null) {
      await mixpanel?.identify(userId);
      BaladyAnalytics.instance.identify(userId: userId);
    }
    return CommonProperties.userInfo;
  }

  Future<void> forceUpdate() async {
    await sl<EntryPointCubit>().refreshSSOProfile();
    final data = sl<EntryPointCubit>().state.userInfo;
    state = AsyncValue.data(data);
  }

  /// Pushes profile changes from `/api/user/userinfo` to the app-wide auth state.
  /// Used after OTP profile edits (refreshSSOProfile only updates municipality SSO).
  Future<void> updateUserInfo(SsoUserInfo userInfo) async {
    await sl<EntryPointCubit>().applyUserInfo(userInfo);
    state = AsyncValue.data(userInfo);
  }

  String _searchHistoryIdentity(SsoUserInfo? userInfo) =>
      userInfo?.sub ?? userInfo?.idNo ?? visitorSearchHistoryIdentity;

  Future<void> notifyAuthorizationChange({required bool isAuthorized}) async {
    // This method will be called when authorization state changes
    // It will trigger the authorizationNotification method in the map
    // to update CarPlay and Android Auto states
    // The actual auth state is managed by the existing methods
    // This is just for notification purposes

    try {
      // Get the map controller and call authorizationNotification
      final dgisController = await ref.read(dgisControllerProvider.future);
      await dgisController.authorizationNotification(isAuthorized: isAuthorized);
      logger.log('Authorization notification sent to map: $isAuthorized');
    } catch (e) {
      // If the map controller is not available, just log the change
      logger.log('Authorization state changed: $isAuthorized (map notification failed: $e)');
    }
  }
}
