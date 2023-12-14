import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LifestyleLayersService {
  final Dio dio;

  LifestyleLayersService({required this.dio}) {

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // curl -k -l 'https://sa1.ops.2gis.dev/v1/gis-urbi-services/layers/1' \
    // -H 'verifyingKEY: pW70C4zvLRd6bgXmJxuQoVVaBeGdLBah/BpwSkEU36w='
    // dio.options.baseUrl = "https://sa1.ops.2gis.dev/v1/gis-urbi-services/layers/";
    dio.options.connectTimeout = const Duration(milliseconds: 60000);
    dio.options.receiveTimeout = const Duration(milliseconds: 60000);
    dio.options.sendTimeout = const Duration(milliseconds: 60000);
    dio.options.headers = {};
    dio.interceptors.add(PrettyDioLogger(
      responseBody: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true
    ));
  }
}
