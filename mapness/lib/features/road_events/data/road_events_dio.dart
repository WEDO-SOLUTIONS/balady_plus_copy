import 'package:dio/dio.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'road_events_dio.g.dart';

/// Client API key from the Road Event Service Postman collection — a public,
/// non-secret client-side gate (same key is committed to the collection),
/// mirroring the `dynamic_poi_dio.dart` pattern for a feature-specific key.
const _clientApiKey = '934442d7-8861-4ddc-86d5-d82f596add9f';

@riverpod
Future<Dio> roadEventsDio(Ref ref) async {
  final baseDio = await ref.watch(dGisHttpService.future);
  final env = await ref.watch(dgisEnvironmentProvider.future);
  final userInfo = await ref.watch(authProvider.future);

  final dio = Dio(
    baseDio.options.copyWith(
      baseUrl: env.roadEventApi,
      headers: {
        ...baseDio.options.headers,
        'x-api-key': _clientApiKey,
        if (userInfo?.idNo != null) 'x-user-ref': userInfo!.idNo,
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  // `dGisHttpService`'s interceptors carry the Bearer-token auth injection,
  // 401 refresh-and-retry, logging, cache and retry behavior — unlike
  // `feedback_dio.dart`, which drops these by not copying `interceptors`.
  dio.interceptors.addAll(baseDio.interceptors);
  return dio;
}
