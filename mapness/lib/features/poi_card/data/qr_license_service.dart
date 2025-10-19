import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/shared/utils/logger/talker_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

class QrLicenseService {
  QrLicenseService({required this.dio}) {
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      /// Create a http client with default settings for fetching a qr license
      const defaultClientTimeout = Duration(seconds: 3);
      final client = HttpClient()
        ..idleTimeout = defaultClientTimeout
        ..badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {};
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
  }
  final Dio dio;
}
