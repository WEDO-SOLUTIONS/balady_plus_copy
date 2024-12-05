import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mapness/features/statistic/model/statistics_request.dart';

class BssRepository {
  final Dio dio;

  BssRepository({required this.dio});

  Future<void> sendStatistics(BssPayload request) async {
    await dio.post(
      '/bss/3',
      data: jsonEncode(request),
    );
  }
}
