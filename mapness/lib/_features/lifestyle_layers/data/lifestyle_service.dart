
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LifestyleLayersService {

  LifestyleLayersService({required this.dio}) {

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (cert, host, port) => true;
      return client;
    };
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    // dio.options.headers = {};
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      responseHeader: true,
    ),);
  }
  final Dio dio;
}
