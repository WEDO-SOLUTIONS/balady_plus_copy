import 'package:dio/dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_dio.g.dart';

@riverpod
/// Provides a [Dio] instance for feedback API requests.
///
/// Uses [dGisHttpService] for base configuration and [dgisEnvironmentProvider]
/// for the feedback API endpoint.
///
/// Returns a [Future<Dio>] configured for feedback operations.
Future<Dio> feedbackDio(Ref ref) async {
  final baseDio = await ref.watch(dGisHttpService.future);
  final env = await ref.watch(dgisEnvironmentProvider.future);

  return Dio(
    baseDio.options.copyWith(
      baseUrl: env.feedbackApi,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
    ),
  );
}
