import 'package:dio/dio.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

part 'base_dio.g.dart';

@riverpod
class BaseDio extends _$BaseDio {
  @override
  Dio build() {
    final dio = Dio();
    if (logger is TalkerMapnessLogger) {
      dio.interceptors.add(
        TalkerDioLogger(
          talker: (logger as TalkerMapnessLogger).talker,
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,

            /// Since protobufs are just binary files what a purpose to print it
            printResponseData: false,
          ),
        ),
      );
    }
    return dio;
  }
}
