import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_config.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_ipv4_http_client.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_service_token.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_on_map_network.g.dart';

/// Fresh, feature-scoped Dio client for the real Friends on Map backend —
/// same per-feature-Dio convention as `shared/providers/dgis_network.dart`
/// et al. (a fresh `Dio(BaseOptions(baseUrl: ...))`, not a clone of the
/// shared `baseDioProvider`). Not the shared `AuthTokenInterceptor`: this
/// backend's bearer is its own test-login token, not the app's real SSO
/// token — see `friends_on_map_service_token.dart`. Building the `Dio`
/// instance itself needs nothing async (the base URL is a constant), so this
/// stays a plain, synchronously-available provider; only the per-request
/// token lookup is async.
@Riverpod(keepAlive: true)
Dio friendsOnMapNetwork(Ref ref) {
  final dio = Dio(BaseOptions(baseUrl: friendsOnMapApiBaseUrl))
    ..httpClientAdapter = IOHttpClientAdapter(createHttpClient: createIpv4PreferringHttpClient);
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!ref.mounted) {
          handler.next(options);
          return;
        }
        final token = await ref.read(friendsOnMapServiceTokenProvider.future);
        handler.next(options.copyWith(headers: {...options.headers, 'Authorization': 'Bearer $token'}));
      },
    ),
  );
  // This personal test deployment's `fly.toml` has `auto_stop_machines =
  // 'stop'` / `min_machines_running = 0` — the machine can be fully asleep
  // and the first request after idle can hit a cold-start window where the
  // connection drops before a response completes (`HttpException:
  // Connection closed before full header was received`, confirmed hit on a
  // real device). A longer wait than the app's other `RetryInterceptor`
  // uses (`dgis_network.dart`'s 2×1s) is deliberate: a cold start can take a
  // few seconds, not just a transient blip.
  dio.interceptors.add(
    RetryInterceptor(
      dio: dio,
      logPrint: (message) => logger.log('friends_on_map RETRY LOG: $message', logLevel: MapnessLogLevel.critical),
      // retries: 3 is RetryInterceptor's own default — left implicit rather
      // than restated.
      retryDelays: const [Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 3)],
      // S-10: `defaultRetryableStatuses` includes 429. Left as-is, a limit
      // response would get silently auto-retried 3x before ever reaching
      // the repository/mapper — defeating Retry-After, and (for
      // `inviteResolutionRateLimited`) burning extra attempts against the
      // very rolling-hour counter R-40 requires counting failures towards.
      retryEvaluator: DefaultRetryEvaluator({...defaultRetryableStatuses}..remove(status429TooManyRequests)).evaluate,
    ),
  );
  return dio;
}
