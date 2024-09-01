import 'package:dio/dio.dart';
import 'package:mapness/features/share_eta/models/eta_stream_info.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/features/sso_auth/data/token_provider.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eta_service_provider.g.dart';

@riverpod
class EtaService extends _$EtaService {
  String? _baseUrl;

  Dio? _dio;

  @override
  Future<EtaStreamInfo?> build() async {
    await _init();
    return null;
  }

  Future<void> _init() async {
    // Get share eta base url
    final env = await ref.read(dgisEnvironmentProvider.future);
    final token = await ref.read(tokenProvider.future);

    _baseUrl = env.shareEtaApi;

    _dio = Dio();

    if (_dio != null && token.isNotEmpty) {
      _dio!.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<void> startEtaStream(EtaStreamPayload payload) async {
    await _init();

    if (_dio == null) {
      state = AsyncError(Exception('Dio is not initialized'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    try {
      final response = await _dio!.post(
        '$_baseUrl/v1/geolocation/stream',
        data: payload.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final etaStreamInfo =
            EtaStreamInfo.fromJson(data).copyWith(xStreamData: response.headers.map['x-stream-data']?.firstOrNull);
        state = AsyncData(etaStreamInfo);
      } else {
        state = AsyncError(Exception('Failed to start ETA stream'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> stopEtaStream(String tokenId, String xStreamData) async {
    await _init();

    if (_dio == null) {
      state = AsyncError(Exception('Dio is not initialized'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    final headers = _dio!.options.headers
      ..addAll({
        'X-Stream-Data': xStreamData,
        'GeoStreamingToken': tokenId,
      });

    try {
      final response = await _dio!.delete(
        '$_baseUrl/v1/geolocation/stream',
        options: Options(
          headers: headers,
        ),
      );

      if (response.statusCode == null) {
        state = AsyncError(Exception('Failed to stop ETA stream'), StackTrace.current);
        return;
      }

      final statusCode = response.statusCode!;

      if (statusCode < 200 && statusCode >= 300) {
        state = AsyncError(Exception('Failed to stop ETA stream'), StackTrace.current);
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateEtaStream() async {
    await _init();

    if (_dio == null) {
      state = AsyncError(Exception('Dio is not initialized'), StackTrace.current);
      return;
    }

    try {
      final response = await _dio!.get(
        '$_baseUrl/v1/geolocation/stream',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final etaStreamInfo = EtaStreamInfo.fromJson(data);
        state = AsyncData(etaStreamInfo);
      } else {
        state = AsyncError(Exception('Failed to update ETA stream'), StackTrace.current);
      }
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
