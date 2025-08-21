import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'app_feedback_dio.g.dart';

@riverpod
Future<Dio> appFeedbackDio(Ref ref) async {
  final baseDio = await ref.watch(dGisHttpService.future);
  final env = await ref.watch(dgisEnvironmentProvider.future);

  final dio = Dio(
    baseDio.options.copyWith(
      baseUrl: env.appFeedbackApi,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseData: false,
      ),
    ),
  );
  return dio;
}
