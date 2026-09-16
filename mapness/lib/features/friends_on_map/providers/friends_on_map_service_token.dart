import 'package:dio/dio.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_config.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_service_token.g.dart';

const String _prefsKey = 'friends_on_map_service_token';

/// The real Friends on Map backend has no real SSO — it only understands its
/// own test login (`POST /test/login {username}` → a token that's stable
/// per username, see `~/Downloads/friends-on-map/GO_BACKEND_SPEC.md`). The
/// app's real `AuthTokenInterceptor`/`tokenProvider` bearer can't be
/// validated by it at all, so a second, independent identity is bootstrapped
/// here instead — keyed by this device's own persisted [uuidProviderProvider]
/// (not any real user identity) so two installs act as two distinct test
/// accounts and the same install is stable across restarts. Cached in
/// SharedPreferences once obtained, since the mock server's own login is
/// idempotent per username but there's no reason to round-trip it on every
/// app start.
@Riverpod(keepAlive: true)
class FriendsOnMapServiceToken extends _$FriendsOnMapServiceToken {
  @override
  Future<String> build() async {
    final prefs = ref.watch(sharedPrefsProvider);
    final cached = prefs.getString(_prefsKey);
    if (cached != null) {
      return cached;
    }

    final uuid = ref.watch(uuidProviderProvider);
    final dio = Dio(BaseOptions(baseUrl: friendsOnMapApiBaseUrl));
    final response = await dio.post<Map<String, dynamic>>('/test/login', data: {'username': uuid});
    final token = response.data!['token'] as String;
    await prefs.setString(_prefsKey, token);
    return token;
  }
}
