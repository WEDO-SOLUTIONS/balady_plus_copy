import 'package:dio/dio.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_config.dart';
import 'package:mapness/shared/providers/uuid_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_service_token.g.dart';

const String _prefsKey = 'friends_on_map_service_token';

/// Also written by [FriendsOnMapServiceToken.build] — read by
/// `providers/friends_on_map_account_id.dart`. This is the server-assigned
/// account id (`acc.ID` on the backend), the exact value a friend's device
/// receives as `Friend.id` — distinct from both the token above and the raw
/// device [uuidProviderProvider] sent as `username`. Public (not `_`-prefixed)
/// so that sibling provider can read it without duplicating the string.
const String friendsOnMapAccountIdPrefsKey = 'friends_on_map_account_id';

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
    final cachedToken = prefs.getString(_prefsKey);
    final cachedAccountId = prefs.getString(friendsOnMapAccountIdPrefsKey);
    // Both must be cached, not just the token — an install that logged in
    // before the account id was added to the login response would otherwise
    // never fetch it. Re-login is safe: the mock server's login is
    // idempotent per username (same username always resolves to the same
    // account), so this never creates a duplicate account.
    if (cachedToken != null && cachedAccountId != null) {
      return cachedToken;
    }

    final uuid = ref.watch(uuidProviderProvider);
    final dio = Dio(BaseOptions(baseUrl: friendsOnMapApiBaseUrl));
    final response = await dio.post<Map<String, dynamic>>('/test/login', data: {'username': uuid});
    final token = response.data!['token'] as String;
    final accountId = response.data!['accountId'] as String;
    await prefs.setString(_prefsKey, token);
    await prefs.setString(friendsOnMapAccountIdPrefsKey, accountId);
    return token;
  }
}
