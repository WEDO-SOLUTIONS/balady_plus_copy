import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/sso_auth/data/token_provider.dart';
import 'package:mapness/features/tifo/data/tifo_debug_identity.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';

/// Debug-only overrides for the TIFO backend. Empty fields fall back to the
/// system config. Applied ONLY when [tifoDebugModeProvider] is on — in normal
/// operation the feature ignores these and uses system auth + env base URL.
///
/// The user id override lives separately in [tifoDebugIdentityProvider]: it is
/// persisted and has its own saved-ids picker, so it must not be duplicated
/// here.
@immutable
class TifoConfig {
  const TifoConfig({this.baseUrl = ''});

  final String baseUrl;

  TifoConfig copyWith({String? baseUrl}) => TifoConfig(baseUrl: baseUrl ?? this.baseUrl);
}

class TifoDebugConfigController extends Notifier<TifoConfig> {
  @override
  TifoConfig build() => const TifoConfig();

  void setBaseUrl(String value) => state = state.copyWith(baseUrl: value.trim());
}

final tifoDebugConfigProvider = NotifierProvider<TifoDebugConfigController, TifoConfig>(
  TifoDebugConfigController.new,
);

/// Master switch: when false (default, and always in production) the TIFO debug
/// config is ignored — the feature authenticates with the system SSO token and
/// hits the environment's base URL. Flip on only in the debug panel to override.
class TifoDebugModeController extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final tifoDebugModeProvider = NotifierProvider<TifoDebugModeController, bool>(TifoDebugModeController.new);

/// Known-staging fallback — used only when [dgisEnvironmentProvider] hasn't
/// resolved yet (e.g. Hive/config not loaded), and as the debug-panel
/// default. The real per-flavor base URL is derived in [resolveTifoConfig]
/// below from the active environment's `url`, same host as the rest of
/// urbi-lifestyle, with the TIFO path appended.
const kTifoBaseUrl = 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/tifo';

/// Sent as `x-api-key` on every request made WITHOUT a bearer (signed out) —
/// every endpoint accepts either credential, returning its unauthenticated
/// default response for the API key instead of 401ing (`/me` returns a
/// generic profile, `/tutorial/complete` returns `{ok: true}` without
/// persisting, etc. — see the TIFO API reference). Never sent alongside a
/// bearer: a real session always takes priority.
const _tifoGuestApiKey = 'd5104482-948a-49c5-acc1-86bd75e57a2f';

/// The effective TIFO base URL + bearer, resolved per request.
///
/// Base URL follows [dgisEnvironmentProvider] — i.e. it changes with the
/// build flavor (dev/staging/prod), same host as the rest of urbi-lifestyle,
/// `/1.0/api/v1/tifo` appended. Bearer is the RAW system SSO access token
/// (`tokenProvider`/`CommonProperties.token`) as-is — no hashing, no guest
/// fallback — or empty when signed out. Debug overrides only win when
/// [tifoDebugModeProvider] is on. [TifoResolvedConfig.isGuest] is true when
/// the bearer is empty (signed out).
typedef TifoResolvedConfig = ({String baseUrl, String token, bool isGuest});

Future<TifoResolvedConfig> resolveTifoConfig(Ref ref) async {
  final debug = ref.read(tifoDebugModeProvider);
  final override = debug ? ref.read(tifoDebugConfigProvider) : const TifoConfig();

  var baseUrl = override.baseUrl;
  if (baseUrl.isEmpty) {
    try {
      final env = await ref.read(dgisEnvironmentProvider.future);
      baseUrl = '${Uri.parse(env.url).origin}/1.0/api/v1/tifo';
    } catch (_) {
      // Env config not ready/failed to load — known-staging fallback rather
      // than leaving the game unreachable.
      baseUrl = kTifoBaseUrl;
    }
  }

  // Debug panel "act as another user": the id IS the bearer on staging, so
  // this is the whole mechanism. Treated as signed in — the tester wants the
  // full player flow, not the guest one.
  final identity = ref.read(tifoDebugIdentityProvider);
  if (identity.isActive) {
    return (baseUrl: baseUrl, token: identity.userId, isGuest: false);
  }

  try {
    // Triggers the provider's expiry check/refresh side effect; its cached
    // value is NOT trusted below.
    await ref.read(tokenProvider.future);
  } catch (_) {
    // No session — fall through to the empty bearer below.
  }
  // Read the LIVE cubit value, not the provider cache: the cache is fed by
  // a stream subscription that can outlive a logout.
  final token = CommonProperties.token;
  // Only the raw system SSO token, or empty when signed out — no idNo/sub
  // hashing, no guest device-id fallback.
  return (baseUrl: baseUrl, token: token, isGuest: token.isEmpty);
}

