import 'dart:convert';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
import 'package:mapness/features/sso_auth/data/token_provider.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';

/// Debug-only overrides for the TIFO backend. Empty fields fall back to the
/// system config. Applied ONLY when [tifoDebugModeProvider] is on — in normal
/// operation the feature ignores these and uses system auth + env base URL.
@immutable
class TifoConfig {
  const TifoConfig({this.baseUrl = '', this.userToken = ''});

  final String baseUrl;
  final String userToken;

  TifoConfig copyWith({String? baseUrl, String? userToken}) => TifoConfig(
    baseUrl: baseUrl ?? this.baseUrl,
    userToken: userToken ?? this.userToken,
  );
}

class TifoDebugConfigController extends Notifier<TifoConfig> {
  @override
  TifoConfig build() => const TifoConfig();

  void setBaseUrl(String value) => state = state.copyWith(baseUrl: value.trim());

  void setUserToken(String value) => state = state.copyWith(userToken: value.trim());
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

/// The TIFO backend is deployed on staging only, so the game intentionally
/// pins that host on every app environment (prod included) instead of
/// following `dgisEnvironmentProvider`. Re-point (or re-derive from the env)
/// once TIFO ships to production.
const kTifoBaseUrl = 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/tifo';

/// The effective TIFO base URL + bearer, resolved per request.
///
/// Base URL is [kTifoBaseUrl]. Bearer is the system SSO access token
/// (`tokenProvider`), so TIFO shares the app's login. Debug overrides only win
/// when [tifoDebugModeProvider] is on. [TifoResolvedConfig.isGuest] is true
/// when the bearer is the device fallback: staging lazily registers a profile
/// for ANY bearer, so `/me` succeeding does NOT mean the user is signed in —
/// gate login on this flag, not on the profile.
typedef TifoResolvedConfig = ({String baseUrl, String token, bool isGuest});

Future<TifoResolvedConfig> resolveTifoConfig(Ref ref) async {
  final debug = ref.read(tifoDebugModeProvider);
  final override = debug ? ref.read(tifoDebugConfigProvider) : const TifoConfig();

  final baseUrl = override.baseUrl.isEmpty ? kTifoBaseUrl : override.baseUrl;

  var token = override.userToken;
  if (token.isEmpty) {
    try {
      // Triggers the provider's expiry check/refresh side effect; its cached
      // value is NOT trusted below.
      await ref.read(tokenProvider.future);
    } catch (_) {
      // No session — fall through to the guest bearer.
    }
    // Read the LIVE cubit value, not the provider cache: the cache is fed by
    // a stream subscription that can outlive a logout, and staging accepts
    // any bearer as an opaque user id — a stale token silently keeps
    // impersonating the previous user.
    token = CommonProperties.token;
  }
  if (token.isNotEmpty) {
    return (baseUrl: baseUrl, token: _stableBearer(token), isGuest: false);
  }
  // Not signed in. The backend requires SOME bearer even for browse (401
  // otherwise), and staging treats it as an opaque user id — identify the
  // guest by device so browsing works pre-login (BRD US-01).
  try {
    final device = await ref.read(deviceInfoProvider.future);
    token = 'tifo-guest-${device.deviceId ?? 'unknown'}';
  } catch (_) {
    token = 'tifo-guest-unknown';
  }
  return (baseUrl: baseUrl, token: token, isGuest: true);
}

/// Staging keys the player by the RAW bearer string (verified live:
/// `/me` returns `userId` == the bearer, JWTs are NOT decoded — two tokens
/// with the same `sub` get two profiles). Sending the SSO JWT as-is would
/// mint a fresh profile on every re-login and token refresh, losing the
/// club/balance each time.
///
/// Key the player by the PERSON, not the session: sha256 of the
/// national/iqama id — it's identical across every login method (Nafath/SSO
/// mints one `sub`, OTP another; the id number never changes), and the hash
/// keeps PII off the wire. JWT/host `sub` is only a fallback for sessions
/// where userInfo hasn't arrived. Remove once the backend validates tokens
/// itself.
String _stableBearer(String ssoToken) {
  final idNo = CommonProperties.userInfo?.idNo;
  if (idNo != null && idNo.isNotEmpty) {
    return 'tifo-uid-${sha256.convert(utf8.encode(idNo))}';
  }
  final sub = _jwtSub(ssoToken) ?? CommonProperties.userInfo?.sub;
  if (sub != null && sub.isNotEmpty) {
    return 'tifo-sso-$sub';
  }
  return ssoToken;
}

String? _jwtSub(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    return null;
  }
  try {
    final payload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
    return payload is Map ? payload['sub']?.toString() : null;
  } catch (_) {
    return null;
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
  TifoApi(this._resolve);

  final Future<TifoResolvedConfig> Function() _resolve;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Options _options(String token) => Options(
    headers: {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    },
  );

  String _url(String baseUrl, String path) {
    final sep = path.contains('?') ? '&' : '?';
    return '$baseUrl$path${sep}locale=en';
  }

  /// `GET /buildings?bbox=minLng,minLat,maxLng,maxLat`. [cancelToken] lets the
  /// map layer abort a stale viewport request when the camera moves again.
  Future<List<TifoBuilding>> getBuildings(String bbox, {CancelToken? cancelToken}) async {
    final res = await _get('/buildings?bbox=$bbox', cancelToken: cancelToken);
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

  Future<TifoProfile> getMe() async => TifoProfile.fromJson(await _get('/me'));

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
  Future<List<TifoLeaderRow>> getLeaderboards() async {
    final res = await _get('/leaderboards?scope=clubs');
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
  Future<List<TifoDistrict>> getDistricts({CancelToken? cancelToken}) async {
    final res = await _get('/districts', cancelToken: cancelToken);
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
  Future<Map<String, TifoDistrictSummary>> getDistrictsSummary() async {
    final res = await _get('/districts/summary');
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

  Future<Map<String, dynamic>> _get(String path, {CancelToken? cancelToken}) async {
    final cfg = await _resolve();
    try {
      final response = await _dio.get<dynamic>(
        _url(cfg.baseUrl, path),
        options: _options(cfg.token),
        cancelToken: cancelToken,
      );
      return _asMap(response.data);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> _post(String path, {Object? body}) async {
    final cfg = await _resolve();
    try {
      final response = await _dio.post<dynamic>(_url(cfg.baseUrl, path), data: body, options: _options(cfg.token));
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

final tifoApiProvider = Provider<TifoApi>((ref) => TifoApi(() => resolveTifoConfig(ref)));
