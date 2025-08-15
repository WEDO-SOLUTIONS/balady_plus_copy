import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'base_dio.g.dart';

@riverpod
class BaseDio extends _$BaseDio {
  @override
  Dio build() {
    final dio = Dio();

    dio.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
          printResponseData: false,
          printErrorData: false,
        ),
      ),
    );
    return dio;
  }
}