/// Collects the network round-trip of the TIFO requests feeding ONE surface, so
/// `tifo_surface_viewed` can report a combined `api_ms` (e.g. district tier = `/districts` +
/// `/districts/summary`). Only the dio call is timed — not token resolution or parsing.
class TifoRequestTiming {
  Duration _total = Duration.zero;
  int _calls = 0;

  /// Sum of every recorded round-trip, or null when no request was made — a
  /// surface served entirely from cache reports no `api_ms` rather than 0.
  Duration? get total => _calls == 0 ? null : _total;

  int? get totalMs => total?.inMilliseconds;

  void add(Duration value) {
    _total += value;
    _calls++;
  }
}

/// Thrown for non-2xx responses so callers can surface the backend's message.
class TifoApiException implements Exception {
  TifoApiException(this.statusCode, this.message);

  final int? statusCode;
  final String message;

  @override
  String toString() => 'TifoApiException($statusCode): $message';
}

class TifoApi {
  TifoApi(this._resolve, {String Function() localeCode = _defaultLocaleCode}) : _localeCode = localeCode;

  static String _defaultLocaleCode() => 'en';

  final Future<TifoResolvedConfig> Function() _resolve;

  /// Backend locale code (`en`/`ar`) sent on every request — resolves the
  /// app's current language so responses (e.g. club names) come back
  /// localized instead of always English.
  final String Function() _localeCode;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Options _options(String token) => Options(
    headers: {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token' else 'x-api-key': _tifoGuestApiKey,
    },
  );

  String _url(String baseUrl, String path) {
    final sep = path.contains('?') ? '&' : '?';
    return '$baseUrl$path${sep}locale=${_localeCode()}';
  }

  /// `GET /buildings?bbox=minLng,minLat,maxLng,maxLat`. [cancelToken] lets the
  /// map layer abort a stale viewport request when the camera moves again.
  Future<List<TifoBuilding>> getBuildings(String bbox, {CancelToken? cancelToken, TifoRequestTiming? timing}) async {
    final res = await _get('/buildings?bbox=$bbox', cancelToken: cancelToken, timing: timing);
    final items = (res['items'] as List?) ?? const [];
    final buildings = <TifoBuilding>[];
    for (final item in items) {
      if (item is Map) {
        final building = TifoBuilding.fromJson(item.cast<String, dynamic>());
        if (building != null) {
          buildings.add(building);
        }
      }
    }
    return buildings;
  }

