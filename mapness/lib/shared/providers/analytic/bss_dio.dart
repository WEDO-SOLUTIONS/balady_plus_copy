import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/dgis_http_network.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'bss_dio.g.dart';

@riverpod
Future<Dio> bssDio(Ref ref) async {
  final baseDio = await ref.read(dGisHttpService.future);
  final env = await ref.read(dgisEnvironmentProvider.future);

  final dio = Dio(baseDio.options.copyWith(
    baseUrl: env.bssApi,
    connectTimeout: const Duration(seconds: 120),
    receiveTimeout: const Duration(seconds: 120),
    sendTimeout: const Duration(seconds: 120),
  ));

  dio.interceptors.add(
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
      ),
    ),
  );

  return dio;
}
