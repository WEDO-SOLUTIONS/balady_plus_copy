import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';

/// Base URL + auth for the TIFO staging backend. The prototype uses the user
/// id itself as the bearer token; [userToken] must be a *registered* user id
/// or every call 401s. Overridable at runtime (debug panel) via
/// [tifoConfigProvider].
@immutable
class TifoConfig {
  const TifoConfig({required this.baseUrl, required this.userToken});

  final String baseUrl;
  final String userToken;

  static const String stagingBaseUrl = 'https://urbi-lifestyle-stg.momah.gov.sa/1.0/api/v1/tifo';

  TifoConfig copyWith({String? baseUrl, String? userToken}) => TifoConfig(
    baseUrl: baseUrl ?? this.baseUrl,
    userToken: userToken ?? this.userToken,
  );
}

class TifoConfigController extends Notifier<TifoConfig> {
  @override
  TifoConfig build() => const TifoConfig(baseUrl: TifoConfig.stagingBaseUrl, userToken: '');

  void setBaseUrl(String value) => state = state.copyWith(baseUrl: value.trim());

  void setUserToken(String value) => state = state.copyWith(userToken: value.trim());
}

final tifoConfigProvider = NotifierProvider<TifoConfigController, TifoConfig>(TifoConfigController.new);

/// Thrown for non-2xx responses so callers can surface the backend's message.
class TifoApiException implements Exception {
  TifoApiException(this.statusCode, this.message);

  final int? statusCode;
  final String message;

  @override
  String toString() => 'TifoApiException($statusCode): $message';
}

class TifoApi {
  TifoApi(this._read);

  final TifoConfig Function() _read;

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Options _options() {
    final cfg = _read();
    return Options(
      headers: {
        'Content-Type': 'application/json',
        if (cfg.userToken.isNotEmpty) 'Authorization': 'Bearer ${cfg.userToken}',
      },
    );
  }

  String _url(String path) {
    final cfg = _read();
    final sep = path.contains('?') ? '&' : '?';
    return '${cfg.baseUrl}$path${sep}locale=en';
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

  Future<TifoProfile> getMe() async => TifoProfile.fromJson(await _get('/me'));

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
    try {
      final response = await _dio.get<dynamic>(_url(path), options: _options(), cancelToken: cancelToken);
      return _asMap(response.data);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> _post(String path, {Object? body}) async {
    try {
      final response = await _dio.post<dynamic>(_url(path), data: body, options: _options());
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

final tifoApiProvider = Provider<TifoApi>((ref) => TifoApi(() => ref.read(tifoConfigProvider)));
