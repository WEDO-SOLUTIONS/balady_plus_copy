import 'package:dio/dio.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dynamic_poi_dio.g.dart';

/// Dio configured with the Urbi Lifestyle staging X-API-Key.
///
/// The endpoint lives at `<env-host>/1.0/dynamic-markers` (note: NOT under
/// `/api/1.0/` — that path returns 404 even though `env.url` includes it).
/// Pattern mirrors `bus_departures/providers/dio_provider.dart`.
@Riverpod(keepAlive: true)
Dio dynamicPoiDio(Ref ref) {
  // Staging API key per task spec (.task/dynamic-poi.md). Not a sensitive
  // secret — same key is in the Postman collection committed to .task/.
  const apiKey = '7945b9d8-1e95-4c1b-8886-d6a4c6c69e73';

  final base = ref.read(baseDioProvider);
  final dio = Dio(
    base.options.copyWith(
      headers: {
        ...base.options.headers,
        'X-API-Key': apiKey,
      },
    ),
  );
  dio.interceptors.addAll(base.interceptors);
  return dio;
}
