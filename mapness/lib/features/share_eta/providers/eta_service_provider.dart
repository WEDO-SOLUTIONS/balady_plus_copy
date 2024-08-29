import 'package:dio/dio.dart';
import 'package:mapness/features/share_eta/models/eta_stream_info.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'eta_service_provider.g.dart';

@riverpod
class EtaService extends _$EtaService {
  //TODO: Replace with actual base URL
  final baseUrl = 'url_here';

  Dio? _dio;

  @override
  Future<EtaStreamInfo?> build() async {
    _dio = ref.watch(baseDioProvider);
    return null;
  }

  Future<void> startEtaStream(EtaStreamPayload payload) async {
    if (_dio == null) {
      state = AsyncError(Exception('Dio is not initialized'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    try {
      final response = await _dio!.post(
        '$baseUrl/v1/geolocation/stream',
        data: payload.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final etaStreamInfo = EtaStreamInfo.fromJson(data);
        state = AsyncData(etaStreamInfo);
      } else {
        state = AsyncError(Exception('Failed to start ETA stream'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> stopEtaStream(String streamId) async {
    if (_dio == null) {
      state = AsyncError(Exception('Dio is not initialized'), StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    try {
      final response = await _dio!.delete(
        '$baseUrl/v1/geolocation/stream',
        data: {'streamId': streamId},
      );

      if (response.statusCode == 200) {
        state = const AsyncData(null);
      } else {
        state = AsyncError(Exception('Failed to stop ETA stream'), StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateEtaStream() async {
    if (_dio == null) {
      state = AsyncError(Exception('Dio is not initialized'), StackTrace.current);
      return;
    }

    try {
      final response = await _dio!.get(
        '$baseUrl/v1/geolocation/stream',
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
