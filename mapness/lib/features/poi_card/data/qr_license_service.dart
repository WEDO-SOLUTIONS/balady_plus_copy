import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
  }
  final Dio dio;
}
