import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class WebServiceWeather {
  WebServiceWeather({
    required this.dio,
    required String baseUrl,
  }) {
    (dio.httpClientAdapter as IOHttpClientAdapter).validateCertificate = (cert, host, port) => true;

    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {};
    dio.interceptors.add(
      PrettyDioLogger(
        responseBody: false,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
  final Dio dio;
}
