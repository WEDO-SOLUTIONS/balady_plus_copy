import 'package:dio/dio.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'bss_dio.g.dart';

@riverpod
Future<Dio> bssDio(Ref ref) async {
  final env = await ref.read(dgisEnvironmentProvider.future);
  final url = env.bssApi;
  final dio = Dio(
    BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
    ),
  );

  //// To detect requests in Proxyman app we have to proxy it to localhost:9090
  //// If you use Proxyman uncomment this lines
  // const proxy = 'localhost:9090';
  // (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
  //   client.findProxy = (uri) => 'PROXY $proxy;';
  //   return client;
  // };

  if (logger is TalkerMapnessLogger) {
    dio.interceptors.add(
      TalkerDioLogger(
        talker: (logger as TalkerMapnessLogger).talker,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseData: false,
        ),
      ),
    );
  }

  return dio;
}