  /// Batch state refresh for known building ids (`POST /buildings/by-ids`,
  /// ≤500). Same shape as `/buildings`; used by the polling service to refresh
  /// ownership/status without re-fetching geometry per viewport.
  Future<List<TifoBuilding>> getBuildingsByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return const [];
    }
    final res = await _post('/buildings/by-ids', body: {'ids': ids});
    final out = <TifoBuilding>[];
    for (final item in (res['items'] as List?) ?? const []) {
      if (item is Map) {
        final b = TifoBuilding.fromJson(item.cast<String, dynamic>());
        if (b != null) {
          out.add(b);
        }
      }
    }
    return out;
  }

  Future<TifoProfile> getMe({TifoRequestTiming? timing}) async =>
      TifoProfile.fromJson(await _get('/me', timing: timing));

  /// The base URL + bearer this client would send right now. Exposed so the
  /// debug console can issue requests as the app rather than guessing.
  Future<TifoResolvedConfig> resolveNow() => _resolve();

  /// Whether requests are currently running on the guest device bearer (no
  /// host SSO session). See [resolveTifoConfig] for why the profile alone
  /// can't answer this.
  Future<bool> isGuestSession() async => (await _resolve()).isGuest;

  Future<List<TifoClubInfo>> getClubs() async {
    final res = await _get('/clubs');
    final clubs = <TifoClubInfo>[];
    for (final item in (res['clubs'] as List?) ?? const []) {
      if (item is Map) {
        final club = TifoClubInfo.fromJson(item.cast<String, dynamic>());
        if (club != null) {
          clubs.add(club);
        }
      }
    }
    return clubs;
  }

  Future<TifoGameConfig> getConfig() async => TifoGameConfig.fromJson(await _get('/config'));

  /// Club standings for the leaderboard (`GET /leaderboards?scope=clubs`).
  Future<List<TifoLeaderRow>> getLeaderboards({TifoRequestTiming? timing}) async {
    final res = await _get('/leaderboards?scope=clubs', timing: timing);
    final out = <TifoLeaderRow>[];
    for (final item in (res['clubs'] as List?) ?? const []) {
      if (item is Map) {
        final r = TifoLeaderRow.fromJson(item.cast<String, dynamic>());
        if (r != null) {
          out.add(r);
        }
      }
    }
    return out;
  }

  /// District polygons (fetch once). `GET /districts`.
  Future<List<TifoDistrict>> getDistricts({CancelToken? cancelToken, TifoRequestTiming? timing}) async {
    final res = await _get('/districts', cancelToken: cancelToken, timing: timing);
    final out = <TifoDistrict>[];
    for (final item in (res['items'] as List?) ?? const []) {
      if (item is Map) {
        final d = TifoDistrict.fromJson(item.cast<String, dynamic>());
        if (d != null) {
          out.add(d);
        }
      }
    }
    return out;
  }

  /// All district standings in one call (poll for the low-zoom paint).
  /// `GET /districts/summary`. Returned keyed by district id.
  Future<Map<String, TifoDistrictSummary>> getDistrictsSummary({TifoRequestTiming? timing}) async {
    final res = await _get('/districts/summary', timing: timing);
    final out = <String, TifoDistrictSummary>{};
    for (final item in (res['districts'] as List?) ?? const []) {
      if (item is Map) {
        final s = TifoDistrictSummary.fromJson(item.cast<String, dynamic>());
        if (s != null) {
          out[s.id] = s;
        }
      }
    }
    return out;
  }

  /// One-time season club pick; grants the welcome token bonus server-side.
  Future<void> selectClub(String clubId) => _post('/clubs/select', body: {'club': clubId});

  /// Claims the daily allowance (US-15, API v2.4 §4.5). Idempotent per game
  /// day (00:00 Asia/Riyadh, computed server-side) — nothing credits it on its
  /// own, the client has to ask.
  Future<TifoDailyGrant> claimDailyAllowance() async => TifoDailyGrant.fromJson(await _post('/tokens/daily'));

  /// Rewards a completed Balady+ trip (US-16, API v2.4 §4.5). Idempotent per
  /// [tripId]: a replay returns `alreadyRewarded` and credits nothing.
  /// [distanceKm] is required for the server's "minimum 1 km" qualification
  /// check — without it every trip fails validation and earns nothing.
  Future<TifoTripReward> completeTrip(String tripId, double distanceKm) async => TifoTripReward.fromJson(
    await _post('/trips/complete', body: {'tripId': tripId, 'distanceKm': distanceKm}),
  );

  Future<void> completeOnboarding() => _post('/onboarding/complete');

  Future<void> completeTutorial() => _post('/tutorial/complete');

  Future<TifoPlaySession> startPlay(String buildingId) async {
    final res = await _post('/buildings/$buildingId/play/start');
    return TifoPlaySession.fromJson(res);
  }

  Future<TifoPlayResult> submitPlay({
    required String buildingId,
    required String sessionId,
    required int score,
    List<Object?> events = const [],
    bool earlyEnd = false,
  }) async {
    final res = await _post(
      '/buildings/$buildingId/play',
      body: {
        'sessionId': sessionId,
        'score': score,
        'events': events,
        'earlyEnd': earlyEnd,
      },
    );
    return TifoPlayResult.fromJson(res);
  }

  Future<Map<String, dynamic>> _get(String path, {CancelToken? cancelToken, TifoRequestTiming? timing}) =>
      _request(path, isPost: false, cancelToken: cancelToken, timing: timing);

  Future<Map<String, dynamic>> _post(String path, {Object? body}) => _request(path, isPost: true, body: body);

  /// The one place a TIFO request is actually issued — folded so [TifoRequestTiming] exists
  /// once instead of per verb. Only the dio call is timed: [_resolve] may open a login flow,
  /// and parsing belongs to `render_ms`, not the backend.
  Future<Map<String, dynamic>> _request(
    String path, {
    required bool isPost,
    Object? body,
    CancelToken? cancelToken,
    TifoRequestTiming? timing,
  }) async {
    final cfg = await _resolve();
    final stopwatch = timing == null ? null : (Stopwatch()..start());
    try {
      final response = isPost
          ? await _dio.post<dynamic>(
              _url(cfg.baseUrl, path),
              data: body,
              options: _options(cfg.token),
              cancelToken: cancelToken,
            )
          : await _dio.get<dynamic>(
              _url(cfg.baseUrl, path),
              options: _options(cfg.token),
              cancelToken: cancelToken,
            );
      if (stopwatch != null) {
        timing!.add(stopwatch.elapsed);
      }
      return _asMap(response.data);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Map<String, dynamic> _asMap(Object? data) {
    if (data is Map) {
      return data.cast<String, dynamic>();
    }
    return const {};
  }

  TifoApiException _mapError(DioException e) {
    final data = e.response?.data;
    var message = e.message ?? 'Network error';
    if (data is Map) {
      final detail = data['detail'];
      if (detail is List && detail.isNotEmpty && detail.first is Map) {
        message = (detail.first as Map)['msg']?.toString() ?? message;
      } else if (data['message'] != null) {
        message = data['message'].toString();
      }
    }
    return TifoApiException(e.response?.statusCode, message);
  }
}

final tifoApiProvider = Provider<TifoApi>(
  (ref) => TifoApi(
    () => resolveTifoConfig(ref),
    localeCode: () => ref.read(appLanguageProvider).baladyCompat,
  ),
);
